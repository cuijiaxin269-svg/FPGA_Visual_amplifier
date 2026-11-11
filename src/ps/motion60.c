#include "capture.h"
#include "motion60.h"
#ifdef MOTION60_HMI
#include "hmi_device.h"
static void hmi_app_init(void),hmi_app_poll(void),hmi_button_request(void),hmi_external_stop(void),hmi_config_committed(void);
#endif
#ifdef MOTION60_CAMERA_CONTROLS
#include "motion60_camera.h"
#endif
#ifdef MOTION60_CLIP
#include "motion60_clip_driver.h"
#include "motion60_clip_process.h"
#include "motion60_clip_accel.h"
#include "motion60_clip_playback.h"
#ifdef MOTION60_PL_OFFLINE
#include "motion60_clip_pl.h"
static motion_clip_pl clip_pl;
static uint64_t clip_process_started,clip_process_finished;
#define clip_accel clip_pl
#else
static motion_clip_processor clip_processor;
static motion_clip_accel clip_accel;
#endif
static motion_clip_driver clip;
static unsigned clip_active,clip_frames=120;
static unsigned clip_process_pending,clip_processed;
static motion_clip_playback clip_playback;
static unsigned clip_play_pending;
#ifdef MOTION60_INSTRUCTION_CACHE
// Only offline processing uses I-cache. Global I-cache caused a first-frame
// timeout in board testing; its precise cause remains unproven. Keep the
// accepted live path uncached. Data cache/MMU bits are never changed here.
static unsigned clip_instruction_cache(unsigned enable){
 unsigned control,zero=0;
 __asm__ volatile("mrc p15,0,%0,c1,c0,0":"=r"(control));
 unsigned previous=(control>>12)&1u;
 if(previous!=enable){
  __asm__ volatile("dsb sy\n mcr p15,0,%0,c7,c5,0\n dsb sy"::"r"(zero):"memory");
  control=enable?(control|0x1000u):(control&~0x1000u);
  __asm__ volatile("mcr p15,0,%0,c1,c0,0\n isb sy"::"r"(control):"memory");
 }
 return previous;
}
#endif
static uint64_t clip_clock(void *unused){(void)unused;return timer_ticks();}
static uint32_t clip_read(void *unused,uint32_t address){(void)unused;return rd(address);}
static void clip_write(void *unused,uint32_t address,uint32_t value){(void)unused;wr(address,value);}
#endif
static unsigned lo_milli=3000,hi_milli=12000,alpha_milli=12000;
#ifdef MOTION60_SPECTRUM
#include "motion60_spectrum_driver.h"
static motion_spectrum_driver spectrum;
static unsigned spectrum_active;
static unsigned spectrum_x=512,spectrum_y=272,spectrum_enable=1;
static uint32_t spectrum_read(void *unused,uint32_t address){(void)unused;return rd(address);}
static void spectrum_write(void *unused,uint32_t address,uint32_t value){(void)unused;wr(address,value);}
static int spectrum_service(void){
 if(!spectrum_active)return 0;
 spectrum.ui.band_lo_millihz=lo_milli;spectrum.ui.band_hi_millihz=hi_milli;
 uint64_t ui_begin=timer_ticks();
 int result=motion_spectrum_poll(&spectrum,ui_begin);
 unsigned ui_us=(unsigned)((timer_ticks()-ui_begin)/400u);
 if(ui_us>spectrum.ui.max_poll_us)spectrum.ui.max_poll_us=ui_us;
#ifdef MOTION60_TEST_IO
 extern volatile uint32_t test_spectrum_tm[32];volatile uint32_t *m=test_spectrum_tm;
#else
 volatile uint32_t *m=(volatile uint32_t *)(uintptr_t)0x00ff1100u;
#endif
 m[0]=0x53504531;m[1]=spectrum.state;m[2]=spectrum.error;
 m[3]=spectrum.valid_samples;m[4]=spectrum.window.count;m[5]=spectrum.fft_results;
 m[6]=spectrum.stale_results;m[7]=spectrum.roi_busy;m[8]=spectrum.fft_busy;
 m[9]=spectrum.last_roi_us;m[10]=spectrum.max_roi_us;m[11]=spectrum.window.epoch;
 m[12]=rd(SPECTRUM_OSD_BASE+0x20);m[13]=rd(SPECTRUM_OSD_BASE+0x24);
 m[14]=rd(SPECTRUM_OSD_BASE+0x28);m[15]=rd(SPECTRUM_OSD_BASE+0x14);
 m[20]=spectrum.ui.measured_fs;m[21]=spectrum.ui.count;m[22]=spectrum.ui.publications;
 m[23]=spectrum.ui.threshold;m[24]=spectrum.ui.max_poll_us;
 m[25]=(uint32_t)(uintptr_t)spectrum.ui.words;m[26]=spectrum.ui.phase;m[27]=spectrum.ui.fs_millihz;
 m[28]=0x53544231u;m[29]=spectrum.ui.smooth_max;
 m[30]=spectrum.ui.strong_threshold;m[31]=spectrum.ui.hold_threshold;
 m[16]=spectrum.clipped_bins;m[17]=4000;m[18]=spectrum.x;m[19]=spectrum.y;
 return result;
}
static void spectrum_invalidate(void){if(spectrum_active)motion_spectrum_invalidate(&spectrum,3);}
static unsigned spectrum_owns_input(void){return spectrum_active&&spectrum.roi_busy;}
#ifdef MOTION60_PL_SPECTRUM
static unsigned spectrum_has_work(void){return spectrum_active&&(spectrum.roi_busy||spectrum.fft_busy||spectrum.reset_pending||spectrum.sample_pending||spectrum.window.due);}
#else
static unsigned spectrum_has_work(void){return 0;}
#endif
#else
static int spectrum_service(void){return 0;}
static void spectrum_invalidate(void){}
static unsigned spectrum_owns_input(void){return 0;}
static unsigned spectrum_has_work(void){return 0;}
#endif
#define HLS 0x43c00000u
#define DISPLAY 0x43100000u
#define OUT_BASE 0x11000000u
#define UART 0xe0000000u
#define LIVE_FRAME_LIMIT_TICKS 8000000u
#define ROI_FRAME_LIMIT_TICKS 12000000u
// Readable via JTAG without halting CPU; no overlap with capture mailbox.
#ifdef MOTION60_TEST_IO
extern volatile uint32_t test_motion_tm[32];
static volatile uint32_t *const tm=test_motion_tm;
#else
static volatile uint32_t *const tm=(volatile uint32_t *)(uintptr_t)0x00ff1000u;
#endif
static unsigned enabled,busy,first=1,display_started,in_slot,out_slot,last_slot=3;
static unsigned last_events,stop_requested,config_pending,line_discard;
static unsigned live_stride=1,observed_events;
// HLS ap_done is clear-on-read. Latch it while the parallel ROI still owns input.
static unsigned motion_done;
static uint64_t started;
#include "motion60_roi.inc"
static char line[96],tx[512];static unsigned line_n,tx_r,tx_w;
static void serial_poll(void);
#ifdef MOTION60_BUTTON
#include "mode_button.h"
#define BUTTON_GPIO_INPUT 0xe000a068u
#define BUTTON_GPIO_DIR 0xe000a284u
#define BUTTON_GPIO_OEN 0xe000a288u
#ifdef MOTION60_TEST_IO
extern volatile uint32_t test_button_tm[16];
static volatile uint32_t *const button_tm=test_button_tm;
#else
static volatile uint32_t *const button_tm=(volatile uint32_t *)(uintptr_t)0x00ff1400u;
#endif
static mode_button button;
static unsigned button_pending;
static void button_cancel(void){button_pending=0;button_tm[5]=0;}
static void button_reset(void){
 mode_button_reset(&button,timer_ticks(),(rd(BUTTON_GPIO_INPUT)>>3)&1u);
}
static void button_service(unsigned may_restart){
 uint64_t now=timer_ticks();
 if(mode_button_due(&button,now)){
  unsigned high=(rd(BUTTON_GPIO_INPUT)>>3)&1u;
  unsigned pressed=mode_button_sample(&button,now,high);
  button_tm[1]=high;button_tm[2]=button.stable;
  if(pressed){
   button_tm[3]++;
   unsigned eligible=mailbox.status==2&&tm[1]==2&&!mailbox.duration_ms&&
    (enabled==1||enabled==2)&&!stop_requested&&!button_pending&&
    !mailbox.command&&!tm[8]&&!mailbox.error&&!tm[5];
#ifdef MOTION60_CLIP
   eligible=eligible&&!clip_active;
#endif
   if(eligible){
#ifdef MOTION60_HMI
    button_tm[4]++;button_tm[9]=0;hmi_button_request();
#else
    button_pending=3u-enabled;button_tm[4]++;button_tm[5]=button_pending;
    button_tm[9]=0;stop_requested=1;
#endif
   }else button_tm[7]++;
  }
 }
 button_tm[8]=mailbox.status==2&&tm[1]==2&&(enabled==1||enabled==2)?enabled:0;
 if(!button_pending)return;
 unsigned cancel=tm[8]||mailbox.command||mailbox.status==4||mailbox.error||tm[5];
#ifdef MOTION60_CLIP
 cancel=cancel||clip_active;
#endif
 if(cancel){button_tm[9]=mailbox.error?mailbox.error:(tm[5]?tm[5]:1u);button_cancel();return;}
 // main.c publishes status=3 only after capture, HLS and spectrum drain.
 // A failed drain or explicit host command must never cause an auto-restart.
 if(may_restart&&mailbox.status==3&&tm[1]==3&&!busy&&!spectrum_has_work()){
  enabled=button_pending;first=1;last_slot=3;last_events=0;stop_requested=0;
  mailbox.duration_ms=0;mailbox.electrical_ok=0x9281;
  button_tm[6]++;button_cancel();mailbox.command=4;
 }
}
#else
static void button_cancel(void){}
#endif
#ifdef MOTION60_CLIP
static int clip_clean(void){
 for(unsigned i=3;i<=8;i++)if(mailbox.stats[i])return 0;
 return !(mailbox.stats[13]&2u);
}
static void clip_telemetry_reset(void){
#ifdef MOTION60_TEST_IO
 extern volatile uint32_t test_clip_tm[32];volatile uint32_t *m=test_clip_tm;
#else
 volatile uint32_t *m=(volatile uint32_t *)(uintptr_t)0x00ff1200u;
#endif
 for(unsigned i=0;i<32;i++)m[i]=0;
 m[0]=0x434c5031;
#ifdef MOTION60_PL_OFFLINE
 m[27]=1;
 clip_process_started=clip_process_finished=0;
#endif
}
static void clip_telemetry(void){
#ifdef MOTION60_TEST_IO
 extern volatile uint32_t test_clip_tm[32];volatile uint32_t *m=test_clip_tm;
#else
 volatile uint32_t *m=(volatile uint32_t *)(uintptr_t)0x00ff1200u;
#endif
 m[0]=0x434c5031;m[1]=clip.record.committed;m[2]=clip.record.ready;
 m[3]=clip.record.busy;m[4]=clip.record.error;m[5]=clip.record.layout.frames;
 m[6]=clip.record.layout.raw_base;m[7]=clip.record.layout.raw_end;
 m[8]=(uint32_t)clip.record.first_sample;m[9]=(uint32_t)(clip.record.first_sample>>32);
 m[10]=(uint32_t)clip.record.last_sample;m[11]=(uint32_t)(clip.record.last_sample>>32);
 m[15]=clip_processed;m[16]=clip_accel.completed;m[17]=clip_accel.max_us;m[18]=clip_accel.busy;
 m[19]=clip_playback.active;m[20]=clip_playback.current_frame;m[21]=clip_playback.transitions;m[22]=clip_playback.error;
 m[23]=(uint32_t)clip_playback.first_transition;m[24]=(uint32_t)(clip_playback.first_transition>>32);
 m[25]=(uint32_t)clip_playback.last_transition;m[26]=(uint32_t)(clip_playback.last_transition>>32);
#ifdef MOTION60_PL_OFFLINE
 m[27]=1; // completed counter counts PL tasks, not legacy 64-pixel filter tiles.
 m[28]=(uint32_t)clip_process_started;m[29]=(uint32_t)(clip_process_started>>32);
 m[30]=(uint32_t)clip_process_finished;m[31]=(uint32_t)(clip_process_finished>>32);
#endif
}
static int clip_progress(void *unused,unsigned stage,unsigned level,unsigned done,unsigned total){
 (void)unused;(void)level;
#ifdef MOTION60_TEST_IO
 extern volatile uint32_t test_clip_tm[32];volatile uint32_t *m=test_clip_tm;
#else
 volatile uint32_t *m=(volatile uint32_t *)(uintptr_t)0x00ff1200u;
#endif
 m[12]=stage;m[13]=done;m[14]=total;
#ifdef MOTION60_PL_OFFLINE
 clip_telemetry();
#endif
 serial_poll();
 // The CPU remains inside the offline processor, so idle() cannot consume
 // the development STOP mailbox until processing returns. Check it at the
 // same safe boundaries used for UART cancellation, without pausing masters.
 if(tm[8]==2){tm[8]=0;stop_requested=1;
#ifdef MOTION60_HMI
 hmi_external_stop();
#endif
 }
 return stop_requested!=0;
}
static void clip_process_run(void){
 clip_process_pending=0;
 if(stop_requested){busy=0;tm[5]=154;return;}
 // Recording's PL reset disables the live processing/display path. Confirm
 // no DDR master remains active before phase storage overlaps live buffers.
 if(!clip_active||!clip.record.ready||clip_processed||clip.record.busy||clip_accel.busy||
    mailbox.status!=3||!(rd(VDMA_BASE+0x34)&1u)||(rd(DISPLAY)&1u)||
    !(rd(HLS)&4u)||!(rd(0x43c10000)&4u)||!(rd(0x43c20000)&4u)||!(rd(0x43c40000)&4u)||!(rd(0x43c50000)&4u)){
  tm[5]=158;busy=0;return;
 }
#ifdef MOTION60_PL_OFFLINE
 clip_pl.io.context=0;clip_pl.io.read=clip_read;clip_pl.io.write=clip_write;
 clip_pl.clock=clip_clock;clip_pl.progress=clip_progress;clip_pl.progress_context=0;
 clip_pl.spatial_base=HLS;clip_pl.temporal_base=0x43c50000;clip_pl.copy_base=0x43c40000;
 clip_pl.error=0;stop_requested=0;busy=1;clip.record.ready=0;tm[5]=0;
 clip_process_started=timer_ticks();clip_process_finished=0;
 int error=motion_clip_pl_run(&clip_pl,clip.record.layout.frames,60.379777,
                            (double)lo_milli/1000.0,(double)hi_milli/1000.0,(float)alpha_milli/1000.0f);
 // A timeout still owns an active AXI master; do not publish a finish time.
 if(!clip_pl.busy)clip_process_finished=timer_ticks();
#else
 int error=motion_clip_processor_bind(clip.record.layout.frames,&clip_processor);
 if(error){tm[5]=(unsigned)-error;busy=0;return;}
 clip_accel.io.context=0;clip_accel.io.read=clip_read;clip_accel.io.write=clip_write;
 clip_accel.clock=clip_clock;clip_accel.base=0x43c50000;clip_accel.error=0;clip_accel.completed=0;clip_accel.max_us=0;
 clip_processor.context=&clip_accel;clip_processor.filter=motion_clip_accel_filter;clip_processor.progress=clip_progress;
 stop_requested=0;busy=1;clip.record.ready=0;tm[5]=0;
#ifdef MOTION60_INSTRUCTION_CACHE
 unsigned previous_icache=clip_instruction_cache(1);
#endif
 error=motion_clip_process((uint16_t*)(uintptr_t)clip.record.layout.raw_base,clip.record.layout.frames,
                          WIDTH,HEIGHT,60.379777,(double)lo_milli/1000.0,(double)hi_milli/1000.0,
                          (float)alpha_milli/1000.0f,&clip_processor);
#ifdef MOTION60_INSTRUCTION_CACHE
 (void)clip_instruction_cache(previous_icache);
#endif
#endif
 busy=clip_accel.busy;
 if(error){motion_clip_record_fault(&clip.record,(unsigned)-error);tm[5]=(unsigned)-error;}
 else{clip_processed=1;clip.record.ready=1;}
 clip_telemetry();
}
static int clip_tick(unsigned events){
 unsigned writer=(rd(VDMA_BASE+0x28)>>24)&31u;
 uint64_t now=timer_ticks();
 if(stop_requested)motion_clip_record_fault(&clip.record,148);
 int error=motion_clip_driver_poll(&clip,writer,clip_clean(),now);
 if(!error&&!clip.record.ready&&events>=3&&events!=last_events){
  unsigned source=FRAME0+((writer+2u)%3u)*FRAME_SPACING;
  error=motion_clip_driver_frame(&clip,events,source,writer,clip_clean(),now,now);
  if(!error)last_events=events;
 }
 busy=clip.record.busy;clip_telemetry();
 if(error){tm[5]=(unsigned)-error;enabled=0;}
 return error;
}
#endif

static void put(char c){unsigned n=(tx_w+1u)&511u;if(n!=tx_r){tx[tx_w]=c;tx_w=n;}}
static void say(const char*s){while(*s)put(*s++);}
static void number(unsigned v){char b[11];unsigned n=0;do{b[n++]=(char)('0'+v%10);v/=10;}while(v);while(n)put(b[--n]);}
static int equal(const char*a,const char*b){while(*a && *a==*b){a++;b++;}return *a==*b;}
static unsigned decimal(const char*s,int*ok){
 unsigned v=0,f=0,scale=100;int dot=0,digits=0;
 for(;*s;s++){
  if(*s=='.'&&!dot){dot=1;continue;}
  if(*s<'0'||*s>'9'){*ok=0;return 0;}
  digits++;
  if(!dot){if(v>100000){*ok=0;return 0;}v=v*10+(unsigned)(*s-'0');}
  else{if(!scale){*ok=0;return 0;}f+=(unsigned)(*s-'0')*scale;scale/=10;}
 }
 if(!digits)*ok=0;
 return v*1000+f;
}
static uint32_t bits(float x){union{float f;uint32_t u;}v;v.f=x;return v.u;}
static float root(float x){float y=x>1?x:1;for(unsigned i=0;i<14;i++)y=.5f*(y+x/y);return y;}
static float sine(float x){float term=x,sum=x;for(unsigned i=1;i<9;i++){term*=(-x*x)/(float)((2*i)*(2*i+1));sum+=term;}return sum;}
static float cosine(float x){float term=1,sum=1;for(unsigned i=1;i<10;i++){term*=(-x*x)/(float)((2*i-1)*(2*i));sum+=term;}return sum;}
static void config(void){
 // Match the temporal filter to the frames actually fed to HLS.
 const float fps=60.379777f/(float)live_stride;
 // Division preserves integer endpoints (notably ALPHA 30). Multiplication
 // by rounded .001f produced 30.0000019 and tripped the HLS alpha<=30 gate.
 float lo=(float)lo_milli/1000.0f,hi=(float)hi_milli/1000.0f,f0=root(lo*hi),q=f0/(hi-lo);
 if(q<.5f)q=.5f;
 float w=6.283185307179586f*f0/fps,a=sine(w)/(2*q),b0=a/(1+a);
 wr(HLS+0x4c,bits(b0));wr(HLS+0x54,bits(-b0));
 wr(HLS+0x5c,bits(-2*cosine(w)/(1+a)));wr(HLS+0x64,bits((1-a)/(1+a)));
 wr(HLS+0x6c,bits((float)alpha_milli/1000.0f));first=1;config_pending=0;
 tm[9]=lo_milli;tm[10]=hi_milli;tm[11]=alpha_milli;tm[12]++;
#ifdef MOTION60_HMI
 hmi_config_committed();
#endif
}
#ifdef MOTION60_HMI
#include "motion60_hmi.inc"
#endif
static void status(void){
 say("MOTION60 enabled=");number(enabled);say(" processed=");number(tm[2]);
 say(" last_us=");number(tm[3]);say(" max_us=");number(tm[4]);
 say(" error=");number(tm[5]);say(" crc=");number(mailbox.stats[7]);say("\r\n");
#ifdef MOTION60_CLIP
 if(clip_active){
  say("CLIP frames=");number(clip.record.committed);say(" target=");number(clip.record.layout.frames);
  say(" ready=");number(clip.record.ready);say(" busy=");number(clip.record.busy);
  say(" processed=");number(clip_processed);
  say(" playing=");number(clip_playback.active);say(" frame=");number(clip_playback.current_frame);
  say(" error=");number(clip.record.error);say("\r\n");
 }
#endif
#ifdef MOTION60_SPECTRUM
 say("SPECTRUM state=");number(spectrum.state);say(" samples=");number(spectrum.window.count);
 say(" roi_us=");number(spectrum.last_roi_us);say(" fft_results=");number(spectrum.fft_results);say("\r\n");
 say("ROI x=");number(spectrum_x);say(" y=");number(spectrum_y);
 say(" size=256 overlay=");number(spectrum_enable);say(" full_scale_px=4\r\n");
#endif
}
#ifdef MOTION60_CAMERA_CONTROLS
static void camera_status(void){
 say("CAMERA requested rev=");number(CAMERA_CONTROL->revision);
 say(" exposure_lines=");number(mailbox.sensor_exposure_lines);
 say(" shutter_us_rounded=");number((mailbox.sensor_exposure_lines*182u+5u)/10u);
 say(" gain_raw=");number(mailbox.sensor_gain_raw);
 say(" mirror=");number(CAMERA_CONTROL->mirror);say(" flip=");number(CAMERA_CONTROL->flip);
 say(" pattern=");number(mailbox.test_pattern);say("\r\n");
 say("CAMERA readback rev=");number(CAMERA_CONTROL->applied_revision);
 say(" exposure_lines=");number(CAMERA_CONTROL->exposure_readback);
 say(" gain_raw=");number(CAMERA_CONTROL->gain_readback);
 say(" mirror=");number(CAMERA_CONTROL->mirror_readback);say(" flip=");number(CAMERA_CONTROL->flip_readback);
 say(" pattern=");number(CAMERA_CONTROL->pattern_readback);say("\r\n");
}
#endif
static void command(void){
 char *args[4];unsigned count=0;
 for(unsigned i=0;line[i] && count<4;){while(line[i]==' ')i++;if(!line[i])break;args[count++]=line+i;while(line[i]&&line[i]!=' ')i++;if(line[i])line[i++]=0;}
 if(!count)return;
 int ok=1;
#ifdef MOTION60_HMI
 /* Debug UART keeps its original extended commands. The shared subset
    enters the same device controller as touch and the physical key. */
 if((equal(args[0],"START")||equal(args[0],"STOP"))&&count==1){
  hmi_request request={equal(args[0],"START")?HMI_START:HMI_STOP,0,1};
  motion60_hmi_request(0,&request);say("OK HMI controller request\r\n");return;
 }
 if(equal(args[0],"VIEW")&&count==2){
  unsigned value=decimal(args[1],&ok);
  hmi_request request={HMI_SET_VIEW,value/1000u,(unsigned)(ok&&value<=2000u&&value%1000u==0)};
  motion60_hmi_request(0,&request);return;
 }
#endif
 if(equal(args[0],"STATUS")&&count==1){status();return;}
#ifdef MOTION60_CAMERA_CONTROLS
 if(equal(args[0],"CAMERA")&&count==1){camera_status();return;}
 if(equal(args[0],"EXPOSURE")||equal(args[0],"SHUTTER_US")||equal(args[0],"GAIN")||equal(args[0],"GAIN_RAW")||equal(args[0],"MIRROR")||equal(args[0],"FLIP")||equal(args[0],"TESTPATTERN")){
  // Standby-only configuration prevents mixed-exposure temporal histories.
  if(count!=2||busy||enabled||spectrum_has_work()||mailbox.status==2||mailbox.command){
   CAMERA_CONTROL->rejected_commands++;say("ERROR camera requires STOP/idle and one value\r\n");return;
  }
  unsigned value=decimal(args[1],&ok),accepted=0;
  if(equal(args[0],"EXPOSURE")&&ok&&value>=1000&&value<=898000&&value%1000==0){mailbox.sensor_exposure_lines=value/1000;accepted=1;}
  if(equal(args[0],"SHUTTER_US")&&ok&&value>=18000&&value<=16344000&&value%1000==0){
   unsigned lines=(value/1000*10u+91u)/182u;
   if(lines>=1&&lines<=898){mailbox.sensor_exposure_lines=lines;accepted=1;}
  }
  if(equal(args[0],"GAIN_RAW")&&ok&&value>=16000&&value<=248000&&value%1000==0){mailbox.sensor_gain_raw=value/1000;accepted=1;}
  if(equal(args[0],"GAIN")&&ok&&value>=1000&&value<=15500){mailbox.sensor_gain_raw=(value*16u+500u)/1000u;accepted=1;}
  if(ok&&(value==0||value==1000)){
   if(equal(args[0],"MIRROR")){CAMERA_CONTROL->mirror=value/1000;accepted=1;}
   if(equal(args[0],"FLIP")){CAMERA_CONTROL->flip=value/1000;accepted=1;}
   if(equal(args[0],"TESTPATTERN")){mailbox.test_pattern=value/1000;accepted=1;}
  }
  if(accepted){
   CAMERA_CONTROL->exposure_lines=mailbox.sensor_exposure_lines;CAMERA_CONTROL->gain_raw=mailbox.sensor_gain_raw;
   CAMERA_CONTROL->test_pattern=mailbox.test_pattern;CAMERA_CONTROL->revision++;
#ifdef MOTION60_HMI
   hdev.target[HMI_EXPOSURE]=mailbox.sensor_exposure_lines;hdev.valid[HMI_EXPOSURE]=0;
   hdev.generation[HMI_EXPOSURE]++;hstatus(HMI_EXPOSURE,HMI_QUEUED);
#endif
   say("OK camera pending next START/RECORD; CAMERA shows requested/readback\r\n");
  }else{CAMERA_CONTROL->rejected_commands++;say("ERROR camera range/unit\r\n");}
  return;
 }
#endif
#ifdef MOTION60_CLIP
 if(equal(args[0],"PLAY")&&count==1&&!busy&&mailbox.status==3&&clip_active&&clip.record.ready&&clip_processed){
  clip_play_pending=1;busy=1;stop_requested=0;say("OK PLAY queued\r\n");return;
 }
 if(equal(args[0],"PROCESS")&&count==1&&!busy&&mailbox.status==3&&clip_active&&clip.record.ready&&!clip_processed){
  clip_process_pending=1;busy=1;stop_requested=0;say("OK PROCESS queued\r\n");return;
 }
 if(equal(args[0],"RECORD")&&count==2&&!busy&&!spectrum_has_work()&&mailbox.status!=2){
  unsigned frames=decimal(args[1],&ok);
  if(ok&&frames>=30000&&frames<=120000&&frames%1000==0){
   clip_frames=frames/1000;enabled=3;stop_requested=0;last_events=0;
   mailbox.duration_ms=3000;mailbox.electrical_ok=0x9281;mailbox.command=4;
   say("OK RECORD raw clip; PROCESS then PLAY when ready\r\n");return;
  }
 }
#endif
#ifdef MOTION60_SPECTRUM
 if(equal(args[0],"ROI")&&count==3&&!busy&&mailbox.status!=2){
  unsigned x=decimal(args[1],&ok),y=decimal(args[2],&ok);
  // Keep the measured ROI aligned with the fixed display outline.
  if(ok&&x==512000&&y==272000){
   if(spectrum_active&&motion_spectrum_roi_configure(&spectrum,x/1000,y/1000)){
    say("ERROR ROI accelerator busy\r\n");return;
   }
   spectrum_x=x/1000;spectrum_y=y/1000;say("OK ROI; reference/window reset\r\n");return;
  }
 }
 if(equal(args[0],"OVERLAY")&&count==2&&(equal(args[1],"0")||equal(args[1],"1"))){
  spectrum_enable=(unsigned)(args[1][0]-'0');
  if(spectrum_active){spectrum.enable=spectrum_enable;spectrum.dirty=1;}
#ifdef MOTION60_HMI
  if(hdev.target[HMI_VIEW]){
   hdev.target[HMI_VIEW]=spectrum_enable?2:1;hlast_mag=hdev.target[HMI_VIEW];
   hdev.generation[HMI_VIEW]++;hstatus(HMI_VIEW,mailbox.status==2?HMI_WAIT:HMI_QUEUED);
  }
#endif
  say("OK OVERLAY pending display boundary\r\n");return;
 }
#endif
 if(equal(args[0],"BAND")&&count==3){unsigned lo=decimal(args[1],&ok),hi=decimal(args[2],&ok);
  if(ok&&lo>=500&&lo<hi&&hi<=20000){
   if(roi_target.config.enable&&hi>ROI_BAND_MAX_MILLIHZ){
    say("ERROR MAGROI requires BAND high <= 15 Hz\r\n");return;
   }
   lo_milli=lo;hi_milli=hi;config_pending=1;say("OK BAND pending frame boundary\r\n");return;
  }
 }
 else if(equal(args[0],"ALPHA")&&count==2){unsigned a=decimal(args[1],&ok);
  if(ok&&a<=50000){alpha_milli=a;config_pending=1;
#ifdef MOTION60_HMI
   hdev.target[HMI_ALPHA]=a/1000u;hdev.valid[HMI_ALPHA]=0;hdev.generation[HMI_ALPHA]++;
   halpha_config=tm[12];halpha_frame=tm[2];hstatus(HMI_ALPHA,HMI_QUEUED);
#endif
   say("OK ALPHA pending frame boundary\r\n");return;}}
 else if(equal(args[0],"START")&&(count==1||count==2)&&!busy&&!spectrum_has_work()&&mailbox.status!=2){
  unsigned duration=count==2?decimal(args[1],&ok):0;
  if(count==2&&(!ok||duration<1000||duration>120000||duration%1000)){
   say("ERROR START duration: integer seconds 1..120\r\n");return;
  }
  enabled=1;first=1;last_slot=3;last_events=0;stop_requested=0;
  mailbox.duration_ms=duration;mailbox.electrical_ok=0x9281;mailbox.command=4;
#ifdef MOTION60_HMI
  hdev.target[HMI_VIEW]=spectrum_enable?2:1;hdev.requested_run=1;hbooting=1;
  hstatus(HMI_RUN,HMI_WAIT);hstatus(HMI_VIEW,HMI_WAIT);
#endif
  say(duration?"OK START bounded run\r\n":"OK START continuous; STOP to finish\r\n");return;
 } else if(equal(args[0],"STOP")&&count==1){button_cancel();stop_requested=1;say("OK STOP requested\r\n");return;}
 say("ERROR command/range/state; STATUS | START | STOP | BAND lo hi | ALPHA value\r\n");
#ifdef MOTION60_SPECTRUM
 say("ROI 512 272 (fixed visible measurement region; stopped) | OVERLAY 0/1\r\n");
#endif
}
static void serial_poll(void){
#ifdef MOTION60_HMI
 hmi_app_poll();
#endif
 if(tx_r!=tx_w && !(rd(UART+0x2c)&0x10u)){wr(UART+0x30,(unsigned char)tx[tx_r]);tx_r=(tx_r+1)&511u;}
 for(unsigned i=0;i<8 && !(rd(UART+0x2c)&2u);i++){
  char c=(char)rd(UART+0x30);
  if(c=='\r'||c=='\n'){if(!line_discard&&line_n){line[line_n]=0;command();}line_n=0;line_discard=0;}
  else if(line_discard)continue;
  else if(line_n<sizeof(line)-1)line[line_n++]=c;
  else{line_n=0;line_discard=1;say("ERROR line too long\r\n");}
 }
}
static int display_start(unsigned slot,unsigned base){
 wr(DISPLAY,4);uint64_t end=timer_ticks()+40000000u;
 while(rd(DISPLAY)&4u)if(timer_ticks()>end)return -104;
 for(unsigned i=0;i<3;i++)wr(DISPLAY+0x5c+4*i,base+i*FRAME_SPACING);
 wr(DISPLAY+0x58,STRIDE);wr(DISPLAY+0x54,STRIDE);
 // One completion event per read frame; poll/W1C, no CPU interrupt enabled.
 wr(DISPLAY+0x28,slot);wr(DISPLAY,0x00011001u);wr(DISPLAY+0x50,HEIGHT);
 display_started=1;return 0;
}
static int motion60_publish_frame(void){
 uint64_t completed=timer_ticks();
 motion_roi_publish();
 if(display_started)wr(DISPLAY+0x28,out_slot);
 else{
  int error=display_start(out_slot,OUT_BASE);
  if(error)return error;
 }
 busy=0;first=0;
 if(!tm[2]){tm[16]=(uint32_t)completed;tm[17]=(uint32_t)(completed>>32);}
 tm[18]=(uint32_t)completed;tm[19]=(uint32_t)(completed>>32);
 tm[2]++;
 tm[3]=(uint32_t)((completed-started)/400u);
 if(tm[3]>tm[4])tm[4]=tm[3];
 return 0;
}
static void display_poll(void){
 if(!display_started)return;
 uint32_t status=rd(DISPLAY+4);tm[13]=status;
 if(status&0x1000u){
  wr(DISPLAY+4,0x1000u);uint64_t now=timer_ticks();
  if(!tm[23]){tm[24]=(uint32_t)now;tm[25]=(uint32_t)(now>>32);}
  tm[26]=(uint32_t)now;tm[27]=(uint32_t)(now>>32);tm[23]++;
 }
 motion_roi_display_poll((status&0x1000u)!=0);
}
int motion60_prepare_reset(void){
 // STOP holds the last picture by leaving MM2S scanning. Before a subsequent
 // global PL reset, halt its AXI reads cleanly so PS HP cannot retain requests
 // belonging to fabric which has just been reset.
 if(busy||spectrum_has_work())return -180;
 wr(DISPLAY,rd(DISPLAY)&~1u);
 uint64_t deadline=timer_ticks()+40000000u;
 while(!(rd(DISPLAY+4)&1u))if(timer_ticks()>deadline)return -181;
 display_started=0;
 return 0;
}
void motion60_init(void){
 live_stride=1;observed_events=0;
 motion_roi_init();
#ifdef MOTION60_BUTTON
 // Keep the camera SCCB bits intact. EMIO3 is exclusively a key input.
 wr(BUTTON_GPIO_OEN,rd(BUTTON_GPIO_OEN)&~8u);
 wr(BUTTON_GPIO_DIR,rd(BUTTON_GPIO_DIR)&~8u);
 for(unsigned i=0;i<16;i++)button_tm[i]=0;
 button_tm[0]=0x42544e31u;button_pending=0;button_reset();
#endif
#ifdef MOTION60_CAMERA_CONTROLS
 volatile uint32_t *camera_words=(volatile uint32_t *)CAMERA_CONTROL;
 for(unsigned i=0;i<sizeof(*CAMERA_CONTROL)/4;i++)camera_words[i]=0;
 CAMERA_CONTROL->magic=0x43414d31;CAMERA_CONTROL->revision=1;
 CAMERA_CONTROL->exposure_lines=mailbox.sensor_exposure_lines;CAMERA_CONTROL->gain_raw=mailbox.sensor_gain_raw;
 CAMERA_CONTROL->line_time_ns=18200; // Fixed 1456 HTS / 80MHz profile only.
#endif
 for(unsigned i=0;i<32;i++)tm[i]=0;
 tm[0]=0x4d363001u;tm[1]=1;
#ifdef MOTION60_PL_SPECTRUM
 tm[31]=0x53504c31u; // SPL1: PL window/transform/bar configuration contract.
#endif
 // Report defaults even when the first command is RECORD rather than START.
 tm[9]=lo_milli;tm[10]=hi_milli;tm[11]=alpha_milli;
#ifdef MOTION60_CLIP
 clip_telemetry_reset();
#endif
 // Vendor PS UART clock is configured by ps7_init. 100MHz / (124*7) ~115207.
 wr(UART,0x28);wr(UART+4,0x20);wr(UART+0x18,124);wr(UART+0x34,6);wr(UART,0x17);
 mailbox.sensor_half_rate_diagnostic=1;mailbox.sensor_mipi_period=32;
 mailbox.phy_manual_taps=1;mailbox.phy_tap_l0=8;mailbox.phy_tap_l1=8;
 mailbox.sensor_frame_counter_mode=2;mailbox.sccb_gpio_mode=1;mailbox.sensor_clk_post_min_ns=500;
 say("MOTION60 READY; START continuous; START seconds (1..120); STATUS/BAND/ALPHA/STOP\r\n");
#ifdef MOTION60_HMI
 hmi_app_init();
#endif
}
void motion60_begin(void){
#ifdef MOTION60_BUTTON
 button_reset(); // Require a fresh stable release after the capture warm-up.
#endif
 // Acquisition warm-up resets all PL. Restore HLS registers AFTER that reset.
 busy=0;motion_done=0;first=1;display_started=0;last_slot=3;last_events=0;
 live_stride=enabled==1&&roi_target.config.enable?2u:1u;
 observed_events=0;
 motion_roi_begin();
#ifdef MOTION60_SPECTRUM
 spectrum_active=0;
#endif
#ifdef MOTION60_CLIP
 clip_active=0;
 if(enabled==3){
#ifdef MOTION60_PL_OFFLINE
  // Volatile word clear avoids an implicit libc memset in bare-metal builds.
  volatile uint32_t *pl_words=(volatile uint32_t *)&clip_pl;
  for(unsigned i=0;i<sizeof(clip_pl)/4;i++)pl_words[i]=0;
#endif
  clip_processed=0;clip_process_pending=0;
  clip_telemetry_reset();
  motion_clip_io io={0,clip_read,clip_write};
  int error=motion_clip_driver_begin(&clip,io,0x43c40000,clip_frames,1);
  clip_active=1;tm[1]=2;tm[2]=0;tm[5]=error?(unsigned)-error:0;tm[28]=2;
  clip_telemetry();return;
 }
#endif
 if(!enabled)return;
 for(unsigned i=2;i<=7;i++)tm[i]=0;
 for(unsigned i=16;i<=28;i++)tm[i]=0;
 tm[28]=(enabled==2); // Explicitly labels diagnostic bypass; never algorithm proof.
 wr(HLS+0x28,0x18000000);wr(HLS+0x2c,0);
 wr(HLS+0x34,0x19000000);wr(HLS+0x38,0);
 wr(HLS+0x40,0x19400000);wr(HLS+0x44,0);
#ifdef MOTION60_PL_OFFLINE
 wr(HLS+0x7c,0); // restore causal mode after offline extraction/reconstruction.
#endif
 config();tm[1]=2;
#ifdef MOTION60_SPECTRUM
 if(enabled==1){
  motion_spectrum_io io={0,spectrum_read,spectrum_write};
  spectrum_active=1;
  int error=motion_spectrum_driver_init(&spectrum,io);
  if(!error)error=motion_spectrum_roi_configure(&spectrum,spectrum_x,spectrum_y);
  spectrum.enable=spectrum_enable;
  if(error)tm[5]=(unsigned)-error;
 }
#endif
#ifdef MOTION60_HMI
 motion60_hmi_started();
#endif
}
static unsigned motion60_job_limit(void){
 return roi_job.config.enable?ROI_FRAME_LIMIT_TICKS:LIVE_FRAME_LIMIT_TICKS;
}
static int motion60_check_live_job(unsigned write_slot){
 if(!busy)return 0;
 uint64_t elapsed=timer_ticks()-started;
 if(write_slot<3&&write_slot!=in_slot&&elapsed<=motion60_job_limit())return 0;
 spectrum_invalidate();
 enabled=0;tm[5]=101;tm[6]=(uint32_t)(elapsed/400u);
 return -101;
}
void motion60_drain_poll(void){
#ifdef MOTION60_CLIP
 if(clip_active)return;
#endif
 if(!busy||tm[1]!=2u||tm[5])return;
 if(!(rd(VDMA_BASE+0x34)&1u)&&motion60_check_live_job((rd(VDMA_BASE+0x28)>>24)&31u))return;
 if(rd(HLS)&2u)motion_done=1;
 int error=spectrum_service();if(error)tm[5]=(unsigned)-error;
 if(!tm[5]&&motion_done){
  int result=motion_roi_service();if(result<0)tm[5]=(unsigned)-result;
 }
}
int motion60_end(void){
 enabled=0;
#ifdef MOTION60_CLIP
 if(clip_active){
  if(!clip_clean())motion_clip_record_fault(&clip.record,141);
  if(!clip.record.ready&&!clip.record.error)motion_clip_record_fault(&clip.record,150);
  clip_telemetry();tm[5]=clip.record.error;tm[1]=clip.record.error?4:3;
  return clip.record.error?-(int)clip.record.error:0;
 }
#endif
 // A frame rejected during capture/composition must never be published by
 // the later STOP drain just because its accelerators eventually complete.
 if(tm[5])return -(int)tm[5];
 for(unsigned i=3;i<=8;i++)if(mailbox.stats[i]){spectrum_invalidate();tm[5]=106;return -106;}
 if(mailbox.stats[13]&2u){spectrum_invalidate();tm[5]=106;return -106;}
 if(busy){
  uint64_t deadline=timer_ticks()+motion60_job_limit();
  int composed=0;
  while(!motion_done||spectrum_owns_input()||!composed){
   if(rd(HLS)&2u)motion_done=1;
   int error=spectrum_service();if(error){tm[5]=(unsigned)-error;return error;}
   composed=motion_roi_service();
   if(composed<0){tm[5]=(unsigned)-composed;return composed;}
   if(timer_ticks()>deadline){spectrum_invalidate();tm[5]=101;return -101;}
  }
#ifdef MOTION60_PL_OFFLINE
  if(rd(HLS+0x84)){spectrum_invalidate();tm[5]=174;return -174;}
#endif
  int error=motion60_publish_frame();
  if(error)return error;
 }
#ifdef MOTION60_PL_SPECTRUM
 // Drain pending ROI ingest/reset/transform before a subsequent capture can
 // reset PL. Display scanning continues independently using its held frame.
 uint64_t spectrum_deadline=timer_ticks()+40000000u;
 while(spectrum_has_work()){
  int error=spectrum_service();if(error){tm[5]=(unsigned)-error;return error;}
  if(timer_ticks()>spectrum_deadline){tm[5]=135;return -135;}
 }
#endif
 tm[1]=3;return 0;
}
void motion60_abort(void){
#ifdef MOTION60_CLIP
 if(clip_active)return;
#endif
 enabled=0;
 if(tm[1]!=2u)return;
 // Keep START blocked until the failed job can no longer touch DDR.
 tm[1]=4;busy=1;
 motion_roi_reset_display();
}
static void motion60_abort_poll(void){
 if(tm[1]!=4u||!busy)return;
#ifdef MOTION60_CLIP
 if(clip_active)return;
#endif
 if(!(rd(VDMA_BASE+0x34)&1u)||(rd(HLS)&0x85u)!=4u)return;
 if(roi_started&&(rd(MAGROI_BASE+4)&1u))return;
#ifdef MOTION60_SPECTRUM
 if(spectrum_active&&((rd(SPECTRUM_ROI_BASE)&0x85u)!=4u||
                     (rd(SPECTRUM_FFT_BASE)&0x85u)!=4u))return;
 spectrum_active=0;
#endif
 motion_done=0;busy=0;
}
void motion60_idle(void){
 display_poll();
 motion60_abort_poll();
#ifdef MOTION60_CLIP
 if(clip_active){
  if(clip_play_pending){
   clip_play_pending=0;
   if(stop_requested)busy=0;
   else{
    clip_playback.io.context=0;clip_playback.io.read=clip_read;clip_playback.io.write=clip_write;
    clip_playback.clock=clip_clock;clip_playback.base=DISPLAY;
    int error=motion_clip_playback_start(&clip_playback,clip.record.layout.frames,clip_processed&&clip.record.ready);
    if(error){tm[5]=(unsigned)-error;busy=0;}
    else tm[5]=0;
   }
  }
  if(clip_playback.active){
   if(stop_requested)motion_clip_playback_stop(&clip_playback);
   int error=motion_clip_playback_poll(&clip_playback);if(error)tm[5]=(unsigned)-error;
   busy=clip_playback.active;clip_telemetry();
  }
  if(clip_accel.busy){
#ifdef MOTION60_PL_OFFLINE
   (void)motion_clip_pl_poll(&clip_pl);
#else
   (void)motion_clip_accel_poll(&clip_accel);
#endif
   busy=clip_accel.busy;clip_telemetry();
  }
  if(clip.record.busy){
   unsigned writer=(rd(VDMA_BASE+0x28)>>24)&31u;
   (void)motion_clip_driver_poll(&clip,writer,clip_clean(),timer_ticks());
   busy=clip.record.busy;clip_telemetry();
  }
 }
#endif
 serial_poll();
#ifdef MOTION60_BUTTON
 button_service(1);
#endif
#ifdef MOTION60_CLIP
 if(clip_process_pending){clip_process_run();return;}
#endif
 if(!busy){int error=spectrum_service();if(error)tm[5]=(unsigned)-error;}
 // JTAG can request the same command through this separate development mailbox.
 if(tm[8]==1 && mailbox.status!=2 && !busy&&!spectrum_has_work()){tm[8]=0;enabled=1;first=1;last_slot=3;last_events=0;stop_requested=0;mailbox.electrical_ok=0x9281;mailbox.command=4;
#ifdef MOTION60_HMI
 hdev.target[HMI_VIEW]=spectrum_enable?2u:1u;hdev.requested_run=1;hbooting=1;
 hstatus(HMI_RUN,HMI_WAIT);hstatus(HMI_VIEW,HMI_WAIT);
#endif
 }
 if(tm[8]==3 && mailbox.status!=2 && !busy&&!spectrum_has_work()){tm[8]=0;enabled=2;first=1;last_slot=3;last_events=0;stop_requested=0;mailbox.electrical_ok=0x9281;mailbox.command=4;
#ifdef MOTION60_HMI
 hdev.target[HMI_VIEW]=0u;hdev.requested_run=1;hbooting=1;
 hstatus(HMI_RUN,HMI_WAIT);hstatus(HMI_VIEW,HMI_WAIT);
#endif
 }
 if(tm[8]==2){button_cancel();tm[8]=0;stop_requested=1;
#ifdef MOTION60_HMI
 hmi_external_stop();
#endif
 }
 if(config_pending&&!busy)config();
}
int motion60_tick(unsigned events){
 serial_poll();
#ifdef MOTION60_BUTTON
 button_service(0);
#endif
#ifdef MOTION60_CLIP
 if(clip_active){
  if(tm[8]==2){button_cancel();tm[8]=0;stop_requested=1;
#ifdef MOTION60_HMI
 hmi_external_stop();
#endif
 }
  return clip_tick(events);
 }
#endif
 display_poll();
 if(tm[8]==2){button_cancel();tm[8]=0;stop_requested=1;
#ifdef MOTION60_HMI
 hmi_external_stop();
#endif
 }
 if(!enabled)return 0;
 for(unsigned i=3;i<=8;i++)if(mailbox.stats[i]){spectrum_invalidate();enabled=0;tm[5]=106;return -106;}
 if(mailbox.stats[13]&2u){spectrum_invalidate();enabled=0;tm[5]=106;return -106;}
 unsigned write_slot=(rd(VDMA_BASE+0x28)>>24)&31u;
 unsigned fresh_event=events!=observed_events;
 observed_events=events;
 if(enabled!=2){
  int error=motion60_check_live_job(write_slot);
  if(error)return error;
 }
 // Normal STOP uses capture's frame-boundary shutdown/drain path. Check
 // CRC, ownership and existing video errors before accepting that request.
 if(stop_requested){
  tm[13]=rd(DISPLAY+4);
  if(display_started && (tm[13]&0x4ff0u)){enabled=0;tm[5]=107;return -107;}
  enabled=0;return 1;
 }
 if(enabled==2){
  // Board isolation test: display completed capture buffers without HLS.
  // Keep processed_frames at zero so this can never pass algorithm acceptance.
  if(events>=3 && events!=last_events && write_slot<3){
   unsigned slot=(write_slot+2)%3;last_events=events;
   if(!display_started){int e=display_start(slot,FRAME0);if(e)return e;}
   else wr(DISPLAY+0x28,slot);
   tm[20]=mailbox.stats[1];tm[21]=slot;
  }
  tm[13]=rd(DISPLAY+4);tm[14]=events;tm[15]=write_slot;
  if(display_started && (tm[13]&0x4ff0u)){enabled=0;tm[5]=107;return -107;}
  return 0;
 }
 {int error=spectrum_service();if(error){spectrum_invalidate();enabled=0;tm[5]=(unsigned)-error;return error;}}
 if(busy){
  uint32_t hs=rd(HLS);
  if(hs&2u)motion_done=1;
  int composed=motion_roi_service();
  if(composed<0){spectrum_invalidate();enabled=0;tm[5]=(unsigned)-composed;return composed;}
  if(motion_done&&composed&&!spectrum_owns_input()){
#ifdef MOTION60_PL_OFFLINE
   if(rd(HLS+0x84)){spectrum_invalidate();enabled=0;tm[5]=174;return -174;}
#endif
   if(roi_job.config.enable){
    int error=motion60_check_live_job((rd(VDMA_BASE+0x28)>>24)&31u);
    if(error)return error;
   }
   int error=motion60_publish_frame();
   if(error)return error;
  }
 }
 if(!busy && events>=3 && events!=last_events && write_slot<3){
  unsigned stride=roi_target.config.enable?2u:1u;
  // Start ROI work on a fresh capture event. A delayed launch would
  // spend part of the source slot's lifetime waiting in the scheduler.
  if((stride==2u&&!(events&1u))||((stride==2u||stride!=live_stride)&&!fresh_event))return 0;
  unsigned slot=(write_slot+2)%3;
  if(slot==last_slot)return 0;
  unsigned park=display_started?rd(DISPLAY+0x28):0;
  unsigned active=(park>>16)&31u,pending=park&31u;
  out_slot=0;while(out_slot<3 && display_started && (out_slot==active||out_slot==pending))out_slot++;
  if(out_slot==3)return 0;
  if(stride!=live_stride){
   live_stride=stride;
   config_pending=1;
  }else if(last_slot<3&&(slot!=(last_slot+stride)%3||events-last_events!=stride)){
   first=1;tm[7]++;
  }
  if(config_pending)config();
  wr(HLS+0x10,FRAME0+slot*FRAME_SPACING);wr(HLS+0x14,0);
  wr(HLS+0x1c,OUT_BASE+out_slot*FRAME_SPACING);wr(HLS+0x20,0);
  wr(HLS+0x74,first);in_slot=slot;last_slot=slot;last_events=events;
  tm[20]=mailbox.stats[1];tm[21]=slot;tm[22]=out_slot;
  started=timer_ticks();motion_done=0;
  motion_roi_job_begin(events);
#ifdef MOTION60_SPECTRUM
  if(spectrum_active){
   spectrum.window.sample_millihz=MOTION_SPECTRUM_CAPTURE_MILLIHZ/live_stride;
   spectrum_ui_clock(&spectrum.ui,mailbox.stats[1]/live_stride,
                     (uint64_t)mailbox.stats[11]|((uint64_t)mailbox.stats[12]<<32));
   int error=motion_spectrum_frame_start(&spectrum,FRAME0+slot*FRAME_SPACING,
                                         events/live_stride,first,started);
   if(error){spectrum_invalidate();enabled=0;tm[5]=(unsigned)-error;return error;}
  }
#endif
  busy=1;wr(HLS,1);
 }
 tm[13]=rd(DISPLAY+4);tm[14]=events;tm[15]=write_slot;
 if(display_started && (tm[13]&0x4ff0u)){enabled=0;tm[5]=107;return -107;}
 return 0;
}
