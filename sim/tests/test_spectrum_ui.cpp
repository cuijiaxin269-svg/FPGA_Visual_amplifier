#include "../../src/ps/spectrum_ui.h"
#include <cstdio>
#include <cmath>
#include <cstring>
#include <cstdlib>
#include <cstddef>
static uint32_t memory[258];
static uint32_t readword(void*,uint32_t a){return memory[a/4];}
static void put(unsigned k,unsigned axis,float v){std::memcpy(memory+2*k+axis,&v,4);}
static void transform(const double *frequencies,const double *amplitudes,unsigned tones){
 for(unsigned axis=0;axis<2;axis++){
  double samples[256],sum=0,weighted=0;
  for(unsigned n=0;n<256;n++){
   double v=0;for(unsigned t=0;t<tones;t++)v+=amplitudes[t]*(axis?0.7:1)*std::sin(6.283185307179586*frequencies[t]*n/60.38+.31*t);
   samples[n]=v;sum+=v;weighted+=(n-127.5)*v;
  }
  for(unsigned k=0;k<129;k++){
   double re=0,im=0;
   for(unsigned n=0;n<256;n++){
    double v=(samples[n]-sum/256-(n-127.5)*weighted/1398080)*(.5-.5*std::cos(6.283185307179586*n/255));
    re+=v*std::cos(6.283185307179586*k*n/256);im-=v*std::sin(6.283185307179586*k*n/256);
   }
   put(k,axis,(float)(std::hypot(re,im)*2/127.5));
  }
 }
}
static void update(spectrum_ui &u){
 u.measured_fs=60380;spectrum_ui_begin(&u);unsigned polls=0;
 while(u.phase){spectrum_ui_step(&u,0,readword,0);if(++polls>70)std::abort();}
}
#define CHECK(x) do{if(!(x)){std::printf("FAIL line %d: %s\n",__LINE__,#x);return 1;}}while(0)
int main(int argc,char**argv){
 spectrum_ui u={};unsigned bad=0;
 CHECK(offsetof(spectrum_ui,words)%4==0);
 CHECK(spectrum_ui_q16(0x3f800000,&bad)==65536&&!bad);
 CHECK(!spectrum_ui_q16(0x7fc00000,&bad)&&bad);
 spectrum_ui_clock(&u,0,1);spectrum_ui_clock(&u,64,106000001);CHECK(u.measured_fs==60377);
 double f[]={5,10},a[]={.2,.15};transform(f,a,2);update(u);CHECK(u.count==0);update(u);CHECK(u.count==0);update(u);CHECK(u.count==2);
 CHECK(u.frequency[0]>=49&&u.frequency[0]<=51&&u.frequency[1]>=99&&u.frequency[1]<=101);
 std::puts("PASS non-bin-centred 5+10 Hz: two persistent peaks, no mainlobe duplicates");
 double three[]={3.5,7,10.5},three_a[]={.15,.1,.12};
 spectrum_ui_clear(&u);transform(three,three_a,3);update(u);update(u);update(u);
 if(u.count!=3){std::printf("three-tone count=%u threshold=%u\n",u.count,u.threshold);for(unsigned j=0;j<u.count;j++)std::printf("peak=%u\n",u.frequency[j]);}
 CHECK(u.count==3);
 CHECK(u.frequency[0]==35&&u.frequency[1]==70&&u.frequency[2]==105);
 std::puts("PASS current 3.5+7+10.5 Hz: all three labels and no duplicate peaks");
 double many[14],amps[14];for(unsigned j=0;j<14;j++){many[j]=1.0+j*2;amps[j]=.1;}
 spectrum_ui_clear(&u);transform(many,amps,14);update(u);update(u);update(u);CHECK(u.count==14);
 CHECK(u.words[255]==6038);std::puts("PASS 14 components retained; text pagination has no top-N truncation");
 u.publications=20;spectrum_ui_format(&u);
 char text[253]={};for(unsigned j=0;j<252;j++)text[j]=(char)(u.words[129+j/2]>>((j&1)*8));
 CHECK(!std::memcmp(text+246,"14 2/2",6));
 CHECK(!std::memcmp(text+216,"00.0HZ07.5HZ15.1HZ22.6HZ30.2HZ",30));
 std::puts("PASS measured-frequency tick conversion and independent footer fields");
 std::memset(memory,0,sizeof(memory));update(u);CHECK(u.count==0);for(unsigned k=0;k<129;k++)CHECK(!(u.words[k]&128));
 std::puts("PASS vanished peaks removed immediately; silence cannot preserve old peaks");
 spectrum_ui_clear(&u);CHECK(!u.count&&!u.phase&&!u.measured_fs);
 for(unsigned k=0;k<256;k++)CHECK(!u.words[k]);
 spectrum_ui_begin(&u);memory[10]=0x7fc00000;while(u.phase)spectrum_ui_step(&u,0,readword,0);CHECK(u.bad);
 if(argc>1){
  FILE*fbin=std::fopen(argv[1],"rb");CHECK(fbin);CHECK(std::fread(memory,4,258,fbin)==258);std::fclose(fbin);
  spectrum_ui_clear(&u);update(u);update(u);update(u);
  std::printf("MEASURED peaks=%u threshold_q16=%u:",u.count,u.threshold);
  for(unsigned i=0;i<u.count;i++)std::printf(" %.1fHz/%u%%",u.frequency[i]/10.,u.relative[i]);
  std::puts("");
  if(argc>2){FILE*hex=std::fopen(argv[2],"w");CHECK(hex);for(unsigned j=0;j<256;j++)std::fprintf(hex,"%04x\n",u.words[j]);std::fclose(hex);}
 }else {spectrum_ui_clear(&u);transform(f,a,2);update(u);update(u);}
 std::puts("SPECTRUM_UI_TEST_PASSED");return 0;
}
