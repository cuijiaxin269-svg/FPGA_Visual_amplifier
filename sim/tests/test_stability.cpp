#include "../../src/ps/spectrum_ui.h"
#include <cstdio>
#include <cstring>
#include <cstdlib>
static uint32_t mem[258];
static uint32_t readword(void*,uint32_t address){return mem[address/4];}
static void put(unsigned k,float a){std::memcpy(mem+2*k,&a,4);std::memcpy(mem+2*k+1,&a,4);}
static void background(){for(unsigned k=0;k<129;k++)put(k,.003f);}
static void peak(unsigned k,float a){put(k-1,a*.55f);put(k,a);put(k+1,a*.55f);}
static void update(spectrum_ui&u){u.measured_fs=60380;spectrum_ui_begin(&u);unsigned polls=0;while(u.phase){spectrum_ui_step(&u,0,readword,0);if(++polls>70)std::abort();}}
static void text(const spectrum_ui&u,char*out){for(unsigned i=0;i<252;i++)out[i]=(char)(u.words[129+i/2]>>((i&1)*8));out[252]=0;}
#define CHECK(x) do{if(!(x)){std::printf("FAIL %d: %s\n",__LINE__,#x);return 1;}}while(0)
int main(){
 spectrum_ui u={};char packet[253];
 background();for(unsigned n=0;n<20;n++)update(u);CHECK(u.count==0);
 // An isolated spike must not become a delayed label due to smoothing.
 peak(22,.1f);update(u);CHECK(u.count==0);
 for(unsigned n=0;n<12;n++){background();update(u);CHECK(u.count==0);}
 spectrum_ui_clear(&u);
 for(unsigned n=0;n<3;n++){background();peak(22,.014f);update(u);if(n<2)CHECK(!u.count);}
 CHECK(u.count==1&&u.weak[0]);text(u,packet);CHECK(packet[50]=='W');
 // A real weak peak remains visible while its amplitude straddles entry level.
 for(unsigned n=0;n<30;n++){background();peak(22,n%2?.008f:.014f);update(u);CHECK(u.count==1&&u.weak[0]);}
 background();update(u);CHECK(u.count==0);
 spectrum_ui_clear(&u);
 for(unsigned n=0;n<3;n++){background();peak(9,.03f);peak(22,.03f);peak(35,.03f);peak(65,.03f);update(u);}
 CHECK(u.count==4);text(u,packet);
 CHECK(!std::memcmp(packet+39,"05.2HZ",6));
 CHECK(!std::memcmp(packet+57,"08.3HZ",6));
 CHECK(!std::memcmp(packet+75,"02.1HZ",6)&&packet[87]=='O');
 CHECK(!std::memcmp(packet+93,"15.3HZ",6)&&packet[105]=='O');
 // Band labels follow the configured band, not a hard-coded set of test tones.
 u.band_lo_millihz=14000;u.band_hi_millihz=17000;spectrum_ui_format(&u);text(u,packet);
 CHECK(!std::memcmp(packet+39,"15.3HZ",6)&&packet[51]==' ');
 for(unsigned i=0;i<252;i++){char c=packet[i];CHECK(c==' '||(c>='A'&&c<='Z')||(c>='0'&&c<='9')||c=='.'||c=='%'||c=='/'||c=='-'||c==':');}
 std::memset(mem,0,sizeof(mem));update(u);CHECK(u.count==0&&!u.smoothing_ready);
 background();peak(22,.03f);for(unsigned n=0;n<3;n++)update(u);CHECK(u.count==1);
 mem[100]=0x7fc00000;update(u);CHECK(u.bad&&u.count==0&&!u.smoothing_ready);
 spectrum_ui_clear(&u);for(unsigned i=0;i<256;i++)CHECK(u.words[i]==0);
 std::puts("STABILITY_TEST_PASSED weak_hysteresis=1 transient_rejection=1 current_evidence_required=1 band_order=1 supported_font=1 invalidation=1");
}
