#define HMI_DEVICE_TEST_MAIN existing_hmi_tests
#include "test_hmi_device.cpp"
static unsigned compose_starts;
static void compose_hook(uint32_t address,uint32_t value){
 finish_accelerator(address,value);
 if(address==MAGROI_BASE+4&&value==1){compose_starts++;registers[address]=1;}
}
static void roi_setup(){
 cold();touch("MAGROI 42 512 272 256 1\r\nSTART\r\n");begin();
 registers[MAGROI_BASE]=MAGROI_ID;registers[MAGROI_BASE+4]=0;
 compose_starts=0;write_hook=compose_hook;
}
static int start_compose(unsigned event){
 for(unsigned i=0;i<60;i++){
  if(motion60_tick(event))return -1;
  if(busy&&roi_started&&!roi_finished)return 0;
 }
 return -1;
}
static int finish_compose(unsigned event){
 registers[MAGROI_BASE+4]=2;registers[MAGROI_BASE+8]=0;
 for(unsigned i=0;i<60&&busy;i++)if(motion60_tick(event))return -1;
 return busy?-1:0;
}
static int verify_live_enable_and_sample_rate(){
 cold();touch("START\r\n");begin();
 registers[MAGROI_BASE]=MAGROI_ID;
 compose_starts=0;write_hook=compose_hook;
 ticks=3ull*400000000000ull/60380u;
 CHECK(!motion60_tick(3)&&busy&&live_stride==1);
 touch("MAGROI 42 512 272 256 1\r\n");
 for(unsigned i=0;i<12;i++)CHECK(!motion60_tick(3));
 CHECK(!busy&&tm[2]==1&&!compose_starts&&!spectrum_has_work());
 ticks=4ull*400000000000ull/60380u;
 registers[VDMA_BASE+0x28]=1u<<24;
 CHECK(!motion60_tick(4)&&!busy&&live_stride==1);
 unsigned full_rate_config=tm[12];
 for(unsigned event=5;event<=139;event+=2){
  uint64_t sof=(uint64_t)event*100000000000ull/60380u;
  ticks=4u*sof;
  mailbox.stats[1]=event;
  mailbox.stats[11]=(uint32_t)sof;
  mailbox.stats[12]=(uint32_t)(sof>>32);
  registers[VDMA_BASE+0x28]=((event-3u)%3u)<<24;
  CHECK(!start_compose(event)&&roi_job.config.seq==42);
  CHECK(!finish_compose(event));
  // Firmware continues polling while waiting for the next capture event.
  for(unsigned i=0;i<12;i++)CHECK(!motion60_tick(event));
  CHECK(!spectrum_has_work());
 }
 CHECK(tm[2]==69&&tm[7]==0&&tm[12]==full_rate_config+1);
 CHECK(spectrum.ui.measured_fs==30190u);
 return 0;
}
int main(){
 CHECK(existing_hmi_tests()==0);
 // Reproduce the board failure with a late but still-owned composition.
 roi_setup();registers[VDMA_BASE+0x28]=1u<<24;
 CHECK(!start_compose(3)&&in_slot==0);
 ticks=started+10000000u; // 25 ms after launch, before the source slot wraps.
 registers[VDMA_BASE+0x28]=2u<<24;
 registers[MAGROI_BASE+4]=2;
 CHECK(!motion60_tick(4)&&tm[2]==1&&!busy&&compose_starts==1);
 CHECK(tm[3]>=25000&&tm[5]==0);
 CHECK(live_stride==2&&spectrum.window.sample_millihz==30190u);
 CHECK(!motion60_tick(4)&&!busy);
 registers[VDMA_BASE+0x28]=0;
 CHECK(!start_compose(5)&&in_slot==2&&spectrum.roi_sequence==2);
 CHECK(!first&&tm[7]==0&&compose_starts==2);
 CHECK(!finish_compose(5)&&tm[2]==2);
 CHECK(verify_live_enable_and_sample_rate()==0);
 roi_setup();CHECK(hdev.roi.seen&&hdev.roi.target.seq==42);
 CHECK(!start_compose(3)&&busy&&compose_starts==1);
 unsigned first_slot=out_slot;
 CHECK(!display_started&&!tm[2]);
 CHECK(registers[MAGROI_BASE+0x10]==registers[HLS+0x10]);
 CHECK(registers[MAGROI_BASE+0x14]==registers[HLS+0x1c]);
 touch("MAGROI 43 8 12 64 1\r\n");
 CHECK(roi_job.config.seq==42&&roi_target.config.seq==43);
 CHECK(registers[MAGROI_BASE+0x18]==512&&registers[MAGROI_BASE+0x20]==256);
 CHECK(!finish_compose(3)&&tm[2]==1&&display_started);
 CHECK(roi_slots[first_slot].config.seq==42&&!roi_actual_valid);
 /* The old frame cannot acknowledge the newer target. DMA + two healthy
    renderer wraps are required, and metadata survives slot recycling. */
 registers[DISPLAY+0x28]=(first_slot<<16)|first_slot;
 registers[MAGROI_VIDEO+0x20]=10;
 motion_roi_display_poll(1);motion_roi_display_poll(1);
 CHECK(roi_wait_valid&&!roi_actual_valid);
 registers[MAGROI_VIDEO+0x20]=11;motion_roi_display_poll(0);CHECK(!roi_actual_valid);
 registers[MAGROI_VIDEO+0x20]=12;motion_roi_display_poll(0);motion60_hmi_poll();
 CHECK(roi_actual_valid&&hdev.roi.actual.seq==42&&hdev.roi.status==HMI_WAIT);
 registers[VDMA_BASE+0x28]=2u<<24;
 CHECK(!start_compose(5)&&roi_job.config.seq==43&&compose_starts==2);
 CHECK(registers[MAGROI_BASE+0x18]==8&&registers[MAGROI_BASE+0x1c]==12);
 CHECK(out_slot!=first_slot);
 CHECK(!finish_compose(5)&&tm[2]==2);
 registers[DISPLAY+0x28]=(out_slot<<16)|out_slot;
 motion_roi_display_poll(1);motion_roi_display_poll(1);
 registers[MAGROI_VIDEO+0x20]+=2;motion_roi_display_poll(0);motion60_hmi_poll();
 /* A preceding sample may still be queued; continue observing actual DMA. */
 motion_roi_display_poll(1);registers[MAGROI_VIDEO+0x20]+=2;motion_roi_display_poll(0);motion60_hmi_poll();
 CHECK(hdev.roi.actual.seq==43&&hdev.roi.status==HMI_APPLIED);
 uint32_t revision=roi_target.revision;
 touch("MAGROI 43 8 12 64 1\r\n");CHECK(roi_target.revision==revision);
 touch("MAGROI 43 9 12 64 1\r\n");CHECK(hdev.roi.status==HMI_REJECTED&&roi_target.config.x==8);
 touch("MAGROI 42 8 12 64 1\r\n");CHECK(hdev.roi.status==HMI_REJECTED);
 touch("MAGROI 44 8 12 64 0\r\n");
 registers[VDMA_BASE+0x28]=0;
 for(unsigned i=0;i<60;i++)CHECK(!motion60_tick(6));
 CHECK(tm[2]==3&&compose_starts==2&&!roi_job.config.enable);
 CHECK(live_stride==1&&spectrum.window.sample_millihz==60380u&&tm[7]==0);
 /* Sequence wrap and legal geometry are independent of display/START. */
 cold();touch("MAGROI 65535 0 0 800 1\r\nMAGROI 0 480 0 800 1\r\n");
 CHECK(roi_target.config.seq==0&&roi_target.config.x==480&&!mailbox.command);
 touch("MAGROI 1 481 0 800 1\r\n");CHECK(hdev.roi.status==HMI_REJECTED&&roi_target.config.seq==0);
 /* STOP drains the compositor; completion is still required before publish. */
 roi_setup();CHECK(!start_compose(3));touch("STOP\r\n");CHECK(motion60_tick(3)==1&&busy);
 motion60_drain_poll();CHECK(busy&&!tm[2]);
 registers[MAGROI_BASE+4]=2;motion60_drain_poll();CHECK(!motion60_end()&&!busy&&tm[2]==1);
 /* Hardware resets PARK_PTR to zero on HALTED. Source slot zero is still
    valid after STOP; the stopped writer must not look like an overwrite. */
 roi_setup();registers[VDMA_BASE+0x28]=1u<<24;
 CHECK(!start_compose(3)&&in_slot==0);touch("STOP\r\n");CHECK(motion60_tick(3)==1);
 registers[VDMA_BASE+0x34]=1;registers[VDMA_BASE+0x28]=0;
 registers[MAGROI_BASE+4]=2;motion60_drain_poll();
 CHECK(!motion60_end()&&!busy&&tm[2]==1&&!roi_fault);
 /* Faults cannot publish, including through the STOP/end path. */
 roi_setup();CHECK(!start_compose(3));registers[MAGROI_BASE+4]=2;registers[MAGROI_BASE+8]=16;
 CHECK(motion60_tick(3)==-191&&!tm[2]&&!display_started);
 CHECK(motion60_end()==-191&&!tm[2]);
 roi_setup();CHECK(!start_compose(3));registers[VDMA_BASE+0x28]=in_slot<<24;
 CHECK(motion60_tick(3)==-101&&!tm[2]);
 registers[MAGROI_BASE+4]=2;CHECK(motion60_end()==-101&&!tm[2]);
 roi_setup();CHECK(!start_compose(3));ticks=started+12000001u;
 CHECK(motion60_tick(3)==-101&&!tm[2]);
 // Exercise the same error handoff as main.c. START must remain queued
 // while either capture or the compositor still owns a transaction.
 motion60_abort();mailbox.status=4;mailbox.error=(uint32_t)-101;
 motion60_hmi_completed(-101);
 touch("MAGROI 43 8 12 64 0\r\nSTART\r\n");
 CHECK(busy&&hstart_pending&&!mailbox.command);
 motion60_idle();CHECK(busy&&!mailbox.command);
 registers[VDMA_BASE+0x34]=1;
 motion60_idle();CHECK(busy&&!mailbox.command);
 registers[MAGROI_BASE+4]=2;
 registers[SPECTRUM_FFT_BASE]=1;
 motion60_idle();CHECK(busy&&!mailbox.command);
 registers[SPECTRUM_FFT_BASE]=4;
 motion60_idle();CHECK(!busy&&!spectrum_active&&mailbox.command==4&&!display_started&&!tm[2]);
 begin();registers[VDMA_BASE+0x34]=0;registers[VDMA_BASE+0x28]=0;
 for(unsigned i=0;i<60;i++)CHECK(!motion60_tick(3));
 CHECK(display_started&&tm[2]==1&&!tm[5]&&live_stride==1);
 // The original full-rate BAND range is restored when ROI is disabled.
 cold();send_command("BAND 3 20");CHECK(hi_milli==20000u);
 touch("MAGROI 1 8 12 64 1\r\n");
 CHECK(!roi_target.config.enable&&hdev.roi.status==HMI_REJECTED);
 send_command("BAND 3 12");touch("MAGROI 1 8 12 64 1\r\n");
 CHECK(roi_target.config.enable);
 send_command("BAND 3 20");CHECK(hi_milli==12000u);
 roi_setup();registers[MAGROI_BASE]=0;
 for(unsigned i=0;i<60&&!tm[5];i++)(void)motion60_tick(3);
 CHECK(tm[5]==190&&!tm[2]);
 /* A renderer fault invalidates pending applied evidence. */
 roi_setup();CHECK(!start_compose(3)&&!finish_compose(3));
 registers[DISPLAY+0x28]=(out_slot<<16)|out_slot;
 motion_roi_display_poll(1);motion_roi_display_poll(1);
 registers[MAGROI_VIDEO+0x24]++;registers[MAGROI_VIDEO+0x20]+=2;
 motion_roi_display_poll(0);CHECK(!roi_actual_valid&&!roi_wait_valid);
 motion_roi_reset_display();roi_slot_valid=1u<<out_slot;
 motion_roi_display_poll(1);registers[MAGROI_VIDEO+0x24]++;
 motion_roi_display_poll(1);registers[MAGROI_VIDEO+0x20]+=2;
 motion_roi_display_poll(0);CHECK(!roi_actual_valid&&!roi_wait_valid);
 std::puts("ROI_SCHEDULER_PASSED paired_frames atomic_roi paced_25ms band_limit stop_drain fault_recovery applied_evidence seq_wrap legacy_views");
 return 0;
}
