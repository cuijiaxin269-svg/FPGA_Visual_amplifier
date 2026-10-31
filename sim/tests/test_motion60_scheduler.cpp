// Compile the actual scheduler with only MMIO/timer/mailbox access substituted.
// This is a control/ownership test, not an accelerator arithmetic simulation.
#include <map>
#include <cstdio>
#include <cstring>
#include "../../src/ps/capture.h"
volatile capture_control mailbox;
volatile uint32_t test_motion_tm[32],test_spectrum_tm[32];
static std::map<uint32_t,uint32_t> registers;
static uint64_t ticks;
static unsigned motion_starts,roi_starts;
static void (*write_hook)(uint32_t,uint32_t);
static uint32_t fake_rd(uint32_t a){
 if(a==0xe000002c)return 2;
 if(a==0x43c30000)return 0x4f534432;
 if(a==0x43c30004)return 1;
 uint32_t value=registers[a];
 if(a==0x43c00000||a==0x43c10000||a==0x43c20000)registers[a]&=~2u;
 return value;
}
static void fake_wr(uint32_t a,uint32_t v){
 registers[a]=v;
 if(a==0x43100000&&v==4)registers[a]=0;
 if(a==0x43c00000&&v==1){registers[a]=0;motion_starts++;}
 if(a==0x43c10000&&v==1){registers[a]=0;roi_starts++;}
 if(a==0x43c3000c)registers[0x43c30014]++;
 if(write_hook)write_hook(a,v);
}
static uint64_t fake_timer_ticks(){ticks+=100;return ticks;}
#define MOTION60_SPECTRUM
#define MOTION60_TEST_IO
#define rd fake_rd
#define wr fake_wr
#define timer_ticks fake_timer_ticks
#include "../../src/ps/motion60.c"
#undef rd
#undef wr
#undef timer_ticks
#define CHECK(x) do{if(!(x)){std::printf("FAIL scheduler line=%d error=%u\n",__LINE__,test_motion_tm[5]);return 1;}}while(0)
static void setup(){
 registers.clear();ticks=0;motion_starts=roi_starts=0;
 volatile unsigned char *clear=(volatile unsigned char*)&mailbox;
 for(unsigned i=0;i<sizeof(mailbox);i++)clear[i]=0;
 for(unsigned i=0;i<32;i++){test_motion_tm[i]=0;test_spectrum_tm[i]=0;}
 enabled=busy=motion_done=stop_requested=config_pending=0;
 tx_r=tx_w=line_n=line_discard=0;
 registers[0x43c00000]=registers[0x43c10000]=registers[0x43c20000]=4;
 registers[0x43000028]=0;mailbox.status=1;
 motion60_init();test_motion_tm[8]=1;motion60_idle();motion60_begin();mailbox.status=2;
}
static void complete_roi(){registers[0x43c10000]=6;registers[0x43c10048]=3;}
static void send_command(const char *text){std::strcpy(line,text);command();}
int main(){
 setup();CHECK(motion60_tick(3)==0&&motion_starts==1&&roi_starts==1);
 ticks+=400000;registers[0x43c00000]=6;
 CHECK(motion60_tick(3)==0&&motion_done&&busy&&test_motion_tm[2]==0);
 CHECK(motion60_tick(3)==0&&motion_done&&busy&&test_motion_tm[2]==0);
 complete_roi();CHECK(motion60_tick(3)==0&&!busy&&test_motion_tm[2]==1);
 CHECK(motion_starts==1&&roi_starts==1&&test_spectrum_tm[1]==2);
 setup();CHECK(!motion60_tick(3));complete_roi();
 CHECK(!motion60_tick(3)&&busy&&!spectrum.roi_busy&&test_motion_tm[2]==0);
 registers[0x43c00000]=6;CHECK(!motion60_tick(3)&&test_motion_tm[2]==1&&!busy);
 setup();CHECK(!motion60_tick(3));registers[0x43c00000]=6;CHECK(!motion60_tick(3)&&motion_done);
 test_motion_tm[8]=2;CHECK(motion60_tick(3)==1&&busy&&test_motion_tm[5]==0);
 complete_roi();motion60_drain_poll();CHECK(!motion60_end()&&!busy&&test_motion_tm[2]==1);
 mailbox.status=3;test_motion_tm[8]=1;motion60_idle();CHECK(enabled==1&&mailbox.command==4);
 setup();CHECK(!motion60_tick(3));registers[0x43c00000]=6;CHECK(!motion60_tick(3)&&motion_done);
 complete_roi();CHECK(!motion60_end()&&test_motion_tm[2]==1&&test_motion_tm[1]==3);
 setup();CHECK(!motion60_tick(3));complete_roi();registers[0x43c00000]=6;mailbox.stats[7]=1;
 CHECK(motion60_tick(3)==-106&&test_motion_tm[2]==0&&spectrum.window.count==0);
 setup();CHECK(!motion60_tick(3));complete_roi();registers[0x43c00000]=6;registers[0x43000028]=2u<<24;
 CHECK(motion60_tick(3)==-101&&test_motion_tm[2]==0&&spectrum.window.count==0);
 setup();send_command("ROI 0 0");CHECK(spectrum_x==512&&spectrum_y==272);
 mailbox.status=3;send_command("ROI 1024 544");
 CHECK(spectrum_x==512&&spectrum_y==272&&spectrum.x==512&&spectrum.y==272);
 send_command("ROI 1025 544");send_command("ROI 2.5 1");send_command("ROI 1 2 extra");
 CHECK(spectrum_x==512&&spectrum_y==272);
 send_command("OVERLAY 0");CHECK(!spectrum_enable&&!spectrum.enable&&spectrum.dirty);
 send_command("OVERLAY 2");CHECK(!spectrum_enable);
 enabled=1;motion60_begin();CHECK(spectrum.x==512&&spectrum.y==272&&!spectrum.enable);
 send_command("OVERLAY 1");CHECK(spectrum.enable==1);
 send_command("ROI 512 272");CHECK(spectrum_x==512&&spectrum_y==272);
 setup();CHECK(!motion60_tick(3));registers[0x43c00000]=6;complete_roi();
 motion60_drain_poll();CHECK(motion_done&&!spectrum.roi_busy&&busy&&test_motion_tm[2]==0);
 CHECK(!motion60_end()&&test_motion_tm[2]==1);
 setup();mailbox.status=3;send_command("START");CHECK(mailbox.duration_ms==0&&mailbox.command==4);
 send_command("START 60");CHECK(mailbox.duration_ms==60000);
 send_command("START 120");CHECK(mailbox.duration_ms==120000);
 send_command("START 0");send_command("START 121");send_command("START 1.5");
 CHECK(mailbox.duration_ms==120000);
 mailbox.status=2;send_command("START");CHECK(mailbox.duration_ms==120000);
 setup();CHECK(!motion60_tick(3));mailbox.stats[7]=1;test_motion_tm[8]=2;
 CHECK(motion60_tick(3)==-106&&test_motion_tm[5]==106);
 setup();CHECK(!motion60_tick(3));registers[0x43000028]=in_slot<<24;test_motion_tm[8]=2;
 CHECK(motion60_tick(3)==-101&&test_motion_tm[2]==0);
 setup();CHECK(!motion60_tick(3));ticks+=8000001;test_motion_tm[8]=2;
 CHECK(motion60_tick(3)==-101&&test_motion_tm[2]==0);
 setup();display_started=1;registers[0x43100004]=0x10;test_motion_tm[8]=2;
 CHECK(motion60_tick(3)==-107);
 std::printf("PASS fixed visible ROI/stopped-only/persistence; OVERLAY validation/persistence\n");
 std::printf("PASS scheduler completion_orders=2 clear_on_read_latched=1 stop_drain=1 normal_end=1 crc_guard=1 input_ownership=1\n");
 return 0;
}
