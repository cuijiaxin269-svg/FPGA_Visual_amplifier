#include "motion60_clip_accel.h"
static int fail(motion_clip_accel*s,unsigned e){if(!s->error)s->error=e;return -(int)s->error;}
static int region(const float *p,unsigned count){
 uintptr_t a=(uintptr_t)p;
 return !(a&3u)&&a>=CLIP_WORK_BASE&&a<CLIP_DDR_END&&count<=(CLIP_DDR_END-a)/4u;
}
static int overlap(const float*a,unsigned na,const float*b,unsigned nb){
 uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;
 return x<y+nb*4u&&y<x+na*4u;
}
int motion_clip_accel_poll(motion_clip_accel*s){
 if(!s->io.read||!s->clock)return fail(s,155);
 if(s->busy){
  uint32_t control=s->io.read(s->io.context,s->base);
  uint64_t elapsed=s->clock(s->io.context)-s->started;
  if(control&2u){
   s->busy=0;
   if(s->io.read(s->io.context,s->base+0x4c))fail(s,157);
   if(elapsed>16000000u)fail(s,156);
   if(!s->error){s->completed++;unsigned us=(unsigned)(elapsed/400u);if(us>s->max_us)s->max_us=us;}
  }else if(elapsed>16000000u)fail(s,156);
 }
 return s->error?-(int)s->error:0;
}
int motion_clip_accel_filter(void*context,const float*input,const float*kernel,float*output,unsigned frames,unsigned pixels){
 motion_clip_accel*s=(motion_clip_accel*)context;
 if(!s)return -155;
 if(s->error)return -(int)s->error;
 if(s->busy||!s->io.read||!s->io.write||!s->clock||!s->base||(s->base&4095u)||
    frames<30||frames>120||pixels<1||pixels>64)return fail(s,155);
 if(!region(input,frames*64u)||!region(output,frames*64u)||!region(kernel,frames)||
    overlap(input,frames*64u,output,frames*64u)||overlap(input,frames*64u,kernel,frames)||overlap(output,frames*64u,kernel,frames))return fail(s,155);
 if(!(s->io.read(s->io.context,s->base)&4u))return fail(s,155);
#define WRITE(offset,value) s->io.write(s->io.context,s->base+(offset),(uint32_t)(value))
 WRITE(0x10,(uintptr_t)input);WRITE(0x14,0);WRITE(0x1c,(uintptr_t)kernel);WRITE(0x20,0);
 WRITE(0x28,(uintptr_t)output);WRITE(0x2c,0);WRITE(0x34,frames);WRITE(0x3c,pixels);WRITE(0x44,1);
 s->started=s->clock(s->io.context);s->busy=1;WRITE(0,1);
#undef WRITE
 while(s->busy){int result=motion_clip_accel_poll(s);if(result)return result;}
 return s->error?-(int)s->error:0;
}
