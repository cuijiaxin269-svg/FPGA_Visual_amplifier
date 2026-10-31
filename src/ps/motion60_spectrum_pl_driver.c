#include "motion60_spectrum_driver.h"
#ifndef MOTION60_PL_SPECTRUM
#error PL spectrum driver requires MOTION60_PL_SPECTRUM
#endif
// spectrum256_pl control map; verify against the exported HLS header.
#define PL_OPERATION 0x28u
#define PL_SEQUENCE 0x30u
#define PL_VALID 0x38u
#define PL_STATUS 0x40u
#define PL_COUNT 0x50u
#define PL_LAST 0x70u
#define PL_CLIPPED 0x80u
static uint32_t read32(motion_spectrum_driver*s,uint32_t a){return s->io.read(s->io.context,a);}
static void write32(motion_spectrum_driver*s,uint32_t a,uint32_t v){s->io.write(s->io.context,a,v);}
static int fail(motion_spectrum_driver*s,uint32_t error){s->error=error;return -(int)error;}
static void state(motion_spectrum_driver*s,uint32_t value){if(s->state!=value){s->state=value;s->dirty=1;}}
void motion_spectrum_invalidate(motion_spectrum_driver*s,uint32_t value){
 s->window.count=0;s->window.have_sequence=0;s->window.last_sequence=0;
 s->window.phase=s->window.due=0;s->window.epoch++;
 spectrum_ui_clear(&s->ui);
 s->sample_pending=0;s->reset_pending=1;s->roi_first=1;state(s,value);
}
int motion_spectrum_driver_init(motion_spectrum_driver*s,motion_spectrum_io io){
 volatile unsigned char *clear=(volatile unsigned char*)s;
 for(unsigned i=0;i<sizeof(*s);i++)clear[i]=0;
 s->io=io;if(!io.read||!io.write)return fail(s,120);
 if(read32(s,SPECTRUM_OSD_BASE)!=0x4f534432u)return fail(s,121);
 s->x=512;s->y=272;s->enable=1;s->dirty=1;
 motion_spectrum_invalidate(s,0);
 write32(s,SPECTRUM_ROI_BASE+0x1c,SPECTRUM_ROI_RESULT);write32(s,SPECTRUM_ROI_BASE+0x20,0);
 // PL reads the two ROI results directly; PS never touches motion samples.
 write32(s,SPECTRUM_FFT_BASE+0x10,SPECTRUM_ROI_RESULT);write32(s,SPECTRUM_FFT_BASE+0x14,0);
 write32(s,SPECTRUM_FFT_BASE+0x1c,SPECTRUM_FFT_OUTPUT);write32(s,SPECTRUM_FFT_BASE+0x20,0);
 return 0;
}
int motion_spectrum_roi_configure(motion_spectrum_driver*s,uint32_t x,uint32_t y){
 if(s->roi_busy||s->sample_pending||(s->fft_busy&&s->pl_operation==1)||x>1024||y>544)return -122;
 s->x=x;s->y=y;motion_spectrum_invalidate(s,0);return 0;
}
int motion_spectrum_frame_start(motion_spectrum_driver*s,uint32_t input,uint32_t sequence,int first,uint64_t now){
 if(s->error)return -(int)s->error;
 // ROI result memory cannot be overwritten while PL is ingesting it.
 if(s->roi_busy||s->sample_pending||(s->fft_busy&&s->pl_operation==1)||!(read32(s,SPECTRUM_ROI_BASE)&4u))return fail(s,123);
 if(input!=0x10000000u&&input!=0x10200000u&&input!=0x10400000u)return fail(s,124);
 if(first)motion_spectrum_invalidate(s,0);
 else if(s->window.have_sequence&&sequence!=s->window.last_sequence+1u)motion_spectrum_invalidate(s,3);
 write32(s,SPECTRUM_ROI_BASE+0x10,input);write32(s,SPECTRUM_ROI_BASE+0x14,0);
 write32(s,SPECTRUM_ROI_BASE+0x28,s->x);write32(s,SPECTRUM_ROI_BASE+0x30,s->y);
 write32(s,SPECTRUM_ROI_BASE+0x38,s->roi_first);write32(s,SPECTRUM_ROI_BASE+0x40,1);
 s->roi_sequence=sequence;s->roi_epoch=s->window.epoch;s->roi_started=now;s->roi_busy=1;
 write32(s,SPECTRUM_ROI_BASE,1);return 0;
}
#include "motion60_spectrum_pl_display.inc"
static void launch(motion_spectrum_driver*s,unsigned op,unsigned sequence,uint64_t now){
 write32(s,SPECTRUM_FFT_BASE+PL_OPERATION,op);write32(s,SPECTRUM_FFT_BASE+PL_SEQUENCE,sequence);
 write32(s,SPECTRUM_FFT_BASE+PL_VALID,1);
 s->pl_operation=op;s->pl_sequence=sequence;s->pl_epoch=s->window.epoch;
 s->fft_busy=1;s->fft_started=now;write32(s,SPECTRUM_FFT_BASE,1);
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
   if(s->roi_epoch!=s->window.epoch)s->stale_results++;
   else if(result==3)motion_spectrum_invalidate(s,2);
   else if(result)return fail(s,126);
   else{s->sample_pending=1;s->sample_sequence=s->roi_sequence;s->sample_epoch=s->roi_epoch;}
  }
 }
 if(s->fft_busy){
  uint32_t control=read32(s,SPECTRUM_FFT_BASE);
  if(now-s->fft_started>16000000u)return fail(s,128);
  if(control&2u){
   s->fft_busy=0;
   if(read32(s,SPECTRUM_FFT_BASE+PL_STATUS))return fail(s,129);
   if(s->pl_epoch!=s->window.epoch)s->stale_results++;
   else if(s->pl_operation==0){if(read32(s,SPECTRUM_FFT_BASE+PL_COUNT)!=0)return fail(s,134);}
   else if(s->pl_operation==1){
    unsigned count=read32(s,SPECTRUM_FFT_BASE+PL_COUNT),previous=s->window.count;
    if(count!=(previous<256?previous+1:256)||read32(s,SPECTRUM_FFT_BASE+PL_LAST)!=s->pl_sequence)return fail(s,134);
    s->window.count=count;s->window.have_sequence=1;s->window.last_sequence=s->pl_sequence;
    s->valid_samples++;s->roi_first=0;
    if(count<256)state(s,0);
    else if(previous<256){s->window.due=1;s->window.phase=0;}
    else{s->window.phase+=5000;if(s->window.phase>=60380){s->window.phase-=60380;s->window.due=1;}}
   }else if(s->pl_operation==2){
    if(read32(s,SPECTRUM_FFT_BASE+PL_COUNT)!=256||read32(s,SPECTRUM_FFT_BASE+PL_LAST)!=s->snapshot.last_sequence)return fail(s,134);
    // Freeze display readout ownership; bounded postprocessing runs below.
    s->clipped_bins=read32(s,SPECTRUM_FFT_BASE+PL_CLIPPED);
    s->fft_results++;spectrum_ui_begin(&s->ui);

   }
  }
 }
 if(!s->fft_busy){
  if((s->reset_pending||s->sample_pending||s->window.due)&&!(read32(s,SPECTRUM_FFT_BASE)&4u))return fail(s,133);
  if(s->reset_pending){s->reset_pending=0;launch(s,0,0,now);}
  else if(s->sample_pending){
   s->sample_pending=0;
   if(s->sample_epoch==s->window.epoch)launch(s,1,s->sample_sequence,now);
   else s->stale_results++;
  }else if(s->window.due&&s->window.count==256&&!s->ui.phase){
   s->snapshot.first_sequence=s->window.last_sequence-255u;s->snapshot.last_sequence=s->window.last_sequence;
   s->snapshot.epoch=s->window.epoch;s->window.due=0;launch(s,2,0,now);
  }
 }
 if(spectrum_ui_step(&s->ui,s->io.context,s->io.read,SPECTRUM_FFT_OUTPUT)){
  if(s->ui.bad){state(s,3);s->ui.count=0;}
  else state(s,s->ui.fs_millihz?1:0);
  s->dirty=1;
 }
 return display_poll(s,now);
}
