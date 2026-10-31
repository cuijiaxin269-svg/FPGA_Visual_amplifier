#define MOTION60_CLIP
#define MOTION60_PL_OFFLINE
#ifndef MOTION60_PL_SPECTRUM
#define MOTION60_PL_SPECTRUM
#endif
#define main unused_legacy_scheduler_main
#include "test_motion60_scheduler.cpp"
#undef main
volatile uint32_t test_clip_tm[32];
static unsigned samples,last_sample;
static void finish_accelerator(uint32_t a,uint32_t v){
 if(v!=1)return;
 if(a==SPECTRUM_ROI_BASE){registers[a]=6;registers[a+0x48]=0;}
 if(a==0x43c00000){registers[a]=6;registers[a+0x84]=0;}
 if(a==SPECTRUM_FFT_BASE){
  unsigned op=registers[a+0x28];
  if(op==0)samples=last_sample=0;
  if(op==1){if(samples<256)samples++;last_sample=registers[a+0x30];}
  registers[a+0x50]=samples;registers[a+0x70]=last_sample;
  registers[a+0x40]=registers[a+0x80]=0;registers[a]=6;
 }
}
static void v8_setup(){
 // Independent cases represent a cold start, not an undrained previous run.
 spectrum_active=0;setup();
}
int legacy_v8_main(){
 v8_setup();CHECK(test_motion_tm[31]==0x53504c31&&test_clip_tm[27]==1);
 write_hook=finish_accelerator;
 for(unsigned frame=0;frame<360;frame++){
  registers[0x43000028]=((frame+1)%3)<<24;
  CHECK(!motion60_tick(frame+3));
  for(unsigned i=0;i<40;i++)CHECK(!motion60_tick(frame+3));
 }
 CHECK(test_motion_tm[2]==360&&!test_motion_tm[5]&&spectrum.valid_samples==360&&spectrum.fft_results==9);
 spectrum.window.due=1;CHECK(!spectrum_service()&&spectrum.fft_busy);
 send_command("STOP");CHECK(motion60_tick(362)==1);
 motion60_drain_poll();CHECK(!motion60_end()&&!busy);
 CHECK(!spectrum_has_work()&&spectrum.fft_results==10);
 mailbox.status=3;mailbox.command=0;motion_spectrum_invalidate(&spectrum,3);
 send_command("START");CHECK(!mailbox.command&&spectrum_has_work());
 motion60_idle();motion60_idle();CHECK(!spectrum_has_work());
 send_command("START");CHECK(mailbox.command==4);
 write_hook=0;
 // The PL-spectrum build has distinct ownership/reset paths. Exercise its
 // capture-error guards directly instead of relying on legacy-build tests.
 for(unsigned stat=3;stat<=8;stat++){
  v8_setup();mailbox.stats[stat]=1;test_motion_tm[8]=2;
  CHECK(motion60_tick(3)==-106&&test_motion_tm[5]==106);
  CHECK(motion_starts==0&&roi_starts==0&&test_motion_tm[2]==0);
  CHECK(spectrum.window.count==0&&spectrum.reset_pending);
 }
 v8_setup();mailbox.stats[13]=2;
 CHECK(motion60_tick(3)==-106&&motion_starts==0&&roi_starts==0);
 v8_setup();CHECK(!motion60_tick(3)&&motion_starts==1);
 mailbox.stats[7]=1;registers[0x43c00000]=6;complete_roi();
 CHECK(motion60_tick(3)==-106&&test_motion_tm[2]==0);
 CHECK(spectrum.window.count==0&&spectrum.reset_pending);
 v8_setup();CHECK(!motion60_tick(3));registers[0x43000028]=in_slot<<24;
 CHECK(motion60_tick(3)==-101&&test_motion_tm[2]==0);
 v8_setup();CHECK(!motion60_tick(3));ticks+=8000001;
 CHECK(motion60_tick(3)==-101&&test_motion_tm[2]==0);
 // A serial parameter change may not rewrite an active spatial transaction.
 v8_setup();write_hook=finish_accelerator;
 CHECK(!motion60_tick(3)&&busy);
 unsigned prior_alpha=registers[0x43c0006c];
 send_command("ALPHA 7.5");
 CHECK(config_pending&&registers[0x43c0006c]==prior_alpha);
 for(unsigned i=0;i<40;i++)CHECK(!motion60_tick(3));
 CHECK(!busy&&test_motion_tm[2]==1&&config_pending);
 registers[0x43000028]=1u<<24;
 CHECK(!motion60_tick(4)&&busy&&!config_pending);
 CHECK(registers[0x43c0006c]==0x40f00000&&registers[0x43c00074]==1);
 write_hook=0;
 std::puts("PASS v8 capture guards: six error counters, invalid frame, active CRC failure, input overwrite, deadline; parameter applies at next frame with history reset");
 std::puts("PASS v8 scheduler: 360 frames, PL spectrum cadence, STOP drains active transform, START waits for PL ownership");
 return 0;
}

