#include "phase_core.hpp"
#include <cmath>
#include <cstdio>
#include <limits>
#include <vector>
void baseline_phase_core_shared(hls::stream<PhaseInput>&,hls::stream<float>&,PhaseWord*,unsigned,float,float,float,float,float,bool,bool,unsigned&,unsigned);
void motion60_shared(const ap_uint<16>*,ap_uint<16>*,PhaseWord*,PhaseWord*,PhaseWord*,float,float,float,float,float,bool,unsigned,unsigned&);
#define CHECK(c) do{if(!(c)){std::printf("ALPHA50_FAIL line=%d\n",__LINE__);return 1;}}while(0)
static PhaseWord packed(float value){union{float f;unsigned u;}v;v.f=value;return PhaseWord(v.u);}
int main(){
 const unsigned n=64;unsigned status=99,baseline_status=99;
 std::vector<PhaseWord> state(3*n/4+1),baseline=state;
 for(unsigned t=0;t<32;t++){
  hls::stream<PhaseInput> in,old_in;hls::stream<float> out,old_out;
  for(unsigned j=0;j<n;j++){PhaseInput p={float(20*std::sin(.13*j+.2*t)),float(j%7),-3};in.write(p);old_in.write(p);}
  phase_core_shared(in,out,state.data(),n,.1f,-.1f,-1.3f,.6f,30,t==0,true,status,0);
  baseline_phase_core_shared(old_in,old_out,baseline.data(),n,.1f,-.1f,-1.3f,.6f,30,t==0,true,baseline_status,0);
  CHECK(!status&&!baseline_status&&state==baseline);
  for(unsigned j=0;j<n;j++)CHECK(out.read()==old_out.read());
 }
 std::puts("PASS alpha30 phase output and history exactly match original source");
 for(float alpha:{0.f,30.f,50.f}){
  hls::stream<PhaseInput> in;hls::stream<float> out;
  for(unsigned j=0;j<n;j++){state[j/4].range(32*(j%4)+31,32*(j%4))=packed(.02f*std::sin(float(j))).range(31,0);in.write(PhaseInput{10,3,4});}
  phase_core_shared(in,out,state.data(),n,0,0,0,0,alpha,false,true,status,2);CHECK(!status);
  for(unsigned j=0;j<n;j++){
   float angle=alpha*.02f*std::sin(float(j));float expected=10*std::cos(angle)+(5+1e-6f)*std::sin(angle);
   float v=out.read();CHECK(std::isfinite(v)&&std::fabs(v-expected)<1e-4f);
  }
  CHECK(in.empty()&&out.empty());
 }
 for(float alpha:{-1.f,std::nextafter(50.f,100.f),std::numeric_limits<float>::infinity(),std::numeric_limits<float>::quiet_NaN()}){
  hls::stream<PhaseInput> in;hls::stream<float> out;auto before=state;
  phase_core_shared(in,out,state.data(),n,0,0,0,0,alpha,false,true,status,0);
  CHECK(status==3&&state==before&&out.empty());
 }
 std::puts("PASS phase alpha=0/30/50 numeric reconstruction and invalid endpoint rejection");
 const unsigned pixels=128*96;std::vector<ap_uint<16>> input(pixels),output(pixels);
 unsigned sums[3]={},changes[3]={};
 for(unsigned test=0;test<3;test++){
  float alpha=test==0?0.f:(test==1?30.f:50.f);
  std::vector<PhaseWord> a(3*pixels/4),b(3*pixels/16),c(3*pixels/64);
  for(unsigned t=0;t<12;t++){
   for(unsigned j=0;j<pixels;j++)input[j]=(unsigned)(512+120*std::sin((j%128)*.21+.012*std::sin(t*.37))+80*std::cos((j/128)*.19));
   motion60_shared(input.data(),output.data(),a.data(),b.data(),c.data(),.1f,-.1f,-1.3f,.6f,alpha,t==0,0,status);CHECK(!status);
   for(unsigned j=0;j<pixels;j++){CHECK(output[j]<=1023);if(t==11){sums[test]+=output[j].to_uint();changes[test]+=std::abs((int)output[j].to_uint()-(int)input[j].to_uint());}}
  }
  CHECK(sums[test]>pixels*200&&sums[test]<pixels*800);
  output[0]=777;auto before=a;
  motion60_shared(input.data(),output.data(),a.data(),b.data(),c.data(),0,0,0,0,std::nextafter(50.f,100.f),false,0,status);
  CHECK(status==1&&output[0]==777&&a==before);
 }
 CHECK(changes[1]!=changes[2]);
 std::printf("PASS 128x96 live pipeline: alpha0/30/50 DN differences=%u/%u/%u; no physical gain claim\n",changes[0],changes[1],changes[2]);
 std::puts("ALPHA50_CSIM_PASSED");return 0;
}
