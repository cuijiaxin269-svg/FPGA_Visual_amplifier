#define BUTTON_TEST_MAIN existing_button_main
#include "test_mode_button.cpp"
int main(){
 CHECK(existing_button_main()==0);
 live_setup();write_hook=finish_accelerator;
 for(unsigned frame=0;frame<9;frame++){
  registers[0x43000028]=((frame+1)%3)<<24;
  CHECK(!motion60_tick(frame+3));
  CHECK(registers[SPECTRUM_ROI_BASE+0x10]==registers[HLS+0x10]);
  CHECK(registers[SPECTRUM_ROI_BASE+0x28]==512);
  CHECK(registers[SPECTRUM_ROI_BASE+0x30]==272);
  CHECK(registers.count(HLS+0x90)==0 && registers.count(HLS+0x94)==0);
  for(unsigned i=0;i<40;i++)CHECK(!motion60_tick(frame+3));
 }
 send_command("STOP");CHECK(motion60_tick(11)==1);
 motion60_drain_poll();CHECK(!motion60_end());mailbox.status=3;
 unsigned epoch=spectrum.window.epoch;
 send_command("ROI 0 0");send_command("ROI 1024 544");send_command("ROI 512.5 272");
 CHECK(spectrum_x==512 && spectrum_y==272 && spectrum.window.epoch==epoch);
 send_command("ROI 512 272");
 CHECK(spectrum.x==512 && spectrum.y==272 && spectrum.window.epoch==epoch+1);
 std::puts("BORDER_CONTROLS_PASSED frame_slots=3 fixed_roi=1 no_background_axi=1 button_preserved=1");
 return 0;
}
