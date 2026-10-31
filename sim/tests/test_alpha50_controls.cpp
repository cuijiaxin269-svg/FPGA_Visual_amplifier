#define BUTTON_TEST_MAIN existing_button_main
#include "test_mode_button.cpp"
int main(){
 CHECK(existing_button_main()==0);
 live_setup();send_command("ALPHA 50");CHECK(alpha_milli==50000&&config_pending);
 CHECK(!motion60_tick(3));CHECK(registers[HLS+0x6c]==0x42480000u&&test_motion_tm[11]==50000);
 CHECK(test_motion_tm[9]==3000&&test_motion_tm[10]==12000);
 for(unsigned i=0;i<40;i++)CHECK(!motion60_tick(3));
 for(const char*bad:{"ALPHA 50.001","ALPHA 51","ALPHA -1","ALPHA nan","ALPHA inf"}){
  send_command(bad);CHECK(alpha_milli==50000&&!config_pending);
 }
 send_command("ALPHA 30");CHECK(alpha_milli==30000&&config_pending);
 registers[0x43000028]=2u<<24;CHECK(!motion60_tick(4));
 CHECK(registers[HLS+0x6c]==0x41f00000u&&test_motion_tm[11]==30000);
 std::puts("ALPHA50_FIRMWARE_CONTROLS_PASSED exact_ieee_754=1 upper_endpoint=1 reject_invalid=1 restore30=1");
 return 0;
}
