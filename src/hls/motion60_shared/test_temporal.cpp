#include <cmath>
#include <cstdio>
#include <vector>
#include <limits>
extern "C" void clip_temporal_full(float*,unsigned,unsigned,double,double,double,bool,unsigned&);
int main(){
 const double pi=3.14159265358979323846,fps=60.379777,lo=3,hi=12;
 for(unsigned n:{30u,31u,120u})for(unsigned pixels:{1u,64u,65u}){
  // RTL's AXI adapter marshals the declared test aperture, not just active pixels.
  std::vector<float> data(15360),initial;
  for(unsigned t=0;t<n;t++)for(unsigned x=0;x<pixels;x++)
   data[t*pixels+x]=float(std::remainder(.23*t+.4*std::sin(2*pi*5*t/n)+.01*x,2*pi));
  data[n*pixels]=12345;initial=data;unsigned status=99;
  clip_temporal_full(data.data(),n,pixels,fps,lo,hi,true,status);
  if(status||data[n*pixels]!=12345)return 1;
  double maximum=0;
  for(unsigned x=0;x<pixels;x++){
   std::vector<double> unwrapped(n),re(n),im(n);
   float previous=initial[x],offset=0;
   for(unsigned t=0;t<n;t++){
    float v=initial[t*pixels+x],difference=v-previous;
    if(difference>float(pi))offset-=float(2*pi);
    if(difference<-float(pi))offset+=float(2*pi);
    previous=v;unwrapped[t]=(v+offset)-initial[x];
   }
   for(unsigned k=0;k<n;k++){
    double frequency=double(k<=n/2?k:n-k)*fps/n;
    if(frequency<lo||frequency>hi)continue;
    for(unsigned t=0;t<n;t++){re[k]+=unwrapped[t]*std::cos(2*pi*k*t/n);im[k]-=unwrapped[t]*std::sin(2*pi*k*t/n);}
   }
   for(unsigned t=0;t<n;t++){
    double expected=0;
    for(unsigned k=0;k<n;k++)expected+=(re[k]*std::cos(2*pi*k*t/n)-im[k]*std::sin(2*pi*k*t/n))/n;
    maximum=std::fmax(maximum,std::fabs(data[t*pixels+x]-expected));
   }
  }
  if(maximum>1e-4)return 2;
  std::printf("PASS FPGA temporal n=%u pixels=%u DFT_error=%g\n",n,pixels,maximum);
 }
 std::vector<float> invalid(15360,1);invalid[0]=std::numeric_limits<float>::quiet_NaN();unsigned status;
 clip_temporal_full(invalid.data(),30,1,fps,lo,hi,true,status);if(status!=2)return 3;
 invalid.assign(15360,1);clip_temporal_full(invalid.data(),30,1,fps,lo,hi,false,status);
 if(status!=1||invalid[0]!=1)return 4;
 return 0;
}
