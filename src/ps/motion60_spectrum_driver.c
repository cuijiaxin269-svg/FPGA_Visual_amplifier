#include "motion60_spectrum_driver.h"
static uint32_t read32(motion_spectrum_driver*s,uint32_t a){return s->io.read(s->io.context,a);}
static void write32(motion_spectrum_driver*s,uint32_t a,uint32_t v){s->io.write(s->io.context,a,v);}
static uint32_t bits(float f){union{float f;uint32_t u;}v;v.f=f;return v.u;}
static float number(uint32_t u){union{float f;uint32_t u;}v;v.u=u;return v.f;}
static int fail(motion_spectrum_driver*s,uint32_t error){s->error=error;return -(int)error;}
static void state(motion_spectrum_driver*s,uint32_t value){if(s->state!=value){s->state=value;s->dirty=1;}}
void motion_spectrum_invalidate(motion_spectrum_driver*s,uint32_t value){
 motion_spectrum_window_reset(&s->window);s->roi_first=1;state(s,value);
}
int motion_spectrum_driver_init(motion_spectrum_driver*s,motion_spectrum_io io){
 // Do not call while either accelerator owns memory; init follows PL reset.
 // Volatile byte stores prevent an implicit libc memset in this freestanding ELF.
 volatile unsigned char *clear=(volatile unsigned char*)s;
 for(unsigned i=0;i<sizeof(*s);i++)clear[i]=0;
 s->io=io;
 if(!io.read||!io.write)return fail(s,120);
 if(read32(s,SPECTRUM_OSD_BASE)!=0x4f534431u)return fail(s,121);
 motion_spectrum_window_init(&s->window);s->roi_first=1;s->x=512;s->y=272;
 s->enable=1;s->dirty=1;
 write32(s,SPECTRUM_ROI_BASE+0x1c,SPECTRUM_ROI_RESULT);write32(s,SPECTRUM_ROI_BASE+0x20,0);
 write32(s,SPECTRUM_FFT_BASE+0x10,SPECTRUM_FFT_INPUT);write32(s,SPECTRUM_FFT_BASE+0x14,0);
 write32(s,SPECTRUM_FFT_BASE+0x1c,SPECTRUM_FFT_OUTPUT);write32(s,SPECTRUM_FFT_BASE+0x20,0);
 return 0;
}
int motion_spectrum_roi_configure(motion_spectrum_driver*s,uint32_t x,uint32_t y){
 if(s->roi_busy||x>1024||y>544)return -122;
 s->x=x;s->y=y;motion_spectrum_invalidate(s,0);return 0;
}
int motion_spectrum_frame_start(motion_spectrum_driver*s,uint32_t input,uint32_t sequence,int first,uint64_t now){
 if(s->error)return -(int)s->error;
 if(s->roi_busy||!(read32(s,SPECTRUM_ROI_BASE)&4u))return fail(s,123);
 if(input!=0x10000000u&&input!=0x10200000u&&input!=0x10400000u)return fail(s,124);
 if(first)motion_spectrum_invalidate(s,0);
 else if(s->window.have_sequence&&sequence!=s->window.last_sequence+1u)motion_spectrum_invalidate(s,3);
 write32(s,SPECTRUM_ROI_BASE+0x10,input);write32(s,SPECTRUM_ROI_BASE+0x14,0);
 write32(s,SPECTRUM_ROI_BASE+0x28,s->x);write32(s,SPECTRUM_ROI_BASE+0x30,s->y);
 write32(s,SPECTRUM_ROI_BASE+0x38,s->roi_first);write32(s,SPECTRUM_ROI_BASE+0x40,1);
 s->roi_sequence=sequence;s->roi_epoch=s->window.epoch;s->roi_started=now;s->roi_busy=1;
 write32(s,SPECTRUM_ROI_BASE,1);return 0;
}
static int display_poll(motion_spectrum_driver*s,uint64_t now){
 if(s->awaiting_display){
  if(read32(s,SPECTRUM_OSD_BASE+0x14)==s->expected_display)s->awaiting_display=0;
  else if(now-s->display_started>40000000u)return fail(s,130);
  else return 0;
 }
 // Abort an incomplete upload after a gap. Refill all bins before committing.
 if(s->uploading&&s->upload_epoch!=s->window.epoch){s->uploading=0;s->dirty=1;}
 if(!s->uploading&&s->dirty&&(read32(s,SPECTRUM_OSD_BASE+4)&1u)){
  s->upload_position=0;s->upload_state=s->state;s->upload_epoch=s->window.epoch;
  for(unsigned i=0;i<129;i++)s->upload[i]=s->state==1?s->bars[i]:0;
  s->uploading=1;s->dirty=0;
 }
 if(s->uploading){
  if(!(read32(s,SPECTRUM_OSD_BASE+4)&1u))return fail(s,131);
  // Bound CPU work per poll; motion completion polling must stay responsive.
  for(unsigned n=0;n<4&&s->upload_position<129;n++){
   unsigned i=s->upload_position++;
   write32(s,SPECTRUM_OSD_BASE+8,i|((uint32_t)s->upload[i]<<8));
  }
  if(s->upload_position==129){
   s->expected_display=read32(s,SPECTRUM_OSD_BASE+0x14)+1u;
   write32(s,SPECTRUM_OSD_BASE+12,(s->upload_state<<1)|s->enable);
   s->awaiting_display=1;s->display_started=now;s->uploading=0;
  }
 }
 return 0;
}
int motion_spectrum_poll(motion_spectrum_driver*s,uint64_t now){
 if(s->error)return -(int)s->error;
 if(s->roi_busy){
  uint32_t control=read32(s,SPECTRUM_ROI_BASE);
  if(now-s->roi_started>8000000u)return fail(s,125);
  if(control&2u){
   s->roi_busy=0;s->last_roi_us=(uint32_t)((now-s->roi_started)/400u);
   if(s->last_roi_us>s->max_roi_us)s->max_roi_us=s->last_roi_us;
   uint32_t result=read32(s,SPECTRUM_ROI_BASE+0x48);
   if(s->roi_epoch!=s->window.epoch){s->stale_results++;}
   else if(result==3){motion_spectrum_invalidate(s,2);}
   else if(result)return fail(s,126);
   else{
    float dx=number(read32(s,SPECTRUM_ROI_RESULT)),dy=number(read32(s,SPECTRUM_ROI_RESULT+4));
    if(!motion_spectrum_window_push(&s->window,dx,dy,s->roi_sequence,1))return fail(s,127);
    s->roi_first=0;s->valid_samples++;if(s->window.count<256)state(s,0);
   }
  }
 }
 if(s->fft_busy){
  uint32_t control=read32(s,SPECTRUM_FFT_BASE);
  if(now-s->fft_started>16000000u)return fail(s,128);
  if(control&2u){
   s->fft_busy=0;
   if(read32(s,SPECTRUM_FFT_BASE+0x30))return fail(s,129);
   if(!motion_spectrum_window_current(&s->window,&s->snapshot))s->stale_results++;
   else{
    s->clipped_bins=0;
    for(unsigned i=0;i<129;i++){
     uint16_t bar=0;
     for(unsigned axis=0;axis<2;axis++){
      uint32_t raw=read32(s,SPECTRUM_FFT_OUTPUT+4*(2*i+axis));float a=number(raw);
      if((raw&0x7f800000u)==0x7f800000u||a<0)return fail(s,132);
      // Fixed 4px full scale; presentation must label this value, no autoscale.
      unsigned height=a>=4?255u:(unsigned)(a*63.75f+.5f);
      if(a>4)s->clipped_bins++;
      bar|=(uint16_t)(height<<(8*axis));
     }
     s->bars[i]=bar;
    }
    s->fft_results++;state(s,1);s->dirty=1;
   }
  }
 }
 if(!s->fft_busy&&s->window.due&&s->window.count==256){
  if(!(read32(s,SPECTRUM_FFT_BASE)&4u))return fail(s,133);
  if(motion_spectrum_window_take(&s->window,s->frozen,&s->snapshot)){
   for(unsigned i=0;i<512;i++)write32(s,SPECTRUM_FFT_INPUT+4*i,bits(s->frozen[i]));
   write32(s,SPECTRUM_FFT_BASE+0x28,1);s->fft_busy=1;s->fft_started=now;
   write32(s,SPECTRUM_FFT_BASE,1);
  }
 }
 return display_poll(s,now);
}
