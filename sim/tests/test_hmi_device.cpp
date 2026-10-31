#define MOTION60_HMI
#define MOTION60_CAMERA_CONTROLS
#define BUTTON_TEST_MAIN unused_baseline_button_test
#include "test_mode_button.cpp"
#include <deque>
#include <vector>
volatile motion60_camera_control test_camera_control;
volatile uint32_t hmi_diagnostics[64];
volatile hmi_uart_stats hmi_uart_counters;
volatile hmi_probe_record hmi_probe;
static std::vector<uint8_t> probe_output;
static bool probe_writable=true;
static std::deque<uint8_t> incoming;
int hmi_uart_read(uint8_t*c){if(incoming.empty())return 0;*c=incoming.front();incoming.pop_front();return 1;}
int hmi_uart_write(const uint8_t*p,size_t n){if(!probe_writable)return 0;probe_output.assign(p,p+n);return 1;}
int hmi_uart_fault(void){return 0;}
static void touch(const char*s){while(*s)incoming.push_back((uint8_t)*s++);hmi_app_poll();}
static void cold(){
 incoming.clear();registers.clear();ticks=0;write_hook=0;
 std::memset((void*)&mailbox,0,sizeof(mailbox));std::memset((void*)&test_camera_control,0,sizeof(test_camera_control));
 enabled=busy=motion_done=stop_requested=config_pending=0;
 clip_active=clip_process_pending=clip_play_pending=0;clip_accel.busy=clip_playback.active=0;
 spectrum_active=0;tx_r=tx_w=line_n=line_discard=0;display_started=0;
 alpha_milli=12000;lo_milli=3000;hi_milli=12000;spectrum_enable=1;
 registers[0x43c00000]=registers[0x43c10000]=registers[0x43c20000]=4;
 registers[0x43000028]=0;mailbox.status=1;mailbox.sensor_exposure_lines=320;mailbox.sensor_gain_raw=16;
 motion60_init();
}
static void begin(){
 mailbox.command=0;mailbox.status=2;mailbox.error=0;
 CAMERA_CONTROL->applied_revision=CAMERA_CONTROL->revision;
 CAMERA_CONTROL->exposure_readback=mailbox.sensor_exposure_lines;
 motion60_begin();write_hook=finish_accelerator;
}
static void make_visible(){
 display_started=1;test_motion_tm[23]=2;test_motion_tm[2]=enabled==1?1:0;
 spectrum.display_generation=1;spectrum.displayed_enable=spectrum_enable;
 motion60_hmi_poll();
}
static void drained(){
 busy=0;spectrum.roi_busy=spectrum.fft_busy=spectrum.reset_pending=spectrum.sample_pending=spectrum.window.due=0;
 enabled=0;mailbox.status=3;test_motion_tm[1]=3;stop_requested=1;motion60_hmi_completed(0);
}
int main(){
 CHECK(debounce_test()==0);cold();
 const char *query="get page0.mode.val";
 for(unsigned i=0;query[i];i++)hmi_probe.command[i]=(uint8_t)query[i];
 hmi_probe.length=(unsigned)std::strlen(query);hmi_probe.request=1;probe_writable=false;
 hmi_probe_poll();CHECK(!hmi_probe.completed);
 probe_writable=true;hmi_probe_poll();CHECK(hmi_probe.completed==1&&hmi_probe.result==1);
 CHECK(probe_output.size()==std::strlen(query)+3&&probe_output.back()==255);
 hmi_probe.length=96;hmi_probe.request=2;hmi_probe_poll();CHECK(hmi_probe.completed==2&&hmi_probe.result==2);
 CHECK(!hdev.running&&!hdev.requested_run&&hdev.target[0]==2&&hdev.target[1]==12&&hdev.target[2]==320);
 touch("VIEW 0\r\nALPHA 50\r\nEXPOSURE 898\r\n");
 CHECK(!mailbox.command&&hdev.status[0]==HMI_QUEUED&&hdev.status[2]==HMI_QUEUED);
 touch("START\r\n");CHECK(mailbox.command==4&&enabled==2&&hbooting&&hdev.status[3]==HMI_WAIT);
 begin();motion60_hmi_poll();CHECK(hdev.status[3]==HMI_WAIT&&hdev.status[2]==HMI_APPLIED);
 make_visible();CHECK(hdev.status[3]==HMI_RUNNING&&hdev.status[0]==HMI_APPLIED&&hdev.status[1]==HMI_QUEUED);
 touch("EXPOSURE 1\r\n");CHECK(hdev.status[2]==HMI_BUSY&&mailbox.sensor_exposure_lines==898);
 touch("VIEW 2\r\n");CHECK(stop_requested&&hswitch_pending&&!mailbox.command&&hdev.status[0]==HMI_WAIT);
 motion60_hmi_poll();CHECK(!mailbox.command);drained();motion60_hmi_poll();CHECK(mailbox.command==4&&enabled==1);
 begin();make_visible();CHECK(hdev.status[0]==HMI_APPLIED&&hdev.status[1]==HMI_APPLIED&&registers[HLS+0x6c]==0x42480000u);
 touch("VIEW 1\r\n");CHECK(!stop_requested&&!mailbox.command&&hdev.status[0]==HMI_WAIT&&!spectrum_enable);
 for(unsigned i=0;i<100;i++)CHECK(!spectrum_service());
 motion60_hmi_poll();
 CHECK(spectrum.displayed_enable==0&&hdev.status[0]==HMI_APPLIED);
 /* ABA: an earlier in-flight hide must not acknowledge a later show. */
 spectrum.displayed_enable=1;spectrum.awaiting_display=1;spectrum.submitted_enable=0;
 touch("VIEW 2\r\n");CHECK(hdev.status[0]==HMI_WAIT);
 spectrum.awaiting_display=0;spectrum.displayed_enable=1;motion60_hmi_poll();CHECK(hdev.status[0]==HMI_APPLIED);
 /* Old frame completion is not evidence for a newly committed alpha. */
 busy=1;touch("ALPHA 31\r\n");CHECK(hdev.status[1]==HMI_WAIT&&config_pending);
 test_motion_tm[2]++;busy=0;config();motion60_hmi_poll();CHECK(hdev.status[1]==HMI_WAIT);
 test_motion_tm[2]++;motion60_hmi_poll();CHECK(hdev.status[1]==HMI_APPLIED&&registers[HLS+0x6c]==0x41f80000u);
 touch("ALPHA 51\r\n");CHECK(hdev.status[1]==HMI_REJECTED&&alpha_milli==31000);
 touch("VIEW 0\r\nSTOP\r\n");CHECK(!hdev.requested_run&&!hswitch_pending&&stop_requested);
 drained();motion60_hmi_poll();CHECK(hdev.status[3]==HMI_STOPPED&&!mailbox.command);
 CHECK(hdev.status[HMI_VIEW]==HMI_QUEUED);
 touch("EXPOSURE 1\r\nSTART\r\n");CHECK(mailbox.command==4&&mailbox.sensor_exposure_lines==1);
 touch("STOP\r\nSTART\r\n");CHECK(hstart_pending&&stop_requested);
 begin();drained();motion60_hmi_poll();CHECK(mailbox.command==4&&hdev.requested_run);
 begin();make_visible();touch("START\r\n");CHECK(!mailbox.command&&hdev.status[3]==HMI_RUNNING);
 /* Physical key shares the controller; explicit JTAG STOP cancels it. */
 sample_key(1,30);sample_key(0,26);CHECK(hswitch_pending&&hbutton_switch);
 test_motion_tm[8]=2;motion60_tick(0);CHECK(!hdev.requested_run&&!hswitch_pending&&!hbutton_switch);
 drained();touch("START\r\n");mailbox.command=0;mailbox.status=4;mailbox.error=13;
 motion60_hmi_completed(-13);CHECK(hdev.status[3]==HMI_ERROR&&!hdev.requested_run&&!hstart_pending);
 cold();touch("START\r\nSTOP\r\n");CHECK(!mailbox.command&&!hdev.requested_run&&hdev.status[3]==HMI_STOPPED);
 cold();touch("START\r\n");begin();make_visible();busy=1;
 touch("ALPHA 50\r\nSTOP\r\n");CHECK(hdev.status[HMI_ALPHA]==HMI_WAIT);
 drained();CHECK(hdev.status[HMI_ALPHA]==HMI_QUEUED&&hdev.target[HMI_ALPHA]==50);
 cold();clip_active=1;touch("START\r\nVIEW 0\r\nEXPOSURE 10\r\n");CHECK(!mailbox.command&&hdev.status[3]==HMI_BUSY&&hdev.status[0]==HMI_BUSY&&hdev.status[2]==HMI_BUSY);
 std::puts("HMI_DEVICE_PASSED real_scheduler views panel_commit alpha_frame exposure_readback stop_drain rapid_run key fault clip_ownership");return 0;
}
