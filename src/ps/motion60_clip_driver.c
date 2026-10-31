#include "motion60_clip_driver.h"
static void write_reg(motion_clip_driver*s,uint32_t offset,uint32_t value){s->io.write(s->io.context,s->base+offset,value);}
int motion_clip_driver_begin(motion_clip_driver*s,motion_clip_io io,uint32_t base,uint32_t frames,int masters_idle){
 if(!io.read||!io.write||!base||(base&4095u)||!masters_idle||s->record.busy)return -149;
 if(!(io.read(io.context,base)&4u))return -149;
 int result=motion_clip_record_begin(&s->record,frames,masters_idle);
 if(result)return result;
 s->io=io;s->base=base;return 0;
}
int motion_clip_driver_frame(motion_clip_driver*s,uint32_t sequence,uint32_t source,uint32_t write_slot,int clean,uint64_t sample,uint64_t now){
 if(!s->base)return -149;
 int result=motion_clip_record_start(&s->record,sequence,source,write_slot,clean,sample,now);
 if(result)return result;
 if(!(s->io.read(s->io.context,s->base)&4u)){
  // The recorder had reserved memory but has not launched a transfer yet.
  motion_clip_record_fault(&s->record,149);s->record.busy=0;return -149;
 }
 write_reg(s,0x10,s->record.source);write_reg(s,0x14,0);
 write_reg(s,0x1c,s->record.destination);write_reg(s,0x20,0);
 write_reg(s,0x28,1);write_reg(s,0,1);return 0;
}
int motion_clip_driver_poll(motion_clip_driver*s,uint32_t write_slot,int clean,uint64_t now){
 if(!s->base)return -149;
 int result=motion_clip_record_check(&s->record,write_slot,clean,now);
 // Drain even after CRC/STOP/timeout. Never clear ownership on error alone.
 if(s->record.busy&&(s->io.read(s->io.context,s->base)&2u)){
  uint32_t status=s->io.read(s->io.context,s->base+0x30);
  result=motion_clip_record_complete(&s->record,write_slot,clean,status==0,now);
 }
 return result;
}
