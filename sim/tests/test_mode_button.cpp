#define MOTION60_BUTTON
#include "legacy_v8_scheduler.cpp"
volatile uint32_t test_button_tm[16];

static void sample_key(unsigned high,unsigned milliseconds){
 registers[BUTTON_GPIO_INPUT]=high?8u:0u;
 for(unsigned i=0;i<milliseconds;i++){ticks+=400000;button_service(0);}
}
static void live_setup(){
 write_hook=0;clip_active=0;spectrum_active=0;
 v8_setup();mailbox.command=0;mailbox.duration_ms=0;
 write_hook=finish_accelerator;
 registers[SPECTRUM_FFT_BASE]=6;
 for(unsigned i=0;i<40;i++)(void)motion60_tick(0);
 sample_key(1,30);
}
static int debounce_test(){
 mode_button b;uint64_t now=0;unsigned presses=0;
 mode_button_reset(&b,now,0);
 for(unsigned i=0;i<1000;i++)presses+=mode_button_sample(&b,now+=400000,0);
 CHECK(!presses&&!b.armed); // Boot with KEY0 held cannot toggle.
 for(unsigned i=0;i<30;i++)presses+=mode_button_sample(&b,now+=400000,1);
 CHECK(!presses&&b.armed);
 for(unsigned i=0;i<80;i++)presses+=mode_button_sample(&b,now+=400000,i&1u);
 CHECK(!presses); // Chattering contacts must not toggle.
 for(unsigned i=0;i<26;i++)presses+=mode_button_sample(&b,now+=400000,0);
 CHECK(presses==1);
 for(unsigned i=0;i<2000;i++)presses+=mode_button_sample(&b,now+=400000,0);
 CHECK(presses==1); // Long press: exactly once.
 for(unsigned i=0;i<20;i++)presses+=mode_button_sample(&b,now+=400000,1);
 for(unsigned i=0;i<30;i++)presses+=mode_button_sample(&b,now+=400000,0);
 CHECK(presses==1); // Release bounce cannot re-arm.
 for(unsigned i=0;i<30;i++)presses+=mode_button_sample(&b,now+=400000,1);
 now+=400000000;presses+=mode_button_sample(&b,now,0);
 for(unsigned i=0;i<30;i++)presses+=mode_button_sample(&b,now+=400000,0);
 CHECK(presses==1); // An unobserved blocking interval invalidates the edge.
 for(unsigned i=0;i<30;i++)presses+=mode_button_sample(&b,now+=400000,1);
 for(unsigned i=0;i<30;i++)presses+=mode_button_sample(&b,now+=400000,0);
 CHECK(presses==2);
 std::puts("PASS debounce: boot-held, bounce, 25 ms press/release, long hold, polling gaps");
 return 0;
}
#ifndef BUTTON_TEST_MAIN
#define BUTTON_TEST_MAIN main
#endif
int BUTTON_TEST_MAIN(){
 CHECK(debounce_test()==0);
 CHECK(legacy_v8_main()==0);
 live_setup();send_command("ALPHA 30");send_command("BAND 3 12");
 mailbox.sensor_exposure_lines=320;mailbox.sensor_gain_raw=16;
 sample_key(0,24);CHECK(!stop_requested&&!button_pending);
 // The press matures while a genuine algorithm/ROI transaction is owned.
 CHECK(!motion60_tick(3)&&busy&&spectrum.roi_busy);
 sample_key(0,1);CHECK(!button_pending);
 ticks+=400000;
 CHECK(motion60_tick(3)==1&&busy&&!mailbox.command);
 CHECK(stop_requested&&button_pending==2&&test_button_tm[4]==1);
 button_service(1);CHECK(!mailbox.command&&button_pending==2);
 // AP_DONE ownership remains with firmware until the ordinary STOP drain ends.
 write_hook=finish_accelerator;
 registers[0x43c00000]=6;complete_roi();
 motion60_drain_poll();CHECK(!motion60_end()&&!busy&&!spectrum_has_work());
 button_service(1);CHECK(!mailbox.command); // main has not published stopped yet.
 mailbox.status=3;motion60_idle();
 CHECK(enabled==2&&mailbox.command==4&&test_button_tm[6]==1&&!button_pending);
 CHECK(alpha_milli==30000&&lo_milli==3000&&hi_milli==12000);
 CHECK(mailbox.sensor_exposure_lines==320&&mailbox.sensor_gain_raw==16);
 registers[0x43100004]=1;CHECK(!motion60_prepare_reset());
 mailbox.command=0;motion60_begin();mailbox.status=2;
 CHECK(test_motion_tm[28]==1&&!spectrum_active&&mailbox.duration_ms==0);
 sample_key(0,1000);CHECK(!button_pending&&test_button_tm[4]==1);
 unsigned starts_before=motion_starts;
 CHECK(!motion60_tick(0)&&motion_starts==starts_before); // True bypass.
 sample_key(1,30);sample_key(0,26);
 CHECK(button_pending==1&&motion60_tick(0)==1);
 CHECK(!motion60_end());mailbox.status=3;motion60_idle();
 CHECK(enabled==1&&mailbox.command==4&&test_button_tm[6]==2);
 mailbox.command=0;motion60_begin();mailbox.status=2;
 CHECK(test_motion_tm[28]==0&&registers[0x43c0006c]==0x41f00000u);
 CHECK(first&&spectrum_active&&alpha_milli==30000); // Clear temporal history.
 std::puts("PASS actual scheduler: alpha30 -> raw bypass -> alpha30; safe active-transaction drain; settings preserved; hold cannot repeat");

 live_setup();sample_key(0,26);send_command("STOP");
 CHECK(!button_pending&&stop_requested);mailbox.status=3;test_motion_tm[1]=3;
 motion60_idle();CHECK(!mailbox.command);
 live_setup();sample_key(0,26);test_motion_tm[8]=2;
 CHECK(motion60_tick(0)==1&&!button_pending&&!test_motion_tm[8]);
 for(unsigned reason=0;reason<3;reason++){
  live_setup();sample_key(0,26);
  if(reason==0)mailbox.status=4;
  if(reason==1)mailbox.error=16;
  if(reason==2)test_motion_tm[5]=101;
  button_service(1);CHECK(!button_pending&&!mailbox.command&&test_button_tm[9]);
 }
 for(unsigned state=0;state<6;state++){
  live_setup();
  if(state==0)mailbox.duration_ms=60000;
  if(state==1){enabled=3;clip_active=1;}
  if(state==2){enabled=0;clip_active=1;clip_process_pending=1;}
  if(state==3){enabled=0;clip_active=1;clip_playback.active=1;}
  if(state==4){enabled=0;mailbox.status=3;}
  if(state==5)mailbox.status=4;
  sample_key(0,26);CHECK(!button_pending&&!stop_requested&&!mailbox.command&&test_button_tm[7]==1);
  if(state>0)CHECK(test_button_tm[8]==0);
  clip_process_pending=0;clip_playback.active=0;
 }
 // Even if software is idle, pending spectrum/DMA ownership blocks restart.
 live_setup();sample_key(0,26);enabled=0;mailbox.status=3;test_motion_tm[1]=3;
 busy=1;button_service(1);CHECK(!mailbox.command);
 busy=0;spectrum.roi_busy=1;button_service(1);CHECK(!mailbox.command);
 spectrum.roi_busy=0;spectrum.reset_pending=0;spectrum.sample_pending=0;spectrum.window.due=0;
 button_service(1);CHECK(mailbox.command==4&&enabled==2);
 std::puts("PASS arbitration: UART/JTAG STOP cancel restart, faults cancel, idle/bounded/RECORD/PROCESS/PLAY ignore, pending ownership blocks restart");
 return 0;
}
