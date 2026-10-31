// SPDX-License-Identifier: GPL-2.0
// Register sequence adapted from Rockchip OV9281 driver.
// Copyright (C) 2017 Fuzhou Rockchip Electronics Co., Ltd.
// Renheng module ID/standby register readback verified; MIPI rate still needs capture.
#include "capture.h"
#ifdef MOTION60_CAMERA_CONTROLS
#include "motion60_camera.h"
#endif
typedef struct {uint16_t reg;uint8_t value;} regval;
static const regval profile[] = {
 {0x0302,0x32},
 {0x030d,0x50},
 {0x030e,0x02},
 {0x3001,0x00},
 {0x3004,0x00},
 {0x3005,0x00},
 {0x3006,0x04},
 {0x3011,0x0a},
 {0x3013,0x38}, // LP drive code3: verified LP01 ~60ns on this board's passive RX.
 {0x3022,0x01},
 {0x3023,0x00},
 {0x302c,0x00},
 {0x302f,0x00},
 {0x3030,0x04},
 {0x3039,0x32},
 {0x303a,0x00},
 {0x303f,0x01},
 {0x3500,0x00},
 {0x3501,0x2a},
 {0x3502,0x90},
 {0x3503,0x08},
 {0x3505,0x8c},
 {0x3507,0x03},
 {0x3508,0x00},
 {0x3509,0x10},
 {0x3610,0x80},
 {0x3611,0xa0},
 {0x3620,0x6f},
 {0x3632,0x56},
 {0x3633,0x78},
 {0x3662,0x05},
 {0x3666,0x00},
 {0x366f,0x5a},
 {0x3680,0x84},
 {0x3712,0x80},
 {0x372d,0x22},
 {0x3731,0x80},
 {0x3732,0x30},
 {0x3778,0x00},
 {0x377d,0x22},
 {0x3788,0x02},
 {0x3789,0xa4},
 {0x378a,0x00},
 {0x378b,0x4a},
 {0x3799,0x20},
 {0x3800,0x00},
 {0x3801,0x00},
 {0x3802,0x00},
 {0x3803,0x00},
 {0x3804,0x05},
 {0x3805,0x0f},
 {0x3806,0x03},
 {0x3807,0x2f},
 {0x3808,0x05},
 {0x3809,0x00},
 {0x380a,0x03},
 {0x380b,0x20},
 {0x380c,0x02},
 {0x380d,0xd8},
 {0x380e,0x03},
 {0x380f,0x8e},
 {0x3810,0x00},
 {0x3811,0x08},
 {0x3812,0x00},
 {0x3813,0x08},
 {0x3814,0x11},
 {0x3815,0x11},
 {0x3820,0x40},
 {0x3821,0x00},
 {0x3881,0x42},
 {0x38b1,0x00},
 {0x3920,0xff},
 {0x4003,0x40},
 {0x4008,0x04},
 {0x4009,0x0b},
 {0x400c,0x00},
 {0x400d,0x07},
 {0x4010,0x40},
 {0x4043,0x40},
 {0x4307,0x30},
 {0x4317,0x00},
 {0x4501,0x00},
 {0x4507,0x00},
 {0x4509,0x00},
 {0x450a,0x08},
 {0x4601,0x04},
 {0x470f,0x00},
 {0x4f07,0x00},
 {0x4800,0x00},
 {0x5000,0x9f},
 {0x5001,0x00},
 {0x5e00,0x00},
 {0x5d00,0x07},
 {0x5d01,0x00},
};
static int cfg_write(uint8_t addr,uint16_t reg,uint8_t value,uint32_t stage){
 if(!sensor_write(addr,reg,value))return 0;
 mailbox.sensor_cfg_failed_reg=reg;mailbox.sensor_cfg_expected=value;mailbox.sensor_cfg_stage=stage;
 return -1;
}
int sensor_configure(uint8_t addr,int pattern){
#ifdef MOTION60_CAMERA_CONTROLS
 CAMERA_CONTROL->applied_revision=0;
#endif
 mailbox.sensor_cfg_failed_reg=0;mailbox.sensor_cfg_readback=0;mailbox.sensor_cfg_expected=0;mailbox.sensor_cfg_stage=0;
 mailbox.sensor_exposure_readback=0;mailbox.sensor_gain_readback=0;
 mailbox.sensor_pll1_readback=0;mailbox.sensor_vts_readback=0;
 mailbox.sensor_pll1_reference_readback=0;mailbox.sensor_pll2_reference_readback=0;mailbox.sensor_pll2_div_readback=0;
 if(cfg_write(addr,0x0100,0,1) || cfg_write(addr,0x0103,1,2))return -1;
 delay_us(2000);
 for(unsigned i=0;i<sizeof(profile)/sizeof(profile[0]);i++)
  if(cfg_write(addr,profile[i].reg,profile[i].value,3))return -1;
 if(mailbox.sensor_half_rate_diagnostic>5u || mailbox.sensor_fullrate640>8u ||
    (mailbox.sensor_fullrate640 && mailbox.sensor_half_rate_diagnostic!=0u && mailbox.sensor_half_rate_diagnostic!=3u && mailbox.sensor_half_rate_diagnostic!=4u && mailbox.sensor_half_rate_diagnostic!=5u) ||
    (mailbox.sensor_half_rate_diagnostic==3u && mailbox.sensor_fullrate640!=1u && mailbox.sensor_fullrate640!=2u) ||
    ((mailbox.sensor_half_rate_diagnostic==4u || mailbox.sensor_half_rate_diagnostic==5u) && mailbox.sensor_fullrate640!=5u && mailbox.sensor_fullrate640!=7u) ||
    ((mailbox.sensor_fullrate640==3u || mailbox.sensor_fullrate640==4u || mailbox.sensor_fullrate640==6u || mailbox.sensor_fullrate640==8u) && mailbox.sensor_half_rate_diagnostic))return -1;
 // Keep the PLL VCO at nominal 800MHz: halving the multiplier would violate
 // the documented 500MHz minimum. M_div /2 halves only the MIPI branch.
 // Double HTS so each active line has enough time to serialize at 400Mbps;
 // increasing VTS alone would not relieve the active-line FIFO pressure.
 uint8_t m_div=mailbox.sensor_half_rate_diagnostic==1u?1u:0u;
 uint16_t hts=(mailbox.sensor_fullrate640==6u || mailbox.sensor_fullrate640==8u || mailbox.sensor_half_rate_diagnostic==5u)?800u:(mailbox.sensor_half_rate_diagnostic?1456u:728u);
 uint8_t multiplier=(mailbox.sensor_fullrate640==7u || mailbox.sensor_fullrate640==8u)?43u:(mailbox.sensor_fullrate640==5u || mailbox.sensor_fullrate640==6u)?44u:mailbox.sensor_fullrate640==4u?60u:(mailbox.sensor_fullrate640==3u?47u:(mailbox.sensor_fullrate640?40u:50u));
 uint8_t sys_pre_div=mailbox.sensor_fullrate640==1u?1u:2u;
 uint16_t vts=(mailbox.sensor_fullrate640==6u || mailbox.sensor_fullrate640==8u)?828u:(mailbox.sensor_fullrate640==1u || mailbox.sensor_fullrate640==2u)?917u:910u;
 // Variant1: PLL1 system branch640 /4 /2=80; variant2 retains its original
 // /5 /2 divider (64MHz branch). Do not infer imaging cadence from one branch.
 // Keep PLL2 unchanged; actual full-rate delivery is required independently.
 // Preserve supported horizontal/vertical blanking. VTS917 aims near120fps;
 // actual serializer/FIFO throughput must be measured, not inferred.
 if(cfg_write(addr,0x0302,multiplier,3)||cfg_write(addr,0x0305,sys_pre_div,3)||
    cfg_write(addr,0x0306,1,3)||cfg_write(addr,0x0304,3,3)||
    cfg_write(addr,0x380e,(uint8_t)(vts>>8),3)||cfg_write(addr,0x380f,(uint8_t)vts,3))return -1;
 if(cfg_write(addr,0x0303,m_div,3)||cfg_write(addr,0x380c,(uint8_t)(hts>>8),3)||
    cfg_write(addr,0x380d,(uint8_t)hts,3))return -1;
 // PG232 ISR[27] reports pending FIFO writes when the forwarded clock ends
 // too soon. Preserve automatic timing and raise only its documented ns
 // minimum; retain/read the additional UI term rather than inventing duration.
 uint32_t post=mailbox.sensor_clk_post_min_ns;
 if(post!=0u && post!=500u)return -1;
 if(post && (cfg_write(addr,0x4820,(uint8_t)(post>>8),3)||
             cfg_write(addr,0x4821,(uint8_t)post,3)))return -1;
 uint8_t post_hi=0,post_lo=0,post_ui=0;
 if(sensor_read(addr,0x4820,&post_hi)||sensor_read(addr,0x4821,&post_lo)||
    sensor_read(addr,0x482e,&post_ui))return -1;
 mailbox.sensor_clk_post_min_readback=((uint32_t)(post_hi&3u)<<8)|post_lo;
 mailbox.sensor_clk_post_ui_readback=post_ui;
 if(post && mailbox.sensor_clk_post_min_readback!=post)return -1;
 // Independent clock-pad output skew in3014[7:6], distinct from3012 ck_skew.
 // Change only those two bits in standby; preserve PHY enable/power/reset bits.
 if(mailbox.sensor_clock_out_skew>3u)return -1;
 uint8_t clock_out=0,clock_out_rb=0;
 if(sensor_read(addr,0x3014,&clock_out))return -1;
 clock_out=(uint8_t)((clock_out&0x3fu)|(mailbox.sensor_clock_out_skew<<6));
 if(cfg_write(addr,0x3014,clock_out,3)||sensor_read(addr,0x3014,&clock_out_rb))return -1;
 mailbox.sensor_clock_out_skew_readback=clock_out_rb;
 if(clock_out_rb!=clock_out)return -1;
 // Keep exposure within VTS(910)-12, without extending the frame period.
 uint32_t lines=mailbox.sensor_exposure_lines,gain=mailbox.sensor_gain_raw;
 if(lines<1u || lines>(uint32_t)(vts-12u) || gain<0x10u || gain>0xf8u)return -1;
 uint8_t exp_hi=(uint8_t)(lines>>4),exp_lo=(uint8_t)(lines<<4);
 // Complete the current sensor frame before entering standby. Default fast
 // standby can truncate MIPI traffic and contaminate post-stop error status.
 if(cfg_write(addr,0x0106,0,4)||cfg_write(addr,0x3500,0,4)||cfg_write(addr,0x3501,exp_hi,4)||cfg_write(addr,0x3502,exp_lo,4)||
    cfg_write(addr,0x3508,0,4)||cfg_write(addr,0x3509,(uint8_t)gain,4)||cfg_write(addr,0x5e00,pattern?0x80:0,4))return -1;
 const regval checks[]={ {0x0300,1},{0x0301,0},{0x030a,0},
 {0x0302,multiplier},{0x0303,m_div},{0x0304,3},{0x0305,sys_pre_div},{0x0306,1},
 {0x030b,4},{0x030c,0},{0x030d,0x50},{0x0314,0},
 {0x0312,7},{0x0313,1},{0x030e,2},{0x030f,3},{0x3662,5},
 {0x3808,5},{0x3809,0},{0x380a,3},{0x380b,0x20},{0x380c,(uint8_t)(hts>>8)},{0x380d,(uint8_t)hts},
 {0x380e,(uint8_t)(vts>>8)},{0x380f,(uint8_t)vts},{0x3500,0},{0x3501,exp_hi},{0x3502,exp_lo},
 {0x3508,0},{0x3509,(uint8_t)gain},{0x0100,0},{0x0106,0} };
 for(unsigned i=0;i<sizeof(checks)/sizeof(checks[0]);i++){
  uint8_t v=0;int e=sensor_read(addr,checks[i].reg,&v);
  if(e || v!=checks[i].value){
   mailbox.sensor_cfg_failed_reg=checks[i].reg;mailbox.sensor_cfg_readback=v;
   mailbox.sensor_cfg_expected=checks[i].value;mailbox.sensor_cfg_stage=e?5u:6u;return -1;
  }
  if(checks[i].reg==0x3501)mailbox.sensor_exposure_readback=(uint32_t)v<<4;
  if(checks[i].reg==0x3502)mailbox.sensor_exposure_readback|=(uint32_t)v>>4;
  if(checks[i].reg==0x3509)mailbox.sensor_gain_readback=v;
  if(checks[i].reg==0x0303)mailbox.sensor_m_div_readback=v;
  if(checks[i].reg==0x380c)mailbox.sensor_hts_readback=(uint32_t)v<<8;
  if(checks[i].reg==0x380d)mailbox.sensor_hts_readback|=v;
  switch(checks[i].reg){
   case 0x0302:mailbox.sensor_pll1_readback|=v;break;
   case 0x0305:mailbox.sensor_pll1_readback|=(uint32_t)v<<8;break;
   case 0x0306:mailbox.sensor_pll1_readback|=(uint32_t)v<<16;break;
   case 0x0304:mailbox.sensor_pll1_readback|=(uint32_t)v<<24;break;
   case 0x380e:mailbox.sensor_vts_readback=(uint32_t)v<<8;break;
   case 0x380f:mailbox.sensor_vts_readback|=v;break;
   case 0x0300:mailbox.sensor_pll1_reference_readback|=v;break;
   case 0x0301:mailbox.sensor_pll1_reference_readback|=(uint32_t)v<<8;break;
   case 0x030a:mailbox.sensor_pll1_reference_readback|=(uint32_t)v<<16;break;
   case 0x030b:mailbox.sensor_pll2_reference_readback|=v;break;
   case 0x030c:mailbox.sensor_pll2_reference_readback|=(uint32_t)v<<8;break;
   case 0x030d:mailbox.sensor_pll2_reference_readback|=(uint32_t)v<<16;break;
   case 0x0314:mailbox.sensor_pll2_reference_readback|=(uint32_t)v<<24;break;
   case 0x0312:mailbox.sensor_pll2_div_readback|=v;break;
   case 0x0313:mailbox.sensor_pll2_div_readback|=(uint32_t)v<<8;break;
   case 0x030e:mailbox.sensor_pll2_div_readback|=(uint32_t)v<<16;break;
   case 0x030f:mailbox.sensor_pll2_div_readback|=(uint32_t)v<<24;break;
  }
 }
#ifdef MOTION60_CAMERA_CONTROLS
 // OV9281 timing format bit 2: preserve the other sensor timing bits.
 if(CAMERA_CONTROL->mirror>1||CAMERA_CONTROL->flip>1)return -1;
 const uint16_t orientation_regs[2]={0x3821,0x3820};
 const uint32_t orientation_values[2]={CAMERA_CONTROL->mirror,CAMERA_CONTROL->flip};
 for(unsigned i=0;i<2;i++){
  uint8_t value=0,actual=0;
  if(sensor_read(addr,orientation_regs[i],&value))return -1;
  value=(uint8_t)((value&~4u)|(orientation_values[i]<<2));
  if(cfg_write(addr,orientation_regs[i],value,4)||sensor_read(addr,orientation_regs[i],&actual)||actual!=value)return -1;
  if(i==0)CAMERA_CONTROL->mirror_readback=(actual>>2)&1;
  else CAMERA_CONTROL->flip_readback=(actual>>2)&1;
 }
 uint8_t pattern_actual=0;
 if(sensor_read(addr,0x5e00,&pattern_actual)||pattern_actual!=(pattern?0x80:0))return -1;
 CAMERA_CONTROL->pattern_readback=pattern_actual?1:0;
 CAMERA_CONTROL->exposure_readback=mailbox.sensor_exposure_readback;
 CAMERA_CONTROL->gain_readback=mailbox.sensor_gain_readback;
 CAMERA_CONTROL->applied_revision=CAMERA_CONTROL->revision;
#endif
 return 0;
}
