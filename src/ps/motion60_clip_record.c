#include "motion60_clip_record.h"
void motion_clip_record_fault(motion_clip_record*s,uint32_t reason){
 if(!s->error)s->error=reason?reason:140;
 s->ready=0;
 // Keep busy/source until the actual hardware completion drains ownership.
}
int motion_clip_record_begin(motion_clip_record*s,uint32_t frames,int masters_idle){
 motion_clip_layout layout;
 if(!masters_idle||s->busy||motion_clip_layout_make(frames,&layout))return -140;
 volatile unsigned char *clear=(volatile unsigned char*)s;
 for(unsigned i=0;i<sizeof(*s);i++)clear[i]=0;
 s->layout=layout;return 0;
}
int motion_clip_record_check(motion_clip_record*s,uint32_t write_slot,int clean,uint64_t now){
 if(!clean)motion_clip_record_fault(s,141);
 if(write_slot>=3)motion_clip_record_fault(s,142);
 if(s->busy){
  if(s->source==0x10000000u+write_slot*0x00200000u)motion_clip_record_fault(s,142);
  if(now<s->started||now-s->started>8000000u)motion_clip_record_fault(s,143);
 }
 return s->error?-(int)s->error:0;
}
int motion_clip_record_start(motion_clip_record*s,uint32_t sequence,uint32_t source,
                            uint32_t write_slot,int clean,uint64_t sample,uint64_t now){
 if(s->error)return -(int)s->error;
 if(!s->layout.frames||s->ready||s->busy){motion_clip_record_fault(s,144);return -144;}
 if(source!=0x10000000u&&source!=0x10200000u&&source!=0x10400000u){motion_clip_record_fault(s,142);return -142;}
 if(write_slot>=3||source!=0x10000000u+((write_slot+2u)%3u)*0x00200000u){
  motion_clip_record_fault(s,142);return -142;
 }
 if(sample>now){motion_clip_record_fault(s,145);return -145;}
 if(s->have_sequence&&(sequence!=s->last_sequence+1u||sample<=s->last_sample)){
  motion_clip_record_fault(s,145);return -145;
 }
 s->source=source;s->destination=s->layout.raw_base+s->committed*CLIP_PIXELS*2u;
 s->started=now;s->pending_sample=sample;s->pending_sequence=sequence;
 // Validate before the caller starts a transfer. busy is ownership, not an
 // assertion that the accelerator has already been launched.
 s->busy=1;
 int result=motion_clip_record_check(s,write_slot,clean,now);
 if(result)s->busy=0;
 return result;
}
int motion_clip_record_complete(motion_clip_record*s,uint32_t write_slot,int clean,
                               int copy_ok,uint64_t now){
 if(!s->busy){motion_clip_record_fault(s,146);return -(int)s->error;}
 motion_clip_record_check(s,write_slot,clean,now);
 if(!copy_ok)motion_clip_record_fault(s,147);
 s->busy=0;
 if(s->error)return -(int)s->error;
 if(!s->committed)s->first_sample=s->pending_sample;
 s->last_sample=s->pending_sample;s->last_sequence=s->pending_sequence;s->have_sequence=1;
 s->committed++;s->ready=s->committed==s->layout.frames;
 return 0;
}
