#include <map>
#include <deque>
#include <vector>
#include <cstdio>
#define HMI_UART_TEST
#include "../../src/ps/hmi_uart.c"
static std::map<uint32_t,uint32_t> reg;
static std::deque<uint8_t> input;
static std::vector<uint8_t> output;
static unsigned fifo_used;
static bool timeout_armed;
uint32_t hmi_test_read(uint32_t a){
 if(a==U1+0x2c)return (input.empty()?2u:0u)|(fifo_used>=64?0x10u:0u)|(fifo_used==0?8u:0x800u);
 if(a==U1+0x30){unsigned c=input.front();input.pop_front();return c;}
 return reg[a];
}
void hmi_test_write(uint32_t a,uint32_t v){
 if(a==U1){
  if(v&1u){reg[U1+0x1c]=0;timeout_armed=false;input.clear();}
  if(v&0x40u)timeout_armed=true;
  reg[a]=v&~0x43u;return;
 }
 if(a==U1+0x30){output.push_back((uint8_t)v);fifo_used++;return;}
 if(a==U1+0x14){reg[a]&=~v;return;}
 if(a==U1+8){reg[U1+0x10]|=v;return;}
 if(a==U1+0xc){reg[U1+0x10]&=~v;return;}
 reg[a]=v;
}
#define CHECK(x) do{if(!(x)){std::printf("FAIL uart %d: %s\n",__LINE__,#x);return 1;}}while(0)
static void interrupt(uint32_t flags){reg[GICC+0xc]=UART_IRQ;reg[U1+0x14]=flags;hmi_irq_dispatch();}
int main(){
 hmi_uart_init();CHECK(reg[U1+4]==0x20&&reg[U1+0x18]==124&&reg[U1+0x34]==6);
 CHECK(reg[U1+0x10]==RX_INTERRUPTS&&reg[GICC]==1);
 CHECK(reg[U1+0x1c]==0&&reg[U1+0x20]==1&&!timeout_armed);
 CHECK(!(reg[U1+0x10]&0x100u)); // No empty-FIFO timeout interrupt storm.
 // Five-byte page replies must reach software without another packet arriving.
 const uint8_t page[]={0x66,0,255,255,255};
 for(uint8_t byte:page){
  input.push_back(byte);
  CHECK(input.size()>=reg[U1+0x20]);interrupt(1);
  uint8_t got=0;CHECK(hmi_uart_read(&got)&&got==byte);
 }
 for(unsigned i=0;i<100;i++)input.push_back((uint8_t)i);
 interrupt(0x101);uint8_t c=0;
 for(unsigned i=0;i<100;i++){CHECK(hmi_uart_read(&c)&&c==i);}CHECK(!hmi_uart_read(&c));
 CHECK(reg[GICC+0x10]==UART_IRQ&&reg[U1+0x14]==0);
 input.push_back('S');interrupt(1);input.push_back('T');interrupt(0x41);
 CHECK(!hmi_uart_read(&c)&&hmi_uart_fault()==1&&!hmi_uart_read(&c)&&hmi_uart_fault()==0);
 for(unsigned i=0;i<4096;i++)input.push_back('A');
 interrupt(1);CHECK(hmi_uart_counters.rx_overflow&&hmi_uart_fault());
 for(unsigned round=0;round<20;round++){
  for(unsigned i=0;i<700;i++)input.push_back((uint8_t)i);
  interrupt(1);for(unsigned i=0;i<700;i++)CHECK(hmi_uart_read(&c)&&c==(uint8_t)i);
 }
 uint8_t packet[160];for(unsigned i=0;i<160;i++)packet[i]=(uint8_t)i;
 CHECK(hmi_uart_write(packet,160)&&output.size()==64&&!hmi_uart_write(packet,160));
 fifo_used=0;interrupt(8);CHECK(output.size()==128);
 fifo_used=0;interrupt(8);CHECK(output.size()==160&&!(reg[U1+0x10]&8));
 for(unsigned i=0;i<160;i++)CHECK(output[i]==packet[i]);
 CHECK(hmi_trace.magic==0x484d5431u&&hmi_trace.rx_total==18203&&hmi_trace.tx_total==160);
 for(unsigned i=0;i<700;i++)CHECK(hmi_trace.rx[(hmi_trace.rx_total-700+i)&8191]==(uint8_t)i);
 for(unsigned i=0;i<160;i++)CHECK(hmi_trace.tx[i]==packet[i]);
 fifo_used=0;CHECK(hmi_uart_write(packet,1));
 reg[GICC+0xc]=1023;unsigned ack=reg[GICC+0x10];hmi_irq_dispatch();CHECK(reg[GICC+0x10]==ack);
 std::puts("HMI_UART_PASSED initialization_irq82 short_packet_trigger no_idle_storm framing_error overflow ring_wrap atomic_tx backpressure spurious_irq");return 0;
}
