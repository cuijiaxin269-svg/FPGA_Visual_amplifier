#include "motion60_clip_process.h"
#include <math.h>
int motion_clip_processor_bind(unsigned frames,motion_clip_processor*p){
 motion_clip_layout layout;
 if(!p||motion_clip_layout_make(frames,&layout))return -151;
 const unsigned n=CLIP_PIXELS;
 uint32_t end=layout.work_base+4u*(4u*n+n+n/4u+n/16u+n/64u+2u*120u*64u+120u);
 if(end>layout.work_end)return -151;
 uintptr_t address=layout.work_base;
#define BIND(pointer,count) do{(pointer)=(float*)address;address+=(uintptr_t)(count)*4u;}while(0)
 BIND(p->spatial.a,n);BIND(p->spatial.b,n);BIND(p->spatial.tmp,n);BIND(p->spatial.next,n);
 BIND(p->spatial.band[0],n);BIND(p->spatial.band[1],n/4u);BIND(p->spatial.band[2],n/16u);BIND(p->spatial.residual,n/64u);
 BIND(p->tile_in,120u*64u);BIND(p->tile_out,120u*64u);BIND(p->kernel,120u);
#undef BIND
 for(unsigned level=0;level<3;level++)p->phase[level]=(float*)(uintptr_t)layout.phase_base[level];
 return 0;
}
static int progress(motion_clip_processor*p,unsigned stage,unsigned level,unsigned done,unsigned total){
 return p->progress&&p->progress(p->context,stage,level,done,total)?-154:0;
}
int motion_clip_process(uint16_t*raw,unsigned frames,unsigned w,unsigned h,
                        double fps,double lo,double hi,float alpha,motion_clip_processor*p){
 if(!raw||!p||!p->filter||frames<30||frames>120||w<64||h<64||w>1280||h>800||(w&7)||(h&7)||
    !isfinite(fps)||!isfinite(lo)||!isfinite(hi)||!isfinite(alpha)||!(0<lo&&lo<hi&&hi<fps*.5)||alpha<0||alpha>50)return -151;
 if(!p->tile_in||!p->tile_out||!p->kernel||!p->phase[0]||!p->phase[1]||!p->phase[2]||
    !p->spatial.a||!p->spatial.b||!p->spatial.tmp||!p->spatial.next||!p->spatial.residual||
    !p->spatial.band[0]||!p->spatial.band[1]||!p->spatial.band[2])return -151;
 unsigned n=w*h;
 // Never normalize or repair invalid pixels. A bad clip cannot be processed.
 for(unsigned t=0;t<frames;t++){
  if(progress(p,0,0,t,frames))return -154;
  for(unsigned i=0;i<n;i++)if(raw[t*n+i]>1023)return -152;
 }
 const double pi=3.1415926535897932384626433832795;
 for(unsigned lag=0;lag<frames;lag++){
  double value=0;
  for(unsigned k=1;k<=(frames/2);k++){
   double frequency=(double)k*fps/(double)frames;
   if(frequency>=lo&&frequency<=hi){
    double weight=(2*k==frames)?1.0:2.0;
    value+=weight*cos(2*pi*(double)k*(double)lag/(double)frames)/(double)frames;
   }
  }
  p->kernel[lag]=(float)value;
 }
 for(unsigned t=0;t<frames;t++){
  if(progress(p,1,0,t,frames))return -154;
  if(motion_clip_decompose(raw+t*n,w,h,&p->spatial))return -151;
  for(unsigned level=0;level<3;level++)motion_clip_phase(&p->spatial,w,h,level,p->phase[level]+t*(n>>(2*level)));
 }
 for(unsigned level=0;level<3;level++){
  unsigned size=n>>(2*level);float *phase=p->phase[level];
  for(unsigned start=0;start<size;start+=64){
   if(progress(p,2,level,start,size))return -154;
   unsigned pixels=size-start<64?size-start:64;
   for(unsigned x=0;x<pixels;x++){
    float initial=phase[start+x],previous=initial,offset=0;
    for(unsigned t=0;t<frames;t++){
     float value=phase[t*size+start+x],difference=value-previous;
     if(difference>3.14159265358979323846f)offset-=6.2831853071795864769f;
     if(difference<-3.14159265358979323846f)offset+=6.2831853071795864769f;
     previous=value;p->tile_in[t*64+x]=(value+offset)-initial;
    }
   }
   if(p->filter(p->context,p->tile_in,p->kernel,p->tile_out,frames,pixels))return -153;
   for(unsigned t=0;t<frames;t++)for(unsigned x=0;x<pixels;x++){
    float value=p->tile_out[t*64+x];if(!isfinite(value))return -153;
    phase[t*size+start+x]=value;
   }
  }
 }
 for(unsigned t=0;t<frames;t++){
  if(progress(p,3,0,t,frames))return -154;
  if(motion_clip_decompose(raw+t*n,w,h,&p->spatial))return -151;
  const float *delta[3];for(unsigned level=0;level<3;level++)delta[level]=p->phase[level]+t*(n>>(2*level));
  motion_clip_reconstruct(&p->spatial,w,h,delta,alpha,raw+t*n);
 }
 return progress(p,4,0,frames,frames);
}
