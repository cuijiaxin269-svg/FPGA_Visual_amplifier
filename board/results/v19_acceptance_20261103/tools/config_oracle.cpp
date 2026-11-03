// Exercise the unchanged sealed V19 coefficient generator in host memory.
#include <map>
#include "../../../vision/v19boot/sw/capture.h"
volatile capture_control mailbox;
volatile uint32_t test_motion_tm[32];
static std::map<uint32_t,uint32_t> registers;
static uint32_t host_rd(uint32_t a){return registers[a];}
static void host_wr(uint32_t a,uint32_t v){registers[a]=v;}
static uint64_t host_timer(){return 0;}
#define MOTION60_TEST_IO
#define rd host_rd
#define wr host_wr
#define timer_ticks host_timer
#include "../../../vision/v19boot/sw/motion60.c"
#undef rd
#undef wr
#undef timer_ticks
extern "C" void coefficients(unsigned alpha,float *v){
 registers.clear();lo_milli=3000;hi_milli=12000;alpha_milli=alpha*1000;config();
 const unsigned offsets[5]={0x4c,0x54,0x5c,0x64,0x6c};
 for(unsigned i=0;i<5;i++){union{uint32_t u;float f;}x;x.u=registers[HLS+offsets[i]];v[i]=x.f;}
}
