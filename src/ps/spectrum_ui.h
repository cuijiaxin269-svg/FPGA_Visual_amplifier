#ifndef SPECTRUM_UI_H
#define SPECTRUM_UI_H
#include <stdint.h>
// Display-only postprocessing. The PL still owns ROI measurement and the FFT.
// Raw axis spectra are retained; peak labels use max(Ax,Ay), relative bin amplitude.
typedef struct {
 uint32_t x[129],y[129],a[129],sorted[129],maximum,threshold;
 uint32_t smooth[129],smooth_max,strong_threshold,hold_threshold,smoothing_ready;
 uint32_t band_lo_millihz,band_hi_millihz;
 uint8_t previous[129],peaks[129];
 // Telemetry exposes this buffer for bounded word-aligned JTAG readback.
 uint16_t words[256] __attribute__((aligned(4)));
 uint16_t frequency[64],relative[64];
 uint8_t weak[64];
 uint32_t phase,index,count,fs_millihz,sequence,have_clock,clock_sequence;
 uint32_t measured_fs,publications,bad,max_poll_us;
 uint64_t clock_ticks;
} spectrum_ui;
static inline uint32_t spectrum_ui_q16(uint32_t bits,unsigned *bad){
 unsigned e=(bits>>23)&255u,m=(bits&0x7fffffu)|0x800000u;
 if(e==255u || ((bits>>31)&&((bits&0x7fffffffu)!=0)) || e>136u){*bad=1;return 0;}
 if(e<103u)return 0;
 return e>=134u?m<<(e-134u):m>>(134u-e);
}
static inline void spectrum_ui_clock(spectrum_ui*u,unsigned sequence,uint64_t ticks){
 if(!u->have_clock||sequence<u->clock_sequence||ticks<=u->clock_ticks){
  u->clock_sequence=sequence;u->clock_ticks=ticks;u->have_clock=1;u->measured_fs=0;return;
 }
 unsigned n=sequence-u->clock_sequence;
 if(n>=64u){
  uint64_t elapsed=ticks-u->clock_ticks;
  unsigned fs=(unsigned)((100000000000ull*n+elapsed/2)/elapsed);
  u->measured_fs=(fs>=10000&&fs<=120000)?fs:0;
  u->clock_sequence=sequence;u->clock_ticks=ticks;
 }
}
static inline void spectrum_ui_clear(spectrum_ui*u){
 u->phase=u->count=0;u->have_clock=0;u->measured_fs=0;u->smoothing_ready=0;
 for(unsigned i=0;i<129;i++){u->previous[i]=u->peaks[i]=0;u->smooth[i]=0;}
 for(unsigned i=0;i<256;i++)u->words[i]=0;
}
static inline void spectrum_ui_begin(spectrum_ui*u){
 u->phase=1;u->index=u->maximum=u->smooth_max=u->bad=0;u->fs_millihz=u->measured_fs;
}
static inline void spectrum_ui_char(spectrum_ui*u,unsigned pos,char c){
 unsigned k=129+pos/2,shift=(pos&1u)*8;
 u->words[k]=(uint16_t)((u->words[k]&~(255u<<shift))|((unsigned char)c<<shift));
}
static inline void spectrum_ui_text(spectrum_ui*u,unsigned pos,const char*s){
 while(*s&&pos<252)spectrum_ui_char(u,pos++,*s++);
}
static inline void spectrum_ui_number(spectrum_ui*u,unsigned pos,unsigned v,unsigned digits){
 while(digits){spectrum_ui_char(u,pos+--digits,(char)('0'+v%10));v/=10;}
}
static inline unsigned spectrum_ui_inside(const spectrum_ui*u,unsigned j){
 unsigned lo=u->band_hi_millihz?u->band_lo_millihz:3000;
 unsigned hi=u->band_hi_millihz?u->band_hi_millihz:12000;
 return u->frequency[j]*100u>=lo && u->frequency[j]*100u<=hi;
}
static inline void spectrum_ui_format(spectrum_ui*u){
 for(unsigned i=129;i<255;i++)u->words[i]=0x2020;
 // Six 36-character rows, five scale labels, and footer fields share one bank.
 spectrum_ui_text(u,0,"FS 00.00HZ DF0.000 W-WEAK O-OUT N256");
 spectrum_ui_number(u,3,u->fs_millihz/1000,2);spectrum_ui_number(u,6,(u->fs_millihz/10)%100,2);
 unsigned df=(u->fs_millihz+128)/256;
 spectrum_ui_number(u,13,df/1000,1);spectrum_ui_number(u,15,df%1000,3);
 // In-band components first, then all out-of-band components; no truncation.
 uint8_t order[64];unsigned ordered=0;
 for(unsigned pass=0;pass<2;pass++)for(unsigned j=0;j<u->count;j++)
  if(spectrum_ui_inside(u,j)==(pass==0))order[ordered++]=(uint8_t)j;
 unsigned pages=(u->count+9)/10;if(!pages)pages=1;
 unsigned page=(u->publications/20)%pages;
 for(unsigned slot=0;slot<10;slot++){
  unsigned rank=page*10+slot,pos=36+(slot/2)*36+(slot%2)*18;
  if(rank>=u->count)continue;
  unsigned j=order[rank];
  spectrum_ui_text(u,pos,"00 00.0HZ 000% ");
  spectrum_ui_number(u,pos,rank+1,2);spectrum_ui_number(u,pos+3,u->frequency[j]/10,2);
  spectrum_ui_number(u,pos+6,u->frequency[j]%10,1);spectrum_ui_number(u,pos+10,u->relative[j],3);
  spectrum_ui_char(u,pos+14,u->weak[j]?'W':' ');
  spectrum_ui_char(u,pos+15,spectrum_ui_inside(u,j)?' ':'O');
 }
 if(!u->count)spectrum_ui_text(u,36,"NO STABLE PEAK ABOVE NOISE GATE");
 u->words[255]=(uint16_t)((u->fs_millihz+5)/10); // Sample rate in 0.01 Hz.
 // Convert frequency ticks only once per publication, outside the pixel path.
 for(unsigned tick=0;tick<5;tick++){
  unsigned pos=216+6*tick,value=(u->words[255]*tick+40u)/80u;
  spectrum_ui_text(u,pos,"00.0HZ");
  spectrum_ui_number(u,pos,value/10,2);spectrum_ui_number(u,pos+3,value%10,1);
 }
 spectrum_ui_text(u,246,"00 0/0");
 spectrum_ui_number(u,246,u->count,2);spectrum_ui_number(u,249,page+1,1);spectrum_ui_number(u,251,pages,1);
}
// One bounded unit per scheduler poll. Return 1 on completed display snapshot.
// Readout remains stable because op=2 cannot be launched while phase!=0.
static inline int spectrum_ui_step(spectrum_ui*u,void*ctx,uint32_t(*read)(void*,uint32_t),uint32_t base){
 if(!u->phase)return 0;
 if(u->phase==1){
  for(unsigned n=0;n<4&&u->index<129;n++){
   unsigned k=u->index++;unsigned bad=0;
   u->x[k]=spectrum_ui_q16(read(ctx,base+8*k),&bad);
   u->y[k]=spectrum_ui_q16(read(ctx,base+8*k+4),&bad);u->bad|=bad;
   // Legacy PL doubles both endpoints. Correct display values only.
   if(k==0||k==128){u->x[k]/=2;u->y[k]/=2;}
   unsigned raw=u->x[k]>u->y[k]?u->x[k]:u->y[k];
   if(raw>u->maximum)u->maximum=raw;
   unsigned a=u->smoothing_ready?(3*u->smooth[k]+raw+2)/4:raw;
   u->smooth[k]=u->a[k]=a;
   if(a>u->smooth_max)u->smooth_max=a;
   unsigned j=k;while(j&&u->sorted[j-1]>a){u->sorted[j]=u->sorted[j-1];j--;}
   u->sorted[j]=a;
  }
  if(u->index==129){
   unsigned floor=u->smooth_max*3/100;if(floor<131)floor=131;
   u->threshold=u->sorted[64]*3;if(u->threshold<floor)u->threshold=floor;
   u->hold_threshold=u->sorted[64]*2;if(u->hold_threshold<floor)u->hold_threshold=floor;
   u->strong_threshold=u->sorted[64]*6;if(u->strong_threshold<floor)u->strong_threshold=floor;
   // Do not let smoothing preserve a silent, invalid or unclocked window.
   if(!u->maximum||u->bad||!u->fs_millihz){
    for(unsigned k=0;k<129;k++){u->smooth[k]=u->a[k]=0;u->previous[k]=0;}
    u->smoothing_ready=0;
   }else u->smoothing_ready=1;
   u->index=0;u->phase=2;u->count=0;
  }
 }else if(u->phase==2){
  for(unsigned n=0;n<4&&u->index<129;n++){
   unsigned k=u->index++,a=u->a[k],candidate=0,history=0;
   if(k>1&&k<128)for(unsigned j=k-1;j<=k+1;j++)if(u->previous[j]>history)history=u->previous[j];
   // Bin 1 is dominated by the finite-window detrending response for some
   // off-bin tones. Keep it in the raw chart, not in resolved AC labels.
   unsigned gate=history>=3?u->hold_threshold:u->threshold;
   unsigned raw_support=0;
   if(k>1&&k<128)for(unsigned j=k-1;j<=k+1;j++){
    if(u->x[j]>raw_support)raw_support=u->x[j];
    if(u->y[j]>raw_support)raw_support=u->y[j];
   }
   if(k>1&&k<128&&a>gate&&raw_support>u->hold_threshold&&a>u->a[k-1]&&a>=u->a[k+1]){
    candidate=1;
    for(unsigned j=(k>2?k-2:1);j<=k+2&&j<128;j++)if(j!=k&&u->a[j]>a)candidate=0;
   }
   unsigned score=candidate?(history<3?history+1:3):0;
   u->peaks[k]=(uint8_t)score;
   unsigned x=u->maximum?(u->x[k]*127ull+u->maximum/2)/u->maximum:0;
   unsigned y=u->maximum?(u->y[k]*127ull+u->maximum/2)/u->maximum:0;
   u->words[k]=(uint16_t)(x|(y<<8));
   if(score>=3&&!u->bad&&u->fs_millihz){
    u->words[k]|=128;
    int64_t den=2*((int64_t)u->a[k-1]-2*(int64_t)a+u->a[k+1]);
    int shift=den?(int)(1000*((int64_t)u->a[k-1]-u->a[k+1])/den):0;
    if(shift>500)shift=500;
    if(shift<-500)shift=-500;
    unsigned j=u->count++;
    u->frequency[j]=(uint16_t)(((uint64_t)(k*1000+shift)*u->fs_millihz+12800000)/25600000);
    u->relative[j]=(uint16_t)((100ull*a+u->smooth_max/2)/u->smooth_max);
    u->weak[j]=(uint8_t)(a<u->strong_threshold);
   }
  }
  if(u->index==129){
   for(unsigned k=0;k<129;k++)u->previous[k]=(u->bad||!u->fs_millihz)?0:u->peaks[k];
   u->publications++;u->phase=0;spectrum_ui_format(u);return 1;
  }
 }
 return 0;
}
#endif
