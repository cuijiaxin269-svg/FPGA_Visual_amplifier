#include "capture.h"
#ifdef MOTION60_FIRMWARE
#include "motion60.h"
#endif
volatile capture_control mailbox __attribute__((section(".mailbox")));
#define LOG_BASE 0x01000000u
#define PHY_BASE 0x44a00000u
#define PHY_LOG 0x01020000u
#define CSI_BASE 0x44a00000u
#define CSI_LOG 0x01020400u
#define SENSOR_FRAME_LOG 0x01030000u
#define ECC_EVENT_LOG 0x01060000u
static uint32_t control;
static int full_csi;
static uint32_t csi_observed,csi_status;
static uint32_t observed_sof_seq;
static uint64_t observed_sof_cpu_ticks;
static int is_full_core(uint32_t id){return id==0x92810003u || id==0x92810004u || id==0x92810005u;}
static int has_sensor_metadata(uint32_t id){return id==0x92810004u || id==0x92810005u;}
static int probe_sensor(uint8_t *addr,uint16_t *id);
static void set_control(uint32_t v){control=v;wr(CTRL_BASE,v);}
static void snapshot(void){
 wr(CTRL_BASE,control&~(1u<<9));wr(CTRL_BASE,control|(1u<<9));
 for(unsigned i=0;i<16;i++){wr(CTRL_BASE,(control|(1u<<9))|(i<<4));mailbox.stats[i]=rd(CTRL_BASE+8);}
 wr(CTRL_BASE,control);
 if(mailbox.stats[1]!=observed_sof_seq){observed_sof_seq=mailbox.stats[1];observed_sof_cpu_ticks=timer_ticks();}
 if(full_csi && is_full_core(mailbox.stats[0])){
  if(has_sensor_metadata(mailbox.stats[0])){
   mailbox.sensor_frame_last=mailbox.stats[5];mailbox.sensor_frame_gaps=mailbox.stats[6];
   mailbox.sensor_frame_changes=mailbox.stats[7];mailbox.sensor_frame_sofs=mailbox.stats[9];
  }
  // Sticky status preserves even a single error; values below are presence
  // flags, not event counts. Do not W1C during the acceptance interval.
  uint32_t isr=rd(CSI_BASE+0x24);
  if(!mailbox.first_error_isr && (isr&0x58747fffu)){
   mailbox.first_error_sof=mailbox.stats[1];mailbox.first_error_timestamp_lo=mailbox.stats[11];
   mailbox.first_error_timestamp_hi=mailbox.stats[12];mailbox.first_error_isr=isr;
  }
  csi_observed|=isr;csi_status|=rd(CSI_BASE+0x10)&14u;
  uint32_t diagnostic_mask=mailbox.diagnostic_rearm_mask?mailbox.diagnostic_rearm_mask:0x400u;
  if(mailbox.ecc_diagnostic_rearm && (isr&diagnostic_mask)){
   // Diagnostic lower bound only: several events may coalesce between polls.
   // Software OR preserves every observed flag; normal acceptance never W1Cs.
   uint32_t n=mailbox.diagnostic_logged_events;
   if(n<512u){
    uint32_t base=ECC_EVENT_LOG+16u+n*32u;uint64_t delta=timer_ticks()-observed_sof_cpu_ticks;
    wr(base,mailbox.stats[1]);wr(base+4,mailbox.sensor_frame_last);
    wr(base+8,(uint32_t)delta);wr(base+12,(uint32_t)(delta>>32));wr(base+16,isr);
    wr(base+20,mailbox.stats[11]);wr(base+24,mailbox.stats[12]);wr(base+28,n);
   }
   if(isr&0x400u)mailbox.ecc_observed_events++;
   if(isr&0x200u)mailbox.crc_observed_events++;
   mailbox.diagnostic_logged_events++;wr(CSI_BASE+0x24,isr&diagnostic_mask);
  }
  mailbox.csi_isr_observed=csi_observed;mailbox.csi_csr_observed=csi_status;
  mailbox.stats[5]=(csi_observed>>10)&1u;
  mailbox.stats[6]=(csi_observed>>11)&1u;
  mailbox.stats[7]=(csi_observed>>9)&1u;
  mailbox.stats[8]|=(csi_observed&0x587471ffu)!=0 || (csi_status&10u)!=0;
  mailbox.stats[9]=rd(CSI_BASE+0x10)>>16;
 }
}
static int probe_sensor(uint8_t *addr,uint16_t *id){
 if(!sensor_probe(addr,id))return 0;
 if(mailbox.sccb_gpio_mode)return -1;
 snapshot();
 if((is_full_core(mailbox.stats[0]) || mailbox.stats[0]==0x92810001u) && !sensor_bus_recover()){
  if(!sensor_probe(addr,id))return 0;
  // An independent, slow open-drain ID transaction recovered ACK after a cold
  // restart where clock/STOP recovery alone did not. It starts no stream and
  // always releases GPIO ownership before retrying the normal PS controller.
  uint32_t samples=0;
  if(!sensor_gpio_probe(addr,id,&samples))return sensor_probe(addr,id);
 }
 return -1;
}
static int ddr_test(void){
 // CPU-owned 4KiB within the reserved DMA region, before VDMA starts.
 volatile uint32_t *p=(volatile uint32_t *)(uintptr_t)FRAME0;
 unsigned errors=0;
 for(unsigned pass=0;pass<4;pass++){
  for(unsigned i=0;i<1024;i++)p[i]=(pass&1)?~(i*0x01010101u):(i*0x01010101u);
  __asm__ volatile("dsb sy":::"memory");
  for(unsigned i=0;i<1024;i++)if(p[i]!=((pass&1)?~(i*0x01010101u):(i*0x01010101u)))errors++;
 }
 mailbox.ddr_errors=errors;return errors?-1:0;
}
static int vdma_reset(void){
 wr(VDMA_BASE+0x30,4);uint64_t end=timer_ticks()+40000000u;
 while(rd(VDMA_BASE+0x30)&4u)if(timer_ticks()>end)return -1;
 return 0;
}
static void vdma_start(void){
 wr(VDMA_BASE+0x34,0x70f0u);
 for(unsigned i=0;i<3;i++)wr(VDMA_BASE+0xac+4*i,FRAME0+i*FRAME_SPACING);
 wr(VDMA_BASE+0xa8,STRIDE);wr(VDMA_BASE+0xa4,STRIDE);
 // Circular triple buffer, IRQ threshold=1; polling drains status without an ISR.
 wr(VDMA_BASE+0x30,0x00011003u);wr(VDMA_BASE+0xa0,HEIGHT);
}
static int vdma_stop(void){
 wr(VDMA_BASE+0x30,rd(VDMA_BASE+0x30)&~1u);
 uint64_t end=timer_ticks()+40000000u;
 while(!(rd(VDMA_BASE+0x34)&1u)){
#ifdef MOTION60_FIRMWARE
  motion60_drain_poll();
#endif
  if(timer_ticks()>end)return -1;
 }
 return 0;
}
static void phy_log(unsigned stage){
 // Raw register snapshots, not a claim that AUTO tap values are exposed here.
 const uint32_t offsets[]={0,4,8,0x0c,0x10,0x18,0x1c,0x20,0x30,0x48};
 uint32_t base=PHY_LOG+stage*128u;
 wr(base,0x44504859u);wr(base+4,stage);
 uint32_t phy=PHY_BASE+(full_csi?0x1000u:0);
 for(unsigned i=0;i<sizeof(offsets)/sizeof(offsets[0]);i++)wr(base+8+i*4,rd(phy+offsets[i]));
 snapshot();for(unsigned i=0;i<16;i++)wr(base+48+i*4,mailbox.stats[i]);
 if(full_csi){
  const uint32_t regs[]={0,4,0x10,0x20,0x24,0x28,0x2c,0x3c,0x40,0x44,0x60,0x64};
  base=CSI_LOG+stage*128u;wr(base,0x43534932u);wr(base+4,stage);
  for(unsigned i=0;i<sizeof(regs)/sizeof(regs[0]);i++)wr(base+8+4*i,rd(CSI_BASE+regs[i]));
 }
}
static int csi_wait_reset(void){
 uint64_t end=timer_ticks()+40000000u;
 while(rd(CSI_BASE+0x10)&1u)if(timer_ticks()>end)return -24;
 return 0;
}
static int csi_warmup(uint8_t addr){
 mailbox.recovered_byte_div256_edges=0;mailbox.recovered_clock_elapsed_lo=0;mailbox.recovered_clock_elapsed_hi=0;
 uint32_t phy=PHY_BASE+0x1000u,settle=mailbox.phy_hs_settle;
 if(settle<17u || settle>160u)return -23;
 mailbox.sensor_prime_fast_readback=0;mailbox.sensor_prime_restore_readback=0;
 if(mailbox.sensor_fullrate640){
  uint8_t fast=0;
  if(sensor_write(addr,0x0106,1)||sensor_read(addr,0x0106,&fast)||fast!=1u)return -63;
  mailbox.sensor_prime_fast_readback=fast;
 }
 // Exercise synchronous byte-clock reset while the sensor clock is present,
 // then release the global reset in LP11. Standby-only reset left PHY packet
 // counters from the preceding run, so it cannot establish a clean baseline.
 wr(0xf8000008u,0xdf0du);uint32_t reset=rd(0xf8000240u);
 wr(0xf8000240u,reset|1u);
 int clock_start=sensor_write(addr,0x0100,1);delay_us(10000);
 int clock_stop=sensor_write(addr,0x0100,0);delay_us(10000);
 wr(0xf8000240u,reset&~1u);wr(0xf8000004u,0x767bu);
 if(mailbox.sensor_fullrate640){
  uint8_t restored=0xffu;
  if(sensor_write(addr,0x0106,0)||sensor_read(addr,0x0106,&restored)||restored!=0)return -64;
  mailbox.sensor_prime_restore_readback=restored;
 }
 delay_us(2000);control=0;
 if(clock_start || clock_stop)return -30;
 set_control(1u<<13);delay_us(20);set_control(0);
 wr(phy,2u);wr(phy+0x30,settle);wr(phy+0x48,settle);
 if(mailbox.phy_manual_taps){
  if(mailbox.stats[0]!=0x92810005u || mailbox.phy_tap_l0<1u || mailbox.phy_tap_l0>31u ||
     mailbox.phy_tap_l1<1u || mailbox.phy_tap_l1>31u)return -42;
  uint32_t taps=0x01010000u|(mailbox.phy_tap_l1<<8)|mailbox.phy_tap_l0;
  wr(phy+4,taps);mailbox.phy_tap_readback=rd(phy+4);
  if((mailbox.phy_tap_readback&0x1f1fu)!=(taps&0x1f1fu))return -43;
 }
 wr(CSI_BASE+0x20,0);wr(CSI_BASE+0x28,0);wr(CSI_BASE,1);
 uint64_t end=timer_ticks()+40000000u;
 while(((rd(phy+0x18)&rd(phy+0x1c)&rd(phy+0x20))&8u)==0)
  if(timer_ticks()>end){phy_log(0);return -20;}
 phy_log(0);
 // Configure while the sensor is in LP11 standby. On this generated subsystem,
 // a controller soft reset during continuous clock loses the PHY HS state; a
 // subsequent LP11 initialization interval is required before reception resumes.
 wr(CSI_BASE,2);if(csi_wait_reset())return -24;
 wr(CSI_BASE+4,1); // Two lanes encoded as lanes-1; hardware max remains read-only.
 wr(CSI_BASE+0x2c,1); // VC0 selection mask when dynamic selection is enabled.
 wr(CSI_BASE,1);delay_us(20);
 if(sensor_write(addr,0x0100,1))return -14;
 if(mailbox.phy_active_tap_reload){
  if(mailbox.phy_active_tap_reload!=1u || !mailbox.phy_manual_taps)return -55;
  // Program again with the recovered byte clock actually running. AXI register
  // readback while standby proves the request value, not physical IDELAY load.
  delay_us(10000);
  wr(phy+4,0x01010000u|(mailbox.phy_tap_l1<<8)|mailbox.phy_tap_l0);
  mailbox.phy_active_tap_readback=rd(phy+4);
 }
 // The existing hardware counter counts rising edges of byteclk/256, using
 // a 2FF synchronized single-bit toggle. Read only its diagnostic status mux
 // during warmup, with the pixel adapter still disabled. Restore normal mux
 // before snapshots; do not change controls during the measured capture.
 set_control((1u<<12)|(1u<<24));delay_us(2);
 uint32_t edges_before=rd(CTRL_BASE+8);uint64_t clock_begin=timer_ticks();
 delay_us(1000000);
 uint64_t clock_elapsed=timer_ticks()-clock_begin;
 mailbox.recovered_byte_div256_edges=rd(CTRL_BASE+8)-edges_before;
 mailbox.recovered_clock_elapsed_lo=(uint32_t)clock_elapsed;
 mailbox.recovered_clock_elapsed_hi=(uint32_t)(clock_elapsed>>32);
 set_control(0);phy_log(1);
 // Begin the validated interval in vertical blanking, after a complete warmup
 // frame. Clearing arbitrary mid-line status can leave a previous partial
 // packet's delayed CRC event before the first captured SOF.
 wr(CSI_BASE+0x24,0xffffffffu);
 end=timer_ticks()+40000000u;
 while(!(rd(CSI_BASE+0x24)&0x80000000u))if(timer_ticks()>end)return -44;
 mailbox.csi_warmup_end_isr=rd(CSI_BASE+0x24);
 // Keep the warmup frame's delayed status outside the measurement interval.
 // This bounded wait remains in the ~1 ms vertical blanking interval; errors
 // are cleared once before capture, never during the measured run.
 if(mailbox.csi_boundary_drain_us>500u)return -50;
 delay_us(mailbox.csi_boundary_drain_us);
 // Drain the warmup to the disabled adapter and clear sticky diagnostics only.
 // Do not reset an initialized continuous-clock PHY at this boundary.
 wr(CSI_BASE+0x24,0xffffffffu);csi_observed=0;csi_status=0;
 mailbox.first_error_isr=0;mailbox.first_error_sof=0;mailbox.first_error_timestamp_lo=0;
 mailbox.first_error_timestamp_hi=0;mailbox.ecc_observed_events=0;
 delay_us(20);phy_log(2);
 return 0;
}
static int phy_warmup(uint8_t addr){
 set_control(1u<<13);delay_us(20);set_control(0);
 wr(PHY_BASE,2u);
 // Raw HS_SETTLE register value on both lanes; capture logs record readback.
 // PG202 describes core-clock cycles, while the generated default is 147.
 // Keep it selectable to verify the actual 7-series implementation on traffic.
 uint32_t settle=mailbox.phy_hs_settle;
 if(settle<17u || settle>160u)return -23;
 wr(PHY_BASE+0x30,settle);wr(PHY_BASE+0x48,settle);delay_us(10);
 uint64_t end=timer_ticks()+40000000u;
 while(((rd(PHY_BASE+0x18)&rd(PHY_BASE+0x1c)&rd(PHY_BASE+0x20))&8u)==0)
  if(timer_ticks()>end){phy_log(0);return -20;}
 phy_log(0);
 if(sensor_write(addr,0x0100,1))return -14;
 delay_us(1000000);phy_log(1);
 // Keep the recovered byte clock running while resetting its domain. A pulse
 // during sensor standby can be missed by proc_sys_reset's synchronous input.
 set_control(1u<<10);delay_us(100);
 end=timer_ticks()+40000000u;
 while(!(rd(PHY_BASE+0x1c)&rd(PHY_BASE+0x20)&0x40u))
  if(timer_ticks()>end)return -22;
 // Release in a data-lane LP stop interval, retain continuous clock and taps.
 set_control(0);delay_us(20);
 phy_log(2);return 0;
}
static int run_capture(int camera,int single){
 int receiver_only=camera==2;
 mailbox.capture_source_command=receiver_only?7u:(camera?4u:(single?1u:2u));
 if(receiver_only && (single || mailbox.test_pattern || mailbox.sensor_solid_test ||
    mailbox.ecc_diagnostic_rearm || mailbox.diagnostic_rearm_mask))return -67;
 if(camera){mailbox.sensor_address=0;mailbox.sensor_id=0;}
 mailbox.dma_events=0;mailbox.sample_count=0;mailbox.sequence_gaps=0;
 uint32_t frame_limit=mailbox.test_frame_limit?mailbox.test_frame_limit:3u;
 if(single && (frame_limit<3u || frame_limit>10u))return -51;
 if(camera && mailbox.electrical_ok!=0x9281u)return -10;
#ifdef MOTION60_FIRMWARE
 int prepare_error=motion60_prepare_reset();
 if(prepare_error)return prepare_error;
#endif
 // Reset the entire pipeline, including asynchronous FIFOs and VDMA, between runs.
 // A stopped ring retains a partial next frame; parser-only reset cannot flush it.
 set_control(0);
 snapshot();full_csi=is_full_core(mailbox.stats[0]);
 mailbox.sensor_frame_last=0;mailbox.sensor_frame_gaps=0;mailbox.sensor_frame_changes=0;mailbox.sensor_frame_sofs=0;
 mailbox.first_error_isr=0;mailbox.ecc_observed_events=0;
 mailbox.crc_observed_events=0;mailbox.diagnostic_logged_events=0;
 if(mailbox.diagnostic_rearm_mask && mailbox.diagnostic_rearm_mask!=0x200u &&
    mailbox.diagnostic_rearm_mask!=0x400u && mailbox.diagnostic_rearm_mask!=0x600u)return -52;
 observed_sof_seq=0;observed_sof_cpu_ticks=timer_ticks();wr(ECC_EVENT_LOG,0xecec0101u);
 csi_observed=0;csi_status=0;mailbox.csi_isr_observed=0;mailbox.csi_csr_observed=0;
 int auto_phy=camera && mailbox.stats[0]==0x92810002u;
 wr(0xf8000008u,0xdf0du);
 uint32_t reset=rd(0xf8000240u);
 wr(0xf8000240u,reset|1u);delay_us(20);
 wr(0xf8000240u,reset&~1u);wr(0xf8000004u,0x767bu);delay_us(20);
 control=0;mailbox.valid_buffer_mask=0;
 set_control(8);delay_us(20);set_control(0);
 if(vdma_reset() || (!receiver_only && ddr_test()))return -11;
 uint8_t addr=0;uint16_t id=0;
 if(camera){
  // This Renheng module runs on ELF2 without an external clock on P16.4.
  // Leave JP1.4/MCLK high impedance; use the module's own oscillator.
  set_control(0);delay_us(10000);
  if(mailbox.sccb_gpio_mode>1u)return -56;
  if(sensor_select_gpio(mailbox.sccb_gpio_mode!=0))return -57;
  if(probe_sensor(&addr,&id))return -12;
  mailbox.sensor_address=addr;mailbox.sensor_id=id;
  if(sensor_configure(addr,mailbox.test_pattern!=0))return -13;
  // Explicitly clear and verify sensor test controls for genuine scene runs;
  // mode flags alone do not prove a preceding solid diagnostic was disabled.
  uint8_t real_solid_ctrl=0,bar_control=0;
  if(sensor_read(addr,0x4320,&real_solid_ctrl) ||
     sensor_write(addr,0x4320,(uint8_t)(real_solid_ctrl&~2u)) ||
     sensor_read(addr,0x4320,&real_solid_ctrl) || sensor_read(addr,0x5e00,&bar_control))return -61;
  mailbox.sensor_solid_ctrl_readback=real_solid_ctrl;mailbox.sensor_bar_readback=bar_control;
  if((real_solid_ctrl&2u) || bar_control!=(mailbox.test_pattern?0x80u:0u))return -62;
  if(mailbox.sensor_solid_test){
   if(mailbox.sensor_solid_test>2u || mailbox.sensor_solid_value>1023u ||
      mailbox.sensor_solid_second>1023u || mailbox.test_pattern)return -58;
   // OV9281 4.3.2: actual on-sensor ten-bit solid P1/P2/P4/P3 test pixels.
   // All four equal values remove Bayer-order ambiguity; this is not PL data.
   uint8_t solid_ctrl=0;
   if(sensor_read(addr,0x4320,&solid_ctrl))return -59;
   for(unsigned pixel=0;pixel<4;pixel++){
    // Register order is P1/P2/P4/P3; mode2 makes both rows alternate P1/P2.
    uint32_t value=(mailbox.sensor_solid_test==2u && (pixel==1u || pixel==2u))?
                   mailbox.sensor_solid_second:mailbox.sensor_solid_value;
    uint16_t reg=(uint16_t)(0x4322u+pixel*2u);uint8_t hi=0,lo=0;
    if(sensor_write(addr,reg,(uint8_t)(value>>8)) ||
       sensor_write(addr,reg+1,(uint8_t)value) ||
       sensor_read(addr,reg,&hi) || sensor_read(addr,reg+1,&lo))return -59;
    mailbox.sensor_solid_pixel_readback[pixel]=((uint32_t)(hi&3u)<<8)|lo;
    if(mailbox.sensor_solid_pixel_readback[pixel]!=value)return -60;
   }
   if(sensor_write(addr,0x4320,(uint8_t)(solid_ctrl|2u)) || sensor_read(addr,0x4320,&solid_ctrl))return -59;
   mailbox.sensor_solid_ctrl_readback=solid_ctrl;
   if(!(solid_ctrl&2u))return -60;
  }
  if(full_csi){
   // Restore every experimental timing register explicitly between runs.
   // A zero diagnostic argument must select the standard profile, not retain
   // timing values from the preceding diagnostic experiment.
   if(sensor_write(addr,0x4802,0) || sensor_write(addr,0x481f,0x26) ||
      sensor_write(addr,0x4826,0x32) || sensor_write(addr,0x4824,0) ||
      sensor_write(addr,0x4825,0x32))return -29;
   mailbox.sensor_prepare_readback=0;mailbox.sensor_lpx_readback=50;
   if(mailbox.sensor_clock_gated>1u || mailbox.sensor_clock_first_bit>1u || mailbox.sensor_pclk_invert>1u)return -31;
   uint8_t clock_mode=(uint8_t)((mailbox.sensor_clock_gated?0x20u:0)|
                     (mailbox.sensor_clock_first_bit?2u:0)|(mailbox.sensor_pclk_invert?4u:0));
   if(sensor_write(addr,0x4800,clock_mode) ||
      sensor_read(addr,0x4800,&clock_mode))return -32;
   mailbox.sensor_clock_readback=clock_mode;
   mailbox.sensor_pclk_invert_readback=(clock_mode>>2)&1u;
   if(mailbox.sensor_pclk_invert_readback!=mailbox.sensor_pclk_invert)return -65;
   // OV9281 SC_MIPI_PHY1[5:4] is the documented LP transmitter drive code.
   // Keep r_iref/bitsel unchanged; characterize all four codes without claiming
   // an undocumented weak/strong ordering or changing the lane rate.
   if(mailbox.sensor_lp_drive>3u || mailbox.sensor_iref_code>3u)return -35;
   // SC_MIPI_PHY1[3:2] r_iref is a documented two-bit code. Its current/
   // amplitude ordering is not specified, so no weak/strong meaning is assigned.
   uint8_t lp_drive=(uint8_t)((mailbox.sensor_iref_code<<2)|(mailbox.sensor_lp_drive<<4));
   if(sensor_write(addr,0x3013,lp_drive) || sensor_read(addr,0x3013,&lp_drive))return -36;
   mailbox.sensor_lp_drive_readback=lp_drive;
   mailbox.sensor_iref_readback=(lp_drive>>2)&3u;
   if(mailbox.sensor_iref_readback!=mailbox.sensor_iref_code)return -69;
   if(mailbox.sensor_hstx_open_term>1u)return -70;
   if(mailbox.sensor_hs_vcm>7u || mailbox.sensor_hs_drive>15u || mailbox.sensor_d1_skew>3u ||
      mailbox.sensor_d0_skew>3u || mailbox.sensor_clock_skew>3u)return -53;
   uint8_t vcm=0,drive=0;
   // Documented transmitter fields only; preserve lane skew and other bits.
   if(sensor_read(addr,0x3011,&vcm) || sensor_read(addr,0x3012,&drive) ||
      sensor_write(addr,0x3011,(uint8_t)((vcm&~0xe7u)|(mailbox.sensor_hstx_open_term<<7)|mailbox.sensor_hs_vcm|(mailbox.sensor_d1_skew<<5))) ||
      sensor_write(addr,0x3012,(uint8_t)((mailbox.sensor_hs_drive<<4)|
                   (mailbox.sensor_clock_skew<<2)|mailbox.sensor_d0_skew)) ||
      sensor_read(addr,0x3011,&vcm) || sensor_read(addr,0x3012,&drive))return -54;
   mailbox.sensor_hs_vcm_readback=vcm;mailbox.sensor_hs_drive_readback=drive;
   mailbox.sensor_hstx_open_term_readback=(vcm>>7)&1u;
   if(mailbox.sensor_hstx_open_term_readback!=mailbox.sensor_hstx_open_term)return -71;
   mailbox.sensor_d1_skew_readback=vcm;
   if(((vcm>>5)&3u)!=mailbox.sensor_d1_skew)return -63;
   mailbox.sensor_d0_skew_readback=drive&3u;
   mailbox.sensor_clock_skew_readback=(drive>>2)&3u;
   if(mailbox.sensor_d0_skew_readback!=mailbox.sensor_d0_skew ||
      mailbox.sensor_clock_skew_readback!=mailbox.sensor_clock_skew)return -64;
   uint32_t hs_zero=mailbox.sensor_hs_zero_ns?mailbox.sensor_hs_zero_ns:112u;
   if(hs_zero<112u || hs_zero>400u)return -38;
   uint8_t zh=0,zl=0;
   if(sensor_write(addr,0x4818,(uint8_t)(hs_zero>>8)) || sensor_write(addr,0x4819,(uint8_t)hs_zero) ||
      sensor_read(addr,0x4818,&zh) || sensor_read(addr,0x4819,&zl))return -39;
   mailbox.sensor_hs_zero_readback=((uint32_t)(zh&3u)<<8)|zl;
   uint32_t period=mailbox.sensor_mipi_period?mailbox.sensor_mipi_period:16u;
   if(mailbox.sensor_half_rate_diagnostic==1u ? period!=32u : (period!=10u && period!=12u && period!=13u && period!=16u && period!=18u && period!=20u && period!=23u))return -40;
   uint8_t period_readback=0;
   // 4837 is the documented pclk2x timing period with one fractional bit.
   // Compare nearest 6/6.5ns encodings to reset's 8ns encoding; PLL/lane rate
   // stays unchanged. Observed LP/HS/error data determines the outcome.
   if(sensor_write(addr,0x4837,(uint8_t)period) || sensor_read(addr,0x4837,&period_readback))return -41;
   mailbox.sensor_mipi_period_readback=period_readback;
   if(mailbox.sensor_frame_counter_mode>2u)return -45;
   uint16_t maximum=mailbox.sensor_frame_counter_mode==1u?127u:65535u;
   uint8_t ch=0,cl=0,cm=0;
   if(sensor_write(addr,0x4810,(uint8_t)(maximum>>8)) || sensor_write(addr,0x4811,(uint8_t)maximum) ||
      sensor_read(addr,0x484c,&cm) || sensor_write(addr,0x484c,(uint8_t)((cm&~1u)|(mailbox.sensor_frame_counter_mode==2u))) ||
      sensor_read(addr,0x4810,&ch) || sensor_read(addr,0x4811,&cl) || sensor_read(addr,0x484c,&cm))return -46;
   mailbox.sensor_frame_counter_readback=((uint32_t)ch<<8)|cl;
   mailbox.sensor_frame_counter_ctrl_readback=cm;
   if((cm&7u)!=(mailbox.sensor_frame_counter_mode==2u?1u:0u))return -49;
   uint32_t trail=mailbox.sensor_hs_trail_ns?mailbox.sensor_hs_trail_ns:60u;
   if(trail!=60u && trail!=120u && trail!=180u)return -47;
   uint8_t th=0,tl=0;
   if(sensor_write(addr,0x481a,(uint8_t)(trail>>8)) || sensor_write(addr,0x481b,(uint8_t)trail) ||
      sensor_read(addr,0x481a,&th) || sensor_read(addr,0x481b,&tl))return -48;
   mailbox.sensor_hs_trail_readback=((uint32_t)(th&3u)<<8)|tl;
  }
  if(full_csi && mailbox.sensor_prepare_raw){
   // Raw manual timing diagnostic only. Manual select changes the register
   // interpretation; observed LP00 duration must establish timing, not its name.
   if(mailbox.sensor_prepare_raw!=80u)return -26;
   uint8_t mode=0,clock_prepare=0,data_prepare=0;
   if(sensor_read(addr,0x4802,&mode) || sensor_write(addr,0x481f,80) ||
      sensor_write(addr,0x4826,80) || sensor_write(addr,0x4802,mode|0xc0u) ||
      sensor_read(addr,0x4802,&mode) || sensor_read(addr,0x481f,&clock_prepare) ||
      sensor_read(addr,0x4826,&data_prepare))return -27;
   mailbox.sensor_prepare_readback=((uint32_t)mode<<16)|((uint32_t)clock_prepare<<8)|data_prepare;
  }
  if(full_csi && mailbox.sensor_lpx_ns){
   if(mailbox.sensor_lpx_ns!=400u)return -28;
   uint8_t hi=0,lo=0;
   // LP01 is the LPX request interval, distinct from LP00 HS_PREPARE.
   if(sensor_write(addr,0x4802,0) || sensor_write(addr,0x481f,0x26) ||
      sensor_write(addr,0x4826,0x32) || sensor_write(addr,0x4824,1) ||
      sensor_write(addr,0x4825,0x90) || sensor_read(addr,0x4824,&hi) ||
      sensor_read(addr,0x4825,&lo))return -29;
   mailbox.sensor_lpx_readback=((uint32_t)hi<<8)|lo;
  }
  if(full_csi && mailbox.sensor_lpx_raw){
   if(mailbox.sensor_lpx_raw!=80u || mailbox.sensor_lpx_ns || mailbox.sensor_prepare_raw)return -33;
   uint8_t mode=0,lo=0;
   // 4800[0] selects direct pclk-domain LPX cycles. This is raw 80 cycles,
   // not 80 ns. Record observed LP timing before making any timing claim.
   if(sensor_read(addr,0x4800,&mode) || sensor_write(addr,0x4824,0) ||
      sensor_write(addr,0x4825,80) || sensor_write(addr,0x4800,mode|1u) ||
      sensor_read(addr,0x4800,&mode) || sensor_read(addr,0x4825,&lo))return -34;
   mailbox.sensor_clock_readback=mode;mailbox.sensor_lpx_readback=lo;
  }
  if(full_csi){int e=csi_warmup(addr);if(e)return e;}
  else if(auto_phy){int e=phy_warmup(addr);if(e)return e;}
 }
 if(receiver_only){
  // Isolate bulk pixel DMA activity. CPU software/mailbox still reside in DDR;
  // this is not a claim that all DDR electrical activity has stopped.
  // AMD video output is drained by !run; no camera pixels enter the DMA FIFO.
  if(!full_csi)return -67;
  mailbox.valid_buffer_mask=0;mailbox.dma_events=0;mailbox.sample_count=0;
  mailbox.ddr_errors=0; // DDR test is deliberately skipped in this diagnostic.
  set_control(0);
  uint64_t end=timer_ticks()+(uint64_t)mailbox.duration_ms*400000u;
  while(timer_ticks()<end){
   uint32_t status=rd(VDMA_BASE+0x34);
   mailbox.dma_status=status;
   if((rd(VDMA_BASE+0x30)&1u) || !(status&1u) || (status&0x4ff0u))return -68;
   snapshot();delay_us(1000);
  }
  mailbox.csi_isr_before_stream_off=csi_observed|rd(CSI_BASE+0x24);
  int off=sensor_write(addr,0x0100,0);delay_us(10000);
  snapshot();phy_log(3);mailbox.dma_status=rd(VDMA_BASE+0x34);
  if(off)return -14;
  return mailbox.stats[5] || mailbox.stats[6] || mailbox.stats[7] || mailbox.stats[8] ? -21:0;
 }
 vdma_start();set_control(camera?1u:3u);
 if(camera && !auto_phy && !full_csi && sensor_write(addr,0x0100,1))return -14;
 mailbox.dma_events=0;mailbox.sample_count=0;mailbox.sequence_gaps=0;
 uint32_t lastseq=0,events=0;
 // Ensure the first-to-last actual SOF timestamps cover at least 60 seconds,
 // rather than accepting a 60-second polling window with shorter SOF span.
 uint32_t measurement_ms=single?2000u:mailbox.duration_ms;
 int continuous=0,user_stopped=0;
#ifdef MOTION60_FIRMWARE
 continuous=!single&&!measurement_ms;
 motion60_begin();
#endif
 if(!single && measurement_ms==60000u) {
#ifdef MOTION60_FIRMWARE
  // Include initial capture-buffer fill in the 60-second processing proof.
  measurement_ms+=250u;
#else
  measurement_ms+=50u;
#endif
 }
 uint64_t end=timer_ticks()+(uint64_t)measurement_ms*400000u;
 while(continuous||timer_ticks()<end){
  uint32_t s=rd(VDMA_BASE+0x34);mailbox.dma_status=s;
  if(s&0x4ff0u){if(camera)(void)sensor_write(addr,0x0100,0);set_control(0);(void)vdma_stop();return -15;}
  if(s&0x1000u){events++;wr(VDMA_BASE+0x34,0x1000);}
  snapshot();uint32_t seq=mailbox.stats[1];
#ifdef MOTION60_FIRMWARE
  int motion_error=motion60_tick(events);
  if(motion_error==1)user_stopped=1;
  else if(motion_error){if(camera)(void)sensor_write(addr,0x0100,0);set_control(0);(void)vdma_stop();return motion_error;}
#endif
  if(seq!=lastseq){
   if(lastseq && seq-lastseq!=1u)mailbox.sequence_gaps+=seq-lastseq-1u;
   uint32_t n=mailbox.sample_count;
   if(n<8192){volatile uint32_t *p=(volatile uint32_t *)(uintptr_t)(LOG_BASE+n*16u);
    p[0]=seq;p[1]=mailbox.stats[11];p[2]=mailbox.stats[12];p[3]=mailbox.stats[10];mailbox.sample_count=n+1;}
   if(camera && full_csi && n<8192)wr(SENSOR_FRAME_LOG+n*4u,mailbox.sensor_frame_last);
   lastseq=seq;
  }
  if(user_stopped || (single && events>=frame_limit))break;
 }
 // Stop DMA at a frame boundary before turning off the input; wait for HALTED.
 mailbox.write_slot_before_stop=(rd(VDMA_BASE+0x28)>>24)&31u;
 int stop=vdma_stop();
 // Release the receiver's output immediately after DMA halts. Otherwise
 // draining the last algorithm frame backpressures CSI and can overflow its
 // line buffer while the camera is still streaming.
 if(full_csi){mailbox.csi_isr_before_stream_off=csi_observed|rd(CSI_BASE+0x24);set_control(0);}
#ifdef MOTION60_FIRMWARE
 // vdma_stop polls in-flight completions. Finish the drain before the slow
 // SCCB/CSI shutdown; do not extend the capture window with a pre-stop drain.
 int motion_end_error=motion60_end();
#endif
 // PARK_PTR's current write slot resets to zero on HALTED. Preserve the
 // live value before stopping, otherwise a partially overwritten slot can
 // be published as complete when the run length is not a multiple of three.
 mailbox.halted_write_slot=(rd(VDMA_BASE+0x28)>>24)&31u;
 mailbox.stopped_write_slot=mailbox.write_slot_before_stop;
 mailbox.valid_buffer_mask= (events>=3 && mailbox.stopped_write_slot<3) ? (7u & ~(1u<<mailbox.stopped_write_slot)) : 0;
 // SCCB stream-off takes hundreds of microseconds at 100kHz. Drain AMD's
 // video FIFO while the halted VDMA owns no buffers, rather than creating an
 // avoidable line-buffer overflow during that control transaction.
 if(camera)(void)sensor_write(addr,0x0100,0);
 if(camera && full_csi)delay_us(10000);
 set_control(0);snapshot();mailbox.dma_events=events;mailbox.dma_status=rd(VDMA_BASE+0x34);
#ifdef MOTION60_FIRMWARE
 if(motion_end_error)return motion_end_error;
#endif
 if(auto_phy || (camera && full_csi))phy_log(3);
 if(stop)return -16;
 if(single && events<frame_limit)return -17;
 uint32_t minimum_fps=mailbox.sensor_half_rate_diagnostic?59u:119u;
 if(!single && ((!user_stopped&&mailbox.stats[1]<(mailbox.duration_ms*minimum_fps)/1000u) || mailbox.sequence_gaps))return -18;
 if(camera && (mailbox.stats[3] || mailbox.stats[4] || mailbox.stats[5] || mailbox.stats[6] ||
  mailbox.stats[7] || mailbox.stats[8] || (mailbox.stats[13]&2u)))return -21;
 if(camera && has_sensor_metadata(mailbox.stats[0])){
  if(mailbox.sensor_frame_sofs!=mailbox.stats[1])return -37;
  if(mailbox.sensor_frame_counter_mode==2u){
   // The sensor's documented inactive counter sends zero in every FS/FE.
   // Preserve the raw repeated-ID statistic; continuity is established by
   // genuine input SOFs, matching guard counts, and every logged timestamp.
   if(mailbox.sensor_frame_last || mailbox.sensor_frame_changes ||
      mailbox.sensor_frame_gaps+1u!=mailbox.sensor_frame_sofs ||
      (mailbox.sensor_frame_counter_ctrl_readback&7u)!=1u)return -37;
  } else if(mailbox.sensor_frame_gaps || mailbox.sensor_frame_changes+1u!=mailbox.sensor_frame_sofs)return -37;
 }
 return 0;
}
void main(void){
 // AMD FSBL has already flushed/disabled caches. Cold JTAG resets the A9.
 // Establish CPU0 interrupt/timer state before UART1 enables IRQs.
 wr(0xf8f02100u,0);
 wr(0xf8f00100u,0);wr(0xf8f01000u,0);
 for(unsigned i=0;i<3;i++){
  wr(0xf8f01180u+4*i,0xffffffffu);
  wr(0xf8f01280u+4*i,0xffffffffu);
 }
 wr(0xf8f00600u,0);wr(0xf8f00608u,0);wr(0xf8f0060cu,1);
 wr(0xf8f00208u,0);wr(0xf8f00200u,0);wr(0xf8f00204u,0);
 wr(0xf8f0020cu,1);wr(0xf8f00208u,1);
 __asm__ volatile("dsb sy\n isb":::"memory");
 volatile uint32_t *m=(volatile uint32_t *)&mailbox;
 for(unsigned i=0;i<sizeof(mailbox)/4;i++)m[i]=0;
 mailbox.magic=0x9281ca01u;mailbox.duration_ms=60000;mailbox.status=1;mailbox.phy_hs_settle=147;mailbox.sensor_lp_drive=3;set_control(0);
 mailbox.sensor_hs_vcm=2;mailbox.sensor_hs_drive=7;
 mailbox.sensor_iref_code=2;
 mailbox.sensor_exposure_lines=320;mailbox.sensor_gain_raw=0x10;
#ifdef MOTION60_FIRMWARE
 motion60_init();
#endif
 for(;;){
#ifdef MOTION60_FIRMWARE
  motion60_idle();
#endif
  uint32_t cmd=mailbox.command;if(!cmd)continue;
  mailbox.command=0;mailbox.status=2;mailbox.error=0;
  mailbox.capture_source_command=0;
  int e=0;
  if(cmd==1)e=run_capture(0,1);
  else if(cmd==2)e=run_capture(0,0);
  else if(cmd==3){
   if(mailbox.electrical_ok!=0x9281u)e=-10;
   else {uint8_t a=0;uint16_t id=0;set_control(0);delay_us(10000);e=probe_sensor(&a,&id);mailbox.sensor_address=a;mailbox.sensor_id=id;set_control(0);}
  } else if(cmd==4)e=run_capture(1,0);
  else if(cmd==7)e=run_capture(2,0);
  else if(cmd==5){
   // Configure/read back with streaming OFF; usable before the MIPI PHY is loaded.
   if(mailbox.electrical_ok!=0x9281u)e=-10;
   else {
    uint8_t a=0;uint16_t id=0;set_control(0);delay_us(10000);
    e=probe_sensor(&a,&id);mailbox.sensor_address=a;mailbox.sensor_id=id;
    if(!e)e=sensor_configure(a,mailbox.test_pattern!=0);
    const uint16_t regs[]={0x300a,0x300b,0x0100,0x0302,0x030d,0x030e,0x3662,
      0x3808,0x3809,0x380a,0x380b,0x380c,0x380d,0x380e,0x380f,
      0x3500,0x3501,0x3502,0x3508,0x3509,0x4800,0x4837,0x5e00};
    mailbox.sample_count=0;
    for(unsigned i=0;!e && i<sizeof(regs)/sizeof(regs[0]);i++){
     uint8_t v;e=sensor_read(a,regs[i],&v);
     if(!e){wr(LOG_BASE+i*4u,((uint32_t)regs[i]<<8)|v);mailbox.sample_count=i+1;}
    }
   }
  }
  else if(cmd==6){
   if(mailbox.electrical_ok!=0x9281u)e=-10;
   else {uint8_t a=0;uint16_t id=0;uint32_t n=0;
    e=sensor_gpio_probe(&a,&id,&n);mailbox.sensor_address=a;mailbox.sensor_id=id;mailbox.sample_count=n;}
  }
  else e=-19;
  if(e){
   if((cmd==3 || cmd==4 || cmd==5 || cmd==7) && mailbox.electrical_ok==0x9281u && mailbox.sensor_id==0x9281u)
    (void)sensor_write((uint8_t)mailbox.sensor_address,0x0100,0);
   set_control(0);
   snapshot();
   if((cmd==4 || cmd==7) && (mailbox.stats[0]==0x92810002u || is_full_core(mailbox.stats[0])))phy_log(3);
   (void)vdma_reset();
  }
  mailbox.error=(uint32_t)e;mailbox.status=e?4u:3u;
#ifdef MOTION60_HMI
  motion60_hmi_completed(e);
#endif
 }
}
