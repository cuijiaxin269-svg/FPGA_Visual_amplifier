#include "capture.h"
static int gpio_transport;
static int bb_read(unsigned addr,unsigned reg,uint8_t *value);
static int bb_write(unsigned addr,unsigned reg,uint8_t value);
void *memcpy(void *dest,const void *src,size_t n){
 unsigned char *d=dest;const unsigned char *s=src;
 for(size_t i=0;i<n;i++){d[i]=s[i];}
 return dest;
}
// Zynq global timer: CPU/2 = 400MHz for inherited 800MHz APU configuration.
uint64_t timer_ticks(void){
 uint32_t hi,lo,again;
 do {hi=rd(0xf8f00204u);lo=rd(0xf8f00200u);again=rd(0xf8f00204u);} while(hi!=again);
 return ((uint64_t)hi<<32)|lo;
}
void delay_us(uint32_t us){uint64_t end=timer_ticks()+(uint64_t)us*400u;while(timer_ticks()<end){} }
// Cadence PS I2C: one/two-byte receive, max three-byte transmit; bounded timeout.
// Reference register definitions: AMD embeddedsw iicps_v3_22 xiicps_hw.h.
static uint32_t i2c_clock(void){
 // Zynq-7000 I2C uses CPU_1x; 0xf800012c is APER_CLK_CTRL, not a divisor.
 // CPU_1x = ARM PLL output / ARM divisor / 6 (6:2:1) or / 4 (4:2:1).
 uint32_t ctl=rd(0xf8000120u), source=(ctl>>4)&3u;
 uint32_t pll=rd(source==2u?0xf8000104u:source==3u?0xf8000108u:0xf8000100u);
 uint32_t mult=(pll>>12)&127u;
 uint32_t divisor=(ctl>>8)&63u;
 uint32_t ratio=(rd(0xf80001c4u)&1u)?6u:4u;
 uint64_t pll_hz=(pll&(1u<<4))?33333333u:(uint64_t)33333333u*mult;
 return divisor?(uint32_t)(pll_hz/(divisor*ratio)):0u;
}
static uint32_t i2c_control;
static int i2c_prepare(void){
 uint32_t freq=i2c_clock(),diva,divb;
 if(!freq)return -1;
 for(diva=0;diva<4;diva++) for(divb=0;divb<64;divb++)
  if(freq/(22u*(diva+1u)*(divb+1u))<=100000u){
   i2c_control=(diva<<14)|(divb<<8)|0x0eu;
   wr(I2C_BASE+0x28,0x2ff);wr(I2C_BASE,i2c_control|0x40);wr(I2C_BASE+0x10,0x2ff);
   return 0;
  }
 return -1;
}
static int i2c_wait(void){
 uint64_t end=timer_ticks()+4000000u;
 while(timer_ticks()<end){uint32_t s=rd(I2C_BASE+0x10);
  if(s&0x2ecu){wr(I2C_BASE,i2c_control|0x40);wr(I2C_BASE+0x10,0x2ff);return -1;}
  if(s&1u){wr(I2C_BASE+0x10,0x2ff);return 0;}}
 wr(I2C_BASE,i2c_control|0x40);wr(I2C_BASE+0x10,0x2ff);return -2;
}
static int tx(uint8_t addr,const uint8_t *b,unsigned n){
 uint64_t end=timer_ticks()+4000000u;
 while(rd(I2C_BASE+4)&0x100u)if(timer_ticks()>end)return -1;
 wr(I2C_BASE,i2c_control|0x40);wr(I2C_BASE+0x10,0x2ff);
 for(unsigned i=0;i<n;i++)wr(I2C_BASE+0x0c,b[i]);
 wr(I2C_BASE+8,addr);return i2c_wait();
}
int sensor_write(uint8_t addr,uint16_t reg,uint8_t v){
 if(gpio_transport)return bb_write(addr,reg,v);
 uint8_t b[3]={(uint8_t)(reg>>8),(uint8_t)reg,v};return tx(addr,b,3);
}
int sensor_read(uint8_t addr,uint16_t reg,uint8_t *v){
 if(gpio_transport)return bb_read(addr,reg,v);
 uint8_t b[2]={(uint8_t)(reg>>8),(uint8_t)reg};if(tx(addr,b,2))return -1;
 wr(I2C_BASE,i2c_control|0x41);wr(I2C_BASE+0x10,0x2ff);
 wr(I2C_BASE+0x14,1);wr(I2C_BASE+8,addr);
 if(i2c_wait())return -1;
 if(!(rd(I2C_BASE+4)&0x20u))return -1;
 *v=(uint8_t)rd(I2C_BASE+0x0c);return 0;
}
int sensor_probe(uint8_t *addr,uint16_t *id){
 if(!gpio_transport && i2c_prepare())return -1;
 // Datasheet SID: 8-bit 0xc0/0x20 -> 7-bit 0x60/0x10. No blind address scan.
 const uint8_t candidates[]={0x60,0x10};
 for(unsigned i=0;i<2;i++){uint8_t hi,lo;
  if(!sensor_read(candidates[i],0x300a,&hi)&&!sensor_read(candidates[i],0x300b,&lo)){
   *id=((uint16_t)hi<<8)|lo;*addr=candidates[i];if(*id==0x9281)return 0;}}
 return -1;
}

// SCCB bridge diagnostic: PS EMIO GPIO bank2 bits SDA/SCL/select; always open-drain.
#define GPIO_DATA2 0xe000a048u
#define GPIO_INPUT2 0xe000a068u
#define GPIO_DIR2 0xe000a284u
#define GPIO_OEN2 0xe000a288u
static unsigned bb_samples;
static int bb_tracing;
static void bb_trace(unsigned code,unsigned value){
 if(!bb_tracing)return;
 wr(0x01000000u+4u*bb_samples,((code&0xffffu)<<16)|(value&0xffffu));bb_samples++;
}
static void bb_drive(unsigned low){wr(GPIO_OEN2,4u|(low&3u));delay_us(10);}
static unsigned bb_level(void){return rd(GPIO_INPUT2)&3u;}
static int bb_high(unsigned sda_low){
 bb_drive(sda_low);
 uint64_t end=timer_ticks()+400000u;
 while(!(bb_level()&2u))if(timer_ticks()>end)return -1;
 return 0;
}
static void bb_stop(void){bb_drive(3);(void)bb_high(1);bb_drive(0);}
static int bb_start(void){
 if(bb_high(0))return -1;
 if(bb_level()!=3u)return -1;
 bb_drive(1);bb_drive(3);return 0;
}
static int bb_tx(unsigned byte){
 for(unsigned mask=128;mask;mask>>=1){unsigned low=(byte&mask)?0u:1u;
  bb_drive(low|2u);if(bb_high(low))return -2;bb_drive(low|2u);
 }
 bb_drive(2);if(bb_high(0))return -2;
 int nack=(int)(bb_level()&1u);bb_drive(2);return nack;
}
static int bb_rx(uint8_t *value){
 unsigned v=0;bb_drive(2);
 for(unsigned i=0;i<8;i++){
  if(bb_high(0))return -1;
  v=(v<<1)|(bb_level()&1u);bb_drive(2);
 }
 if(bb_high(0))return -1;
 bb_drive(2);*value=(uint8_t)v;return 0; // final NACK
}
static int bb_write(unsigned addr,unsigned reg,uint8_t value){
 int e=bb_start();
 if(!e)e=bb_tx(addr<<1);
 if(!e)e=bb_tx(reg>>8);
 if(!e)e=bb_tx(reg&255u);
 if(!e)e=bb_tx(value);
 bb_stop();return e?-1:0;
}
int sensor_select_gpio(int enable){
 gpio_transport=enable!=0;bb_tracing=0;
 if(enable){
  wr(I2C_BASE,0x40);wr(GPIO_DIR2,7);wr(GPIO_OEN2,4);wr(GPIO_DATA2,4);bb_drive(0);
  return bb_level()==3u?0:-1;
 }
 wr(GPIO_DATA2,0);wr(GPIO_OEN2,0);wr(GPIO_DIR2,0);
 return i2c_prepare();
}
static int bb_read(unsigned addr,unsigned reg,uint8_t *value){
 int e=bb_start();if(e)return e;
 e=bb_tx(addr<<1);bb_trace(0x1000u|addr,(unsigned)e);
 if(!e){e=bb_tx(reg>>8);bb_trace(0x2000u|addr,(unsigned)e);}
 if(!e){e=bb_tx(reg&255u);bb_trace(0x3000u|addr,(unsigned)e);}
 bb_stop();if(e)return -1;
 if(bb_start())return -1;
 e=bb_tx((addr<<1)|1u);bb_trace(0x4000u|addr,(unsigned)e);
 if(!e)e=bb_rx(value);
 bb_stop();if(!e)bb_trace(reg,*value);return e?-1:0;
}
int sensor_bus_recover(void){
 gpio_transport=0;bb_tracing=0;
 // Only call on the three-GPIO SCCB bridge. PL/RAM reload can leave a transfer
 // incomplete. Recover with open-drain clocks/STOP; never drive a logic high.
 wr(GPIO_DIR2,7);wr(GPIO_OEN2,4);wr(GPIO_DATA2,4);wr(I2C_BASE,0x40);
 int e=0;
 for(unsigned i=0;i<9;i++){
  wr(GPIO_OEN2,6);delay_us(100);wr(GPIO_OEN2,4);
  uint64_t end=timer_ticks()+4000000u;
  while(!(bb_level()&2u))if(timer_ticks()>end){e=-1;break;}
  delay_us(100);if(e)break;
 }
 wr(GPIO_OEN2,7);delay_us(100);wr(GPIO_OEN2,5);delay_us(10000);
 wr(GPIO_OEN2,4);delay_us(10000);
 if(bb_level()!=3u)e=-1;
 wr(GPIO_DATA2,0);wr(GPIO_OEN2,0);wr(GPIO_DIR2,0);
 (void)i2c_prepare();return e;
}
int sensor_gpio_probe(uint8_t *addr,uint16_t *id,uint32_t *samples){
 bb_samples=0;bb_tracing=1;gpio_transport=0;wr(I2C_BASE,0x40); // release Cadence master during GPIO ownership
 wr(GPIO_DIR2,7);wr(GPIO_OEN2,4);wr(GPIO_DATA2,4);bb_drive(0);
 bb_trace(0x0200,rd(GPIO_DATA2));bb_trace(0x0201,rd(GPIO_DIR2));bb_trace(0x0202,rd(GPIO_OEN2));
 int e=0;
 const unsigned drive[]={0,1,3,2,0},expect[]={3,2,0,1,3};
 for(unsigned i=0;i<5;i++){
  bb_drive(drive[i]);unsigned v=bb_level();bb_trace(0x0100u+i,v);
  if(v!=expect[i])e=-20;
 }
 bb_stop();
 if(!e){
  e=-1;const uint8_t candidates[]={0x60,0x10};
  for(unsigned i=0;i<2;i++){uint8_t hi=0,lo=0;
   if(!bb_read(candidates[i],0x300a,&hi)&&!bb_read(candidates[i],0x300b,&lo)){
    *addr=candidates[i];*id=((uint16_t)hi<<8)|lo;if(*id==0x9281){e=0;break;}
   }
  }
 }
 bb_stop();wr(GPIO_DATA2,0);wr(GPIO_OEN2,0);wr(GPIO_DIR2,0);
 (void)i2c_prepare();*samples=bb_samples;bb_tracing=0;return e;
}
