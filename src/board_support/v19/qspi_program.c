/* Bounded recovery writer using AMD XQspiPs, after an interrupted host tool.
 * Image is uploaded to DDR and verified BEFORE arming. No erase command exists.
 * Preflight proves every destination bit can be programmed without an erase.
 * Already identical pages are skipped; every written page is read back.
 */
#include "xqspips.h"
#include "xparameters.h"
#include <stdint.h>
#ifndef IMAGE_BYTES
#error Build with the sealed image length and CRC32
#endif
static XQspiPs q;
static uint8_t tx[4100],rx[4100];
static uint32_t crc_table[256];
static volatile uint32_t *const d=(volatile uint32_t*)0x00ff0000;
static const uint8_t *const image=(const uint8_t*)0x10000000;
static uint32_t rd(uint32_t a){return *(volatile uint32_t*)a;}
static void wr(uint32_t a,uint32_t v){*(volatile uint32_t*)a=v;}
static uint64_t ticks(void){uint32_t h,l,h2;do{h=rd(0xf8f00204);l=rd(0xf8f00200);h2=rd(0xf8f00204);}while(h!=h2);return ((uint64_t)h<<32)|l;}
static int transfer(unsigned n){return XQspiPs_PolledTransfer(&q,tx,rx,n);}
/* qspips_v3_9 substitutes dummy bytes when RecvBufferPtr is non-NULL.
 * Programs must use a send-only transfer to transmit the entire payload. */
static int send(unsigned n){return XQspiPs_PolledTransfer(&q,tx,0,n);}
static void address(uint8_t op,uint32_t a){tx[0]=op;tx[1]=a>>16;tx[2]=a>>8;tx[3]=a;}
static uint32_t crc(uint32_t c,const uint8_t*p,unsigned n){while(n--)c=crc_table[(c^*p++)&255]^(c>>8);return c;}
static int status(uint8_t *s){tx[0]=5;if(transfer(2))return -1;*s=rx[1];return 0;}
static int ready(void){uint64_t end=ticks()+400000000u;uint8_t s;do{if(status(&s))return -1;if(!(s&1))return 0;}while(ticks()<end);return -1;}
static int flash_crc(uint32_t start,uint32_t length,uint32_t *value){
 uint32_t c=~0u;
 for(uint32_t a=start;a<start+length;){unsigned n=start+length-a;if(n>4096)n=4096;
  address(3,a);if(transfer(n+4))return -1;c=crc(c,rx+4,n);a+=n;
 }
 *value=c^~0u;return 0;
}
int main(void){
 for(unsigned i=0;i<64;i++)d[i]=0;
 d[0]=0x51575031;d[1]=1;wr(0xf8f00208,1);
 for(unsigned i=0;i<256;i++){uint32_t c=i;for(unsigned k=0;k<8;k++)c=(c>>1)^((c&1)?0xedb88320u:0);crc_table[i]=c;}
 d[2]=crc(~0u,image,IMAGE_BYTES)^~0u;
 if(d[2]!=IMAGE_CRC){d[1]=0xe001;goto done;}
 XQspiPs_Config*c=XQspiPs_LookupConfig(XPAR_XQSPIPS_0_DEVICE_ID);
 if(!c||c->ConnectionMode!=XQSPIPS_CONNECTION_MODE_SINGLE||XQspiPs_CfgInitialize(&q,c,c->BaseAddress)){d[1]=0xe002;goto done;}
 XQspiPs_SetOptions(&q,XQSPIPS_FORCE_SSELECT_OPTION|XQSPIPS_MANUAL_START_OPTION);
 XQspiPs_SetClkPrescaler(&q,XQSPIPS_CLK_PRESCALE_8);XQspiPs_SetSlaveSelect(&q);
 tx[0]=0x9f;if(transfer(4)){d[1]=0xe003;goto done;}
 d[3]=((uint32_t)rx[1]<<16)|((uint32_t)rx[2]<<8)|rx[3];
 if(d[3]!=0xef4018){d[1]=0xe004;goto done;}
 uint8_t s;if(status(&s)||s&3){d[1]=0xe005;goto done;}d[4]=s;
 uint32_t tail;if(flash_crc(0xcb0000,0x350000,&tail)){d[1]=0xe006;goto done;}d[8]=tail;
 if(tail!=TAIL_CRC){d[1]=0xe007;goto done;}
 d[1]=2;
 for(uint32_t a=0;a<IMAGE_BYTES;){unsigned n=IMAGE_BYTES-a;if(n>4096)n=4096;
  address(3,a);if(transfer(n+4)){d[1]=0xe008;goto done;}
  for(unsigned i=0;i<n;i++)if((rx[4+i]&image[a+i])!=image[a+i]){d[6]++;d[7]=a+i;}
  a+=n;d[5]=a;
 }
 if(d[6]){d[1]=0xe009;goto done;}
 d[1]=3;__asm__ volatile("dsb sy":::"memory");
 while(d[10]!=0x41524d31u){} /* Explicit host arm after verifying READY. */
 d[1]=4;d[5]=0;
 for(uint32_t a=0;a<IMAGE_BYTES;a+=256){
  unsigned n=IMAGE_BYTES-a;if(n>256)n=256;address(3,a);
  if(transfer(n+4)){d[1]=0xe00a;goto done;}
  unsigned same=1;for(unsigned i=0;i<n;i++)if(rx[4+i]!=image[a+i])same=0;
  if(same)d[12]++;
  else {
   tx[0]=6;if(send(1)||status(&s)||!(s&2)){d[1]=0xe00b;goto done;}
   address(2,a);for(unsigned i=0;i<n;i++)tx[4+i]=image[a+i];
   if(send(n+4)||ready()){d[1]=0xe00c;goto done;}
   address(3,a);if(transfer(n+4)){d[1]=0xe00d;goto done;}
   for(unsigned i=0;i<n;i++)if(rx[4+i]!=image[a+i]){d[1]=0xe00e;d[7]=a+i;goto done;}
   d[11]++;
  }
  d[5]=a+n;
 }
 d[1]=5;
 uint32_t final;if(flash_crc(0,IMAGE_BYTES,&final)){d[1]=0xe00f;goto done;}d[9]=final;
 if(final!=IMAGE_CRC){d[1]=0xe010;goto done;}
 if(flash_crc(0xcb0000,0x350000,&tail)){d[1]=0xe011;goto done;}d[13]=tail;
 if(tail!=TAIL_CRC){d[1]=0xe012;goto done;}
 tx[0]=4;if(send(1)||status(&s)||s&3){d[1]=0xe013;goto done;}
 d[14]=s;d[1]=6;
done:
 __asm__ volatile("dsb sy":::"memory");for(;;)__asm__ volatile("wfe");
}
