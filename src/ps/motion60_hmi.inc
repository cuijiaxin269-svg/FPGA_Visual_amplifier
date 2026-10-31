/* Included in motion60.c: the sole owner of capture/HLS/spectrum state.
   No hardware owner or clear-on-read AP_CTRL is duplicated by the HMI. */
#include "hmi_device.h"
#include "hmi_link.h"
#include "hmi_uart.h"
#include "hmi_diagnostics.h"
static hmi_device_state hdev;
static hmi_link hlink;
static unsigned hmi_ready,hstart_pending,hswitch_pending,hbooting,hlast_mag=2;
static unsigned halpha_config,halpha_frame,hbutton_switch;
static uint64_t hlink_next;
static uint64_t hdiag_next;
static void hmi_diagnostics_publish(uint64_t ms){
 if(ms<hdiag_next)return;
 hdiag_next=ms+100;
 volatile uint32_t*d=hmi_diagnostics;
 d[2]++; /* Odd while this single main-loop writer is publishing. */
 d[3]=(uint32_t)ms;d[4]=(uint32_t)(ms>>32);
 for(unsigned i=0;i<3;i++){d[5+i]=hdev.target[i];d[8+i]=hdev.actual[i];d[11+i]=hdev.valid[i];}
 d[14]=hdev.running;d[15]=hdev.requested_run;
 for(unsigned i=0;i<4;i++){d[16+i]=hdev.status[i];d[20+i]=hdev.generation[i];}
 d[24]=hlink.page;d[25]=hlink.online;d[26]=hlink.parser.commands;d[27]=hlink.parser.rejected;
 d[28]=hlink.parser.native_packets;d[29]=hlink.parser.corrupt_packets;d[30]=hlink.parser.overlong;
 d[31]=hlink.transport_faults;d[32]=hlink.native_errors;d[33]=hlink.reconnects;
 d[34]=hmi_uart_counters.rx_bytes;d[35]=hmi_uart_counters.tx_bytes;
 d[36]=hmi_uart_counters.rx_overflow;d[37]=hmi_uart_counters.rx_errors;
 d[38]=hmi_uart_counters.tx_full;d[39]=hmi_uart_counters.interrupts;d[40]=hmi_uart_counters.unexpected_irq;
 d[41]=hstart_pending;d[42]=hswitch_pending;d[43]=hbooting;d[44]=stop_requested;d[45]=busy;
 d[46]=mailbox.status;d[47]=mailbox.error;d[48]=tm[5];d[49]=tm[2];d[50]=tm[23];
 d[51]=spectrum.display_generation;d[52]=spectrum.displayed_enable;d[53]=tm[12];
 d[57]=hlink.last_number;d[58]=hlink.numeric_replies;d[59]=hmi_probe.completed;d[60]=hmi_probe.result;
#ifdef MOTION60_CAMERA_CONTROLS
 d[54]=CAMERA_CONTROL->revision;d[55]=CAMERA_CONTROL->applied_revision;d[56]=CAMERA_CONTROL->exposure_readback;
#endif
#ifndef MOTION60_TEST_IO
 __asm__ volatile("dmb sy":::"memory");
#endif
 d[2]++;
}
static void hstatus(unsigned f,hmi_status status){
 if(hdev.status[f]!=status){hdev.status[f]=status;hdev.generation[f]++;}
}
static void hmi_defer_unapplied(void){
 for(unsigned f=HMI_VIEW;f<=HMI_ALPHA;f++)if(hdev.status[f]==HMI_WAIT)hstatus(f,HMI_QUEUED);
}
static void hmi_config_committed(void){halpha_config=tm[12];halpha_frame=tm[2];}
static unsigned hclip_owns(void){
#ifdef MOTION60_CLIP
 return clip_active||clip_process_pending||clip_play_pending||clip_playback.active||clip_accel.busy;
#else
 return 0;
#endif
}
static unsigned hidle(void){return !busy&&!spectrum_has_work()&&!mailbox.command&&mailbox.status!=2&&!hbooting;}
static void hmi_device_init(void){
 unsigned char*p=(unsigned char*)&hdev;for(size_t i=0;i<sizeof(hdev);i++)p[i]=0;
 hdev.target[HMI_VIEW]=2;hdev.target[HMI_ALPHA]=alpha_milli/1000u;
 hdev.target[HMI_EXPOSURE]=mailbox.sensor_exposure_lines;
 hdev.status[HMI_VIEW]=HMI_QUEUED;hdev.status[HMI_ALPHA]=HMI_QUEUED;
 hdev.status[HMI_EXPOSURE]=HMI_QUEUED;hdev.status[HMI_RUN]=HMI_STOPPED;
 for(unsigned i=0;i<HMI_FIELDS;i++)hdev.generation[i]=1;
 hstart_pending=hswitch_pending=hbooting=hbutton_switch=0;hlast_mag=2;
 halpha_config=halpha_frame=0;hlink_next=0;hmi_ready=1;
 hdiag_next=0;for(unsigned i=0;i<64;i++)hmi_diagnostics[i]=0;
 hmi_diagnostics[0]=0x484d4931u;hmi_diagnostics[1]=1;
 volatile uint32_t*q=(volatile uint32_t*)&hmi_probe;
 for(unsigned i=0;i<sizeof(hmi_probe)/4;i++)q[i]=0;
 hmi_probe.version=1;hmi_probe.magic=0x48514d31u;
}
void motion60_hmi_request(void*unused,const hmi_request*r){
 (void)unused;
 unsigned field=r->operation<=HMI_SET_EXPOSURE?(unsigned)r->operation:(unsigned)HMI_RUN;
 if(r->operation==HMI_UNKNOWN)return;
 hdev.generation[field]++;
 if(!r->valid){hstatus(field,HMI_REJECTED);return;}
 if(r->operation==HMI_STOP){
  hdev.requested_run=0;hstart_pending=hswitch_pending=hbutton_switch=0;
  button_cancel();stop_requested=1;
  if(hidle()&&!hclip_owns()){
   enabled=0;hdev.running=0;hstatus(HMI_RUN,(mailbox.error||tm[5])?HMI_ERROR:HMI_STOPPED);
   if(hdev.status[HMI_RUN]==HMI_STOPPED)hmi_defer_unapplied();
  }
  else hstatus(HMI_RUN,HMI_WAIT);
  return;
 }
 if(hclip_owns()){hstatus(field,HMI_BUSY);return;}
 if(r->operation==HMI_SET_EXPOSURE){
#ifdef MOTION60_CAMERA_CONTROLS
  if(!hidle()||enabled||hstart_pending||hswitch_pending){CAMERA_CONTROL->rejected_commands++;hstatus(field,HMI_BUSY);return;}
  mailbox.sensor_exposure_lines=r->value;CAMERA_CONTROL->exposure_lines=r->value;
  CAMERA_CONTROL->revision++;hdev.target[field]=r->value;hdev.valid[field]=0;
  hstatus(field,HMI_QUEUED);
#else
  hstatus(field,HMI_REJECTED);
#endif
 }else if(r->operation==HMI_SET_ALPHA){
  alpha_milli=r->value*1000u;config_pending=1;hdev.target[field]=r->value;
  hdev.valid[field]=0;halpha_config=tm[12];halpha_frame=tm[2];
  hstatus(field,mailbox.status==2&&enabled==1?HMI_WAIT:HMI_QUEUED);
 }else if(r->operation==HMI_SET_VIEW){
  hdev.target[field]=r->value;if(r->value)hlast_mag=r->value;
  spectrum_enable=r->value==2;
  if(spectrum_active){spectrum.enable=spectrum_enable;spectrum.dirty=1;}
  unsigned engine=r->value?1u:2u;
  if(mailbox.status==2||hbooting||mailbox.command){
   if(enabled!=engine){
    hswitch_pending=1;stop_requested=1;
    /* A VIEW must never undo an explicit STOP. */
    if(hdev.requested_run)hstatus(HMI_RUN,HMI_WAIT);
   }
   hstatus(field,HMI_WAIT);
  }else hstatus(field,HMI_QUEUED);
 }else if(r->operation==HMI_START){
  hdev.requested_run=1;
  if((mailbox.status==2||hbooting||mailbox.command)&&!stop_requested){
   hstatus(HMI_RUN,hdev.running?HMI_RUNNING:HMI_WAIT);
  }else{
   hstart_pending=1;hstatus(HMI_RUN,HMI_WAIT);
  }
 }
}
void motion60_hmi_snapshot(hmi_device_state*s){*s=hdev;}
void motion60_hmi_started(void){
 if(!hmi_ready)return;
 hbooting=0;hdev.running=0;hdev.valid[HMI_VIEW]=0;
 halpha_config=tm[12];halpha_frame=0;
 /* config() has run, but wait for at least one completed processed frame. */
 hdev.valid[HMI_ALPHA]=0;
}
void motion60_hmi_completed(int error){
 if(!hmi_ready)return;
 hbooting=0;hdev.running=0;
 if(error){
  hdev.requested_run=0;hstart_pending=hswitch_pending=hbutton_switch=0;button_cancel();
  hstatus(HMI_RUN,HMI_ERROR);
  if(hdev.status[HMI_VIEW]==HMI_WAIT)hstatus(HMI_VIEW,HMI_ERROR);
  if(hdev.status[HMI_ALPHA]==HMI_WAIT)hstatus(HMI_ALPHA,HMI_ERROR);
  if(hdev.status[HMI_EXPOSURE]==HMI_QUEUED)hstatus(HMI_EXPOSURE,HMI_ERROR);
 }else if(!hdev.requested_run||(!hstart_pending&&!hswitch_pending)){
  hdev.requested_run=0;hstart_pending=hswitch_pending=0;hstatus(HMI_RUN,HMI_STOPPED);
  hmi_defer_unapplied();
 }
}
void motion60_hmi_poll(void){
 if(!hmi_ready)return;
#ifdef MOTION60_CAMERA_CONTROLS
 if(CAMERA_CONTROL->applied_revision&&CAMERA_CONTROL->applied_revision==CAMERA_CONTROL->revision&&
    CAMERA_CONTROL->exposure_readback==hdev.target[HMI_EXPOSURE]){
  hdev.actual[HMI_EXPOSURE]=CAMERA_CONTROL->exposure_readback;hdev.valid[HMI_EXPOSURE]=1;
  if(hdev.status[HMI_EXPOSURE]==HMI_QUEUED||hdev.status[HMI_EXPOSURE]==HMI_WAIT)hstatus(HMI_EXPOSURE,HMI_APPLIED);
 }
#endif
 if((hstart_pending||hswitch_pending)&&hdev.requested_run&&hidle()&&!hclip_owns()){
  enabled=hdev.target[HMI_VIEW]?1u:2u;
  spectrum_enable=hdev.target[HMI_VIEW]==2;
  first=1;last_slot=3;last_events=0;stop_requested=0;hbooting=1;
  hstart_pending=hswitch_pending=0;mailbox.duration_ms=0;
  mailbox.electrical_ok=0x9281;mailbox.command=4;hdev.running=0;
  hstatus(HMI_RUN,HMI_WAIT);hstatus(HMI_VIEW,HMI_WAIT);
  return;
 }
 if(mailbox.status!=2||hbooting||stop_requested||mailbox.error||tm[5]||hclip_owns())return;
 unsigned ready=display_started&&tm[23]>=2&&(enabled==2||tm[2]>0);
 if(!ready)return;
 hdev.running=1;
 if(hdev.requested_run)hstatus(HMI_RUN,HMI_RUNNING);
 unsigned view=hdev.target[HMI_VIEW];
 unsigned visible=view==0?enabled==2:(enabled==1&&spectrum_active&&spectrum.display_generation&&spectrum.displayed_enable==(view==2)&&
   (!spectrum.awaiting_display||spectrum.submitted_enable==(view==2)));
 if(visible){
  hdev.actual[HMI_VIEW]=view;hdev.valid[HMI_VIEW]=1;
  if(hdev.status[HMI_VIEW]==HMI_WAIT||hdev.status[HMI_VIEW]==HMI_QUEUED)hstatus(HMI_VIEW,HMI_APPLIED);
#ifdef MOTION60_BUTTON
  if(hbutton_switch){button_tm[6]++;button_tm[5]=0;hbutton_switch=0;}
#endif
 }
 if(enabled==1&&!config_pending&&tm[11]==hdev.target[HMI_ALPHA]*1000u&&tm[2]>halpha_frame&&
    tm[12]>=halpha_config&&rd(HLS+0x6c)==bits((float)hdev.target[HMI_ALPHA])){
  hdev.actual[HMI_ALPHA]=hdev.target[HMI_ALPHA];hdev.valid[HMI_ALPHA]=1;
  if(hdev.status[HMI_ALPHA]==HMI_WAIT||hdev.status[HMI_ALPHA]==HMI_QUEUED)hstatus(HMI_ALPHA,HMI_APPLIED);
 }
}
static int hmi_transmit(void*c,const uint8_t*b,size_t n){(void)c;return hmi_uart_write(b,n);}
static void hmi_app_init(void){
 hmi_device_init();hmi_link_init(&hlink,0,motion60_hmi_request,hmi_transmit);
#ifndef MOTION60_TEST_IO
 hmi_uart_init();
#endif
}
static void hmi_probe_poll(void){
 uint32_t request=hmi_probe.request;
 if(request==hmi_probe.completed)return;
#ifndef MOTION60_TEST_IO
 __asm__ volatile("dmb sy":::"memory");
#endif
 uint8_t command[99];unsigned length=hmi_probe.length,valid=length>0&&length<96;
 if(valid)for(unsigned i=0;i<length;i++){
  command[i]=hmi_probe.command[i];if(command[i]<32||command[i]>126)valid=0;
 }
 if(hmi_probe.request!=request)return;
 if(valid){
  command[length]=command[length+1]=command[length+2]=255;
  if(!hmi_uart_write(command,length+3))return;
 }
 hmi_probe.result=valid?1u:2u;
#ifndef MOTION60_TEST_IO
 __asm__ volatile("dmb sy":::"memory");
#endif
 hmi_probe.completed=request;
}
static void hmi_app_poll(void){
 if(!hmi_ready)return;
 if(hmi_uart_fault())hmi_link_fault(&hlink);
 uint8_t c;unsigned drained=0;
 while(drained<512&&hmi_uart_read(&c)){hmi_parser_feed(&hlink.parser,c);drained++;}
 motion60_hmi_poll();
 uint64_t now=timer_ticks()/400000u;
 if(now>=hlink_next){hmi_link_poll(&hlink,&hdev,now);hlink_next=now+1;}
 hmi_probe_poll();
 hmi_diagnostics_publish(now);
}
static void hmi_button_request(void){
 hmi_request r={HMI_SET_VIEW,hdev.target[HMI_VIEW]?0u:hlast_mag,1};
 motion60_hmi_request(0,&r);hbutton_switch=1;
#ifdef MOTION60_BUTTON
 button_tm[5]=r.value?1:2;
#endif
}
static void hmi_external_stop(void){hmi_request r={HMI_STOP,0,1};motion60_hmi_request(0,&r);}
