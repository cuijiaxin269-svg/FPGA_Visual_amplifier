#include "motion60_spectrum_window.h"
// Publish at 5 Hz using the scheduler's nominal input sampling rate.
#define REFRESH_MILLIHZ 5000u
void motion_spectrum_window_reset(motion_spectrum_window *w){
 w->head=0;w->count=0;w->have_sequence=0;w->last_sequence=0;
 w->phase=0;w->due=0;w->epoch++;
}
void motion_spectrum_window_init(motion_spectrum_window *w){
 w->sample_millihz=MOTION_SPECTRUM_CAPTURE_MILLIHZ;
 w->epoch=0;motion_spectrum_window_reset(w);
}
static int finite_motion(float v){
 union{float f;uint32_t u;}bits;bits.f=v;
 return (bits.u&0x7f800000u)!=0x7f800000u && v>=-256.0f && v<=256.0f;
}
int motion_spectrum_window_push(motion_spectrum_window *w,float dx,float dy,
                               uint32_t sequence,int valid){
 if(!valid||!finite_motion(dx)||!finite_motion(dy)){
  motion_spectrum_window_reset(w);return 0;
 }
 if(w->have_sequence && sequence!=w->last_sequence+1u)motion_spectrum_window_reset(w);
 w->xy[w->head][0]=dx;w->xy[w->head][1]=dy;
 w->head=(w->head+1u)&255u;w->last_sequence=sequence;w->have_sequence=1;
 if(w->count<256){
  w->count++;
  if(w->count==256){w->due=1;w->phase=0;}
 }else{
  // Bounded modulo accumulator even if a consumer is stalled indefinitely.
  w->phase+=REFRESH_MILLIHZ;
  if(w->phase>=w->sample_millihz){w->phase-=w->sample_millihz;w->due=1;}
 }
 return 1;
}
int motion_spectrum_window_take(motion_spectrum_window *w,float output[512],
                               motion_spectrum_snapshot *snapshot){
 if(w->count!=256||!w->due)return 0;
 // Separate snapshot memory remains immutable while PL reads it. The live
 // ring can accept the next video frame without modifying that AXI buffer.
 for(uint32_t i=0;i<256;i++){
  uint32_t j=(w->head+i)&255u;
  output[2*i]=w->xy[j][0];output[2*i+1]=w->xy[j][1];
 }
 snapshot->first_sequence=w->last_sequence-255u;
 snapshot->last_sequence=w->last_sequence;snapshot->epoch=w->epoch;
 w->due=0;return 1;
}
int motion_spectrum_window_current(const motion_spectrum_window *w,
                                  const motion_spectrum_snapshot *snapshot){
 return w->have_sequence&&w->count==256&&w->epoch==snapshot->epoch;
}
