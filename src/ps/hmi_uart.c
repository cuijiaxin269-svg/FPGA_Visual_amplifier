#include "capture.h"
#include "hmi_uart.h"
#include "hmi_diagnostics.h"
volatile uint32_t hmi_diagnostics[64] __attribute__((section(".hmi_diag")));
volatile hmi_trace_record hmi_trace __attribute__((section(".hmi_trace")));
volatile hmi_probe_record hmi_probe __attribute__((section(".hmi_probe")));
#define U1 0xe0001000u
#define GICD 0xf8f01000u
#define GICC 0xf8f00100u
#define UART_IRQ 82u
#define RX_SIZE 4096u
#define TX_SIZE 2048u
/* UG585: RX trigger/full/errors. Trigger=1 handles short packets promptly;
   idle timeout is disabled to avoid repeated empty-FIFO interrupts. */
#define RX_INTERRUPTS 0xe5u
#ifdef HMI_UART_TEST
extern uint32_t hmi_test_read(uint32_t);
extern void hmi_test_write(uint32_t,uint32_t);
#define rd hmi_test_read
#define wr hmi_test_write
#endif
static uint8_t rx[RX_SIZE],txq[TX_SIZE];
static volatile uint32_t rx_r,rx_w,tx_r,tx_w,rx_fault;
volatile hmi_uart_stats hmi_uart_counters;
#ifdef HMI_UART_TEST
static uint32_t lock(void){return 0;}
static void unlock(uint32_t c){(void)c;}
static void barrier(void){}
static void enable_irq(void){}
#else
static uint32_t lock(void){uint32_t c;__asm__ volatile("mrs %0,cpsr\n cpsid i":"=r"(c)::"memory");return c;}
static void unlock(uint32_t c){if(!(c&0x80u))__asm__ volatile("cpsie i":::"memory");}
static void barrier(void){__asm__ volatile("dmb sy":::"memory");}
static void enable_irq(void){__asm__ volatile("cpsie i":::"memory");}
#endif
static void tx_fill(void){
 while(tx_r!=tx_w&&!(rd(U1+0x2c)&0x10u)){
  uint8_t byte=txq[tx_r];wr(U1+0x30,byte);
  hmi_trace.tx[hmi_trace.tx_total&(HMI_TRACE_SIZE-1u)]=byte;barrier();hmi_trace.tx_total++;
  tx_r=(tx_r+1u)&(TX_SIZE-1u);hmi_uart_counters.tx_bytes++;
 }
 if(tx_r==tx_w)wr(U1+0x0c,8);else wr(U1+8,8);
}
void hmi_uart_init(void){
 uint32_t saved=lock();rx_r=rx_w=tx_r=tx_w=rx_fault=0;
 hmi_trace.magic=0;hmi_trace.version=1;hmi_trace.rx_total=hmi_trace.tx_total=0;
 barrier();hmi_trace.magic=0x484d5431u;
 /* UART1 clock and EMIO selection come from this candidate's ps7_init. */
 wr(U1+0x0c,0x3fff);wr(U1,0x28);wr(U1+4,0x20);
 wr(U1+0x18,124);wr(U1+0x34,6); /* 100 MHz / (124*7). */
 /* Reset first: RX reset clears RXTOUT. Receive on a one-byte trigger so
    no packet depends on either another packet or an idle timeout. */
 wr(U1,0x117);
 while(rd(U1)&3u){}
 wr(U1+0x20,1);wr(U1+0x1c,0);wr(U1+0x14,0x3fff);
 /* Standalone CPU0 owns this GIC; retain other interrupt configuration. */
 uint32_t shift=(UART_IRQ%4)*8,off=UART_IRQ&~3u;
 wr(GICD+0x400+off,(rd(GICD+0x400+off)&~(255u<<shift))|(0xa0u<<shift));
 wr(GICD+0x800+off,(rd(GICD+0x800+off)&~(255u<<shift))|(1u<<shift));
 unsigned cfg_shift=(UART_IRQ%16)*2;
 wr(GICD+0xc00+(UART_IRQ/16)*4,rd(GICD+0xc00+(UART_IRQ/16)*4)&~(3u<<cfg_shift));
 wr(GICD+0x280+(UART_IRQ/32)*4,1u<<(UART_IRQ%32));
 wr(GICD+0x100+(UART_IRQ/32)*4,1u<<(UART_IRQ%32));
 wr(GICC+4,0xff);wr(GICC+8,0);wr(GICC,1);wr(GICD,1);
 wr(U1+8,RX_INTERRUPTS);barrier();
 (void)saved;enable_irq();
}
void hmi_irq_dispatch(void){
 uint32_t ack=rd(GICC+0xc),id=ack&1023u;
 if(id==UART_IRQ){
  hmi_uart_counters.interrupts++;
  uint32_t status=rd(U1+0x14);
  wr(U1+0x14,status); /* W1C before draining; later arrivals reassert. */
  if(status&0xe0u){hmi_uart_counters.rx_errors++;rx_fault=1;}
  while(!(rd(U1+0x2c)&2u)){
   uint8_t c=(uint8_t)rd(U1+0x30);uint32_t next=(rx_w+1u)&(RX_SIZE-1u);
   hmi_trace.rx[hmi_trace.rx_total&(HMI_TRACE_SIZE-1u)]=c;barrier();hmi_trace.rx_total++;
   hmi_uart_counters.rx_bytes++;
   if(next==rx_r){hmi_uart_counters.rx_overflow++;rx_fault=1;}
   else if(!rx_fault){rx[rx_w]=c;barrier();rx_w=next;}
  }
  tx_fill();
 }else if(id<1020u){
  hmi_uart_counters.unexpected_irq++;
  wr(GICD+0x180+(id/32)*4,1u<<(id%32));
 }
 if(id<1020u){barrier();wr(GICC+0x10,ack);}
}
int hmi_uart_read(uint8_t*c){
 if(rx_fault||rx_r==rx_w)return 0;
 barrier();*c=rx[rx_r];rx_r=(rx_r+1u)&(RX_SIZE-1u);return 1;
}
int hmi_uart_fault(void){
 uint32_t saved=lock();unsigned fault=rx_fault;
 if(fault){rx_r=rx_w;rx_fault=0;}unlock(saved);return (int)fault;
}
int hmi_uart_write(const uint8_t*p,size_t n){
 uint32_t saved=lock();unsigned available=(tx_r-tx_w-1u)&(TX_SIZE-1u);
 /* At most one group may be in flight. The link rebuilds unsent groups
    from the latest device generation instead of queuing stale results. */
 if(tx_r!=tx_w||!(rd(U1+0x2c)&8u)||(rd(U1+0x2c)&0x800u)){unlock(saved);return 0;}
 if(n>available){hmi_uart_counters.tx_full++;unlock(saved);return 0;}
 for(size_t i=0;i<n;i++){txq[tx_w]=p[i];tx_w=(tx_w+1u)&(TX_SIZE-1u);}
 barrier();tx_fill();unlock(saved);return 1;
}
