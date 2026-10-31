#include "motion60_clip_pl.h"
static uint32_t readreg(motion_clip_pl*s,uint32_t a){return s->io.read(s->io.context,a);}
static void write32(motion_clip_pl*s,uint32_t a,uint32_t v){s->io.write(s->io.context,a,v);}
static void address(motion_clip_pl*s,uint32_t a,uint32_t v){write32(s,a,v);write32(s,a+4,0);}
static void double_parameter(motion_clip_pl*s,uint32_t a,double v){union{double d;uint64_t u;}x;x.d=v;write32(s,a,(uint32_t)x.u);write32(s,a+4,(uint32_t)(x.u>>32));}
static uint32_t float_bits(float v){union{float f;uint32_t u;}x;x.f=v;return x.u;}
int motion_clip_pl_poll(motion_clip_pl*s){
 if(!s||!s->io.read||!s->clock)return -170;
 if(s->busy && (readreg(s,s->active_base)&2u)){
  uint32_t status=readreg(s,s->active_base+s->active_status);
  uint64_t elapsed=(s->clock(s->io.context)-s->started)/400u;
  if(elapsed>s->max_us)s->max_us=elapsed>0xffffffffu?0xffffffffu:(uint32_t)elapsed;
  s->busy=0;
  if(status){if(!s->error)s->error=173;}else s->completed++;
 }
 return s->error?-(int)s->error:0;
}
static int checkpoint(motion_clip_pl*s,unsigned stage,unsigned level,unsigned done,unsigned total){
 return s->progress&&s->progress(s->progress_context,stage,level,done,total);
}
static int execute(motion_clip_pl*s,uint32_t base,unsigned status,unsigned seconds,unsigned stage,unsigned level,unsigned done,unsigned total){
 if(!(readreg(s,base)&4u)){s->error=171;return -171;}
 s->active_base=base;s->active_status=status;s->started=s->clock(s->io.context);s->busy=1;
 write32(s,base,1);
 int cancelled=0;
 while(s->busy){
  if(checkpoint(s,stage,level,done,total))cancelled=1;
  int e=motion_clip_pl_poll(s);if(e)return e;
  if(s->busy && s->clock(s->io.context)-s->started>(uint64_t)seconds*400000000u){s->error=172;return -172;}
 }
 return cancelled?-154:0;
}
int motion_clip_pl_run(motion_clip_pl*s,unsigned frames,double fps,double low,double high,float alpha){
 motion_clip_layout layout;
 if(!s||!s->io.read||!s->io.write||!s->clock||s->busy||s->error||
    motion_clip_layout_make(frames,&layout)||!(fps>0&&fps<1000&&low>0&&low<high&&high<fps*.5&&alpha>=0&&alpha<=50))return -170;
 if(!s->spatial_base||!s->temporal_base||!s->copy_base||s->spatial_base==s->temporal_base||s->spatial_base==s->copy_base||s->temporal_base==s->copy_base)return -170;
 if(!(readreg(s,s->spatial_base)&4u)||!(readreg(s,s->temporal_base)&4u)||!(readreg(s,s->copy_base)&4u))return -171;
 s->completed=0;s->max_us=0;
 const uint32_t scratch=layout.work_base,bytes=CLIP_PIXELS*2u;
 if(scratch+bytes>layout.work_end)return -170;
 for(unsigned stage=0;stage<=3;stage++){
  unsigned tasks=stage==2?3:frames;
  for(unsigned t=0;t<tasks;t++){
   if(checkpoint(s,stage,stage==2?t:0,t,tasks))return -154;
   int e;
   if(stage==0){
    // Validate every RAW10/u16 pixel in PL before any phase calculation.
    // Scratch is disposable and never published if the copy reports a fault.
    uint32_t b=s->copy_base;
    address(s,b+0x10,layout.raw_base+t*bytes);address(s,b+0x1c,scratch);write32(s,b+0x28,1);
    e=execute(s,b,0x30,1,stage,0,t,frames);
   }else if(stage==2){
    uint32_t b=s->temporal_base;
    address(s,b+0x10,layout.phase_base[t]);write32(s,b+0x1c,frames);write32(s,b+0x24,CLIP_PIXELS>>(2*t));
    double_parameter(s,b+0x2c,fps);double_parameter(s,b+0x38,low);double_parameter(s,b+0x44,high);write32(s,b+0x50,1);
    e=execute(s,b,0x58,300,stage,t,t,3);
   }else{
    uint32_t b=s->spatial_base;
    address(s,b+0x10,layout.raw_base+t*bytes);address(s,b+0x1c,scratch);
    for(unsigned l=0;l<3;l++)address(s,b+0x28+12*l,layout.phase_base[l]+t*(CLIP_PIXELS>>(2*l))*4u);
    write32(s,b+0x4c,0);write32(s,b+0x54,0);write32(s,b+0x5c,0);write32(s,b+0x64,0);
    write32(s,b+0x6c,float_bits(alpha));write32(s,b+0x74,1);write32(s,b+0x7c,stage==1?1:2);
    e=execute(s,b,0x84,1,stage,0,t,frames);
    if(!e&&stage==3){
     // Only overwrite this raw frame after all phases/filtering and this
     // frame's reconstruction have completed. No in-place streaming alias.
     b=s->copy_base;address(s,b+0x10,scratch);address(s,b+0x1c,layout.raw_base+t*bytes);write32(s,b+0x28,1);
     e=execute(s,b,0x30,1,stage,0,t,frames);
    }
   }
   if(e)return e;
  }
 }
 return checkpoint(s,4,0,frames,frames)?-154:0;
}
