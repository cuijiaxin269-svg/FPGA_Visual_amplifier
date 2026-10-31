/* Diagnostic program: only READ ID, READ STATUS and READ DATA commands.
 * Never emits write-enable, program, erase, bank-write or flash reset.
 * PS/DDR must already be initialized; both acquisition and PL remain reset.
 */
#include "xqspips.h"
#include "xqspips_hw.h"
#include "xparameters.h"
static XQspiPs q;
static unsigned char tx[4096+4],rx[4096+4];
static volatile unsigned *const d=(volatile unsigned*)0x00ff0000;
static unsigned char *const backup=(unsigned char*)0x10000000;
static int transfer(unsigned n){return XQspiPs_PolledTransfer(&q,tx,rx,n);}
#ifdef VERIFY_ONLY
static unsigned table[256];
#endif
int main(void){
 for(unsigned i=0;i<64;i++)d[i]=0;
 d[0]=0x51524431;d[1]=1;
 XQspiPs_Config *c=XQspiPs_LookupConfig(XPAR_XQSPIPS_0_DEVICE_ID);
 if(!c||c->ConnectionMode!=XQSPIPS_CONNECTION_MODE_SINGLE){d[1]=0xe001;goto done;}
 if(XQspiPs_CfgInitialize(&q,c,c->BaseAddress)){d[1]=0xe002;goto done;}
 XQspiPs_SetOptions(&q,XQSPIPS_FORCE_SSELECT_OPTION|XQSPIPS_MANUAL_START_OPTION);
 XQspiPs_SetClkPrescaler(&q,XQSPIPS_CLK_PRESCALE_8);XQspiPs_SetSlaveSelect(&q);
 tx[0]=0x9f;if(transfer(4)){d[1]=0xe003;goto done;}
 d[2]=((unsigned)rx[1]<<16)|((unsigned)rx[2]<<8)|rx[3];
 tx[0]=0x05;if(transfer(2)){d[1]=0xe004;goto done;}d[3]=rx[1];
 tx[0]=0x35;if(transfer(2)){d[1]=0xe005;goto done;}d[4]=rx[1];
 if(d[2]!=0xef4018 && d[2]!=0xef4019){d[1]=0xe006;goto done;}
 if(d[3]&3){d[1]=0xe007;goto done;} /* refuse WIP or pre-existing WEL */
 d[1]=2;
#ifdef VERIFY_ONLY
 unsigned crc=0xffffffffu;
 for(unsigned i=0;i<256;i++){
  unsigned v=i;for(unsigned k=0;k<8;k++)v=(v>>1)^((v&1)?0xedb88320u:0);
  table[i]=v;
 }
 d[7]=0xffffffffu;
#endif
 for(unsigned a=0;a<0x01000000;a+=4096){
  tx[0]=0x03;tx[1]=a>>16;tx[2]=a>>8;tx[3]=a;
  if(transfer(sizeof(tx))){d[1]=0xe008;goto done;}
  for(unsigned i=0;i<4096;i++){
#ifdef VERIFY_ONLY
   unsigned char byte=rx[4+i];
   if(backup[a+i]!=byte){if(!d[6])d[7]=a+i;d[6]++;}
   crc=table[(crc^byte)&255]^(crc>>8);
#else
   backup[a+i]=rx[4+i];
#endif
  }
  __asm__ volatile("dmb sy":::"memory");d[5]=a+4096;
 }
#ifdef VERIFY_ONLY
 d[8]=crc^0xffffffffu;
 if(d[6]){d[1]=0xe009;goto done;}
#endif
 d[1]=3;
done:
 __asm__ volatile("dsb sy":::"memory");
 for(;;)__asm__ volatile("wfe");
}
