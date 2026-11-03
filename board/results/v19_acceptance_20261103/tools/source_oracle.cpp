// Host C simulation with explicit build dimensions. Never a physical FPGA output.
#include "../../../vision/v16alpha50/hls/motion60_shared/phase_core.hpp"
#include <cstdio>
#include <cstdlib>
#include <vector>
extern "C" void coefficients(unsigned,float*);
void motion60_shared(const ap_uint<16>*,ap_uint<16>*,PhaseWord*,PhaseWord*,PhaseWord*,float,float,float,float,float,bool,unsigned,unsigned&);
int main(int argc,char**argv){
 if(argc!=5)return 2;
 unsigned count=std::strtoul(argv[3],nullptr,10),alpha=std::strtoul(argv[4],nullptr,10);
 if(alpha>50||!count)return 2;
 float c[5];coefficients(alpha,c);
 std::printf("COEFFICIENTS %.10g %.10g %.10g %.10g %.10g\n",c[0],c[1],c[2],c[3],c[4]);
 FILE*fi=std::fopen(argv[1],"rb"),*fo=std::fopen(argv[2],"wb");if(!fi||!fo)return 3;
 const unsigned n=MOTION_WIDTH*MOTION_HEIGHT;
 std::vector<unsigned short> raw(n);std::vector<ap_uint<16>> in(n),out(n);
 std::vector<PhaseWord> state[3];
 for(unsigned l=0;l<3;l++){state[l].resize((3*(n>>(2*l))+3)/4+1);state[l].back()=0x12345678;}
 for(unsigned t=0;t<count;t++){
  if(std::fread(raw.data(),2,n,fi)!=n)return 4;
  for(unsigned i=0;i<n;i++)in[i]=raw[i];
  unsigned status;motion60_shared(in.data(),out.data(),state[0].data(),state[1].data(),state[2].data(),c[0],c[1],c[2],c[3],c[4],t==0,0,status);
  if(status)return 5;
  for(unsigned l=0;l<3;l++)if(state[l].back()!=0x12345678)return 6;
  for(unsigned i=0;i<n;i++)raw[i]=out[i].to_uint();
  if(std::fwrite(raw.data(),2,n,fo)!=n)return 7;
 }
 std::fclose(fi);std::fclose(fo);std::puts("HOST_CSIM_COMPLETE");return 0;
}
