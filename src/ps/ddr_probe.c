#include "capture.h"
volatile uint32_t probe[8] __attribute__((section(".mailbox")));
void main(void){
 wr(0xf8f02100u,0);
 volatile uint32_t *p=(volatile uint32_t *)(uintptr_t)FRAME0;
 uint32_t errors=0;
 probe[0]=0x9281dd01u;probe[1]=2;
 for(unsigned pass=0;pass<4;pass++){
  for(unsigned i=0;i<1024;i++)p[i]=(i*0x01010101u)^((pass&1)?0xffffffffu:0u);
  __asm__ volatile("dsb sy":::"memory");
  for(unsigned i=0;i<1024;i++)if(p[i]!=((i*0x01010101u)^((pass&1)?0xffffffffu:0u)))errors++;
 }
 probe[2]=errors;probe[3]=FRAME0;probe[4]=4096;probe[1]=errors?4u:3u;
 for(;;){}
}
