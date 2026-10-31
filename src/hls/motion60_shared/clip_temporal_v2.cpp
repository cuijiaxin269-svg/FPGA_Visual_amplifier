#include <hls_math.h>
#ifndef CLIP_PHASE_AXI_DEPTH
#define CLIP_PHASE_AXI_DEPTH 122880000
#endif
// The kernel only needs cos(2*pi*k*lag/N), not arbitrary IEEE-754 angles.
// Integer periodic reduction and quadrant folding bound x to [0,pi/2].
// Degree-18 cosine Taylor remainder there is below 3.5e-15 (before rounding).
double kernel_cos(unsigned k,unsigned lag,unsigned frames){
#pragma HLS INLINE off
 const double pi=3.1415926535897932384626433832795;
 unsigned r=(k*lag)%frames;
 double x=2*pi*double(r)/double(frames),sign=1;
 if(x>pi)x=2*pi-x;
 if(x>pi*.5){x=pi-x;sign=-1;}
 const double c[10]={1.0,-1.0/2,1.0/24,-1.0/720,1.0/40320,
  -1.0/3628800,1.0/479001600,-1.0/87178291200.0,
  1.0/20922789888000.0,-1.0/6402373705728000.0};
 double square=x*x,value=c[9];
 for(int j=8;j>=0;j--)value=value*square+c[j];
 return sign*value;
}
// One dispatch per pyramid level. ARM never unwraps or copies pixel tiles.
// In-place writes are safe: each tile loads every time sample before writing.
static bool finite_value(float value){union{float f;unsigned u;}x;x.f=value;return (x.u&0x7f800000u)!=0x7f800000u;}
extern "C" void clip_temporal_full(float *phase,unsigned frames,unsigned pixels,
 double fps,double low,double high,bool valid_clip,unsigned &status){
#pragma HLS INTERFACE m_axi port=phase offset=slave bundle=phase_mem depth=CLIP_PHASE_AXI_DEPTH max_read_burst_length=64 max_write_burst_length=64
#pragma HLS INTERFACE s_axilite port=phase bundle=control
#pragma HLS INTERFACE s_axilite port=frames bundle=control
#pragma HLS INTERFACE s_axilite port=pixels bundle=control
#pragma HLS INTERFACE s_axilite port=fps bundle=control
#pragma HLS INTERFACE s_axilite port=low bundle=control
#pragma HLS INTERFACE s_axilite port=high bundle=control
#pragma HLS INTERFACE s_axilite port=valid_clip bundle=control
#pragma HLS INTERFACE s_axilite port=status bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
 status=1;
 if(!valid_clip||frames<30||frames>120||!pixels||pixels>1024000||
    !(fps>0&&fps<1000&&low>0&&low<high&&high<fps*.5))return;
 float coefficients[120],samples[120][64],sum[64];
#pragma HLS BIND_STORAGE variable=samples type=ram_2p impl=bram
#pragma HLS BIND_STORAGE variable=sum type=ram_2p impl=lutram latency=2
 for(unsigned lag=0;lag<frames;lag++){
  double value=0;
  for(unsigned k=1;k<=frames/2;k++){
   double frequency=double(k)*fps/double(frames);
   if(frequency>=low&&frequency<=high)
    value+=(2*k==frames?1.0:2.0)*kernel_cos(k,lag,frames)/double(frames);
  }
  coefficients[lag]=float(value);
 }
 for(unsigned start=0;start<pixels;start+=64){
  unsigned lanes=pixels-start<64?pixels-start:64;
  bool finite=true;
  for(unsigned t=0;t<frames;t++)for(unsigned x=0;x<lanes;x++){
#pragma HLS PIPELINE II=1
   float v=phase[t*pixels+start+x];samples[t][x]=v;
   if(!finite_value(v))finite=false;
  }
  if(!finite){status=2;return;}
  for(unsigned x=0;x<lanes;x++){
   float initial=samples[0][x],previous=initial,offset=0;
   for(unsigned t=0;t<frames;t++){
    float value=samples[t][x],difference=value-previous;
    if(difference>3.14159265358979323846f)offset-=6.2831853071795864769f;
    if(difference<-3.14159265358979323846f)offset+=6.2831853071795864769f;
    previous=value;samples[t][x]=(value+offset)-initial;
   }
  }
  for(unsigned t=0;t<frames;t++){
   for(unsigned x=0;x<64;x++){
#pragma HLS PIPELINE II=1
    sum[x]=0;
   }
   for(unsigned source=0;source<frames;source++){
    float weight=coefficients[t>=source?t-source:t+frames-source];
    for(unsigned x=0;x<64;x++){
#pragma HLS PIPELINE II=1
     if(x<lanes)sum[x]+=weight*samples[source][x];
    }
   }
   bool output_finite=true;
   for(unsigned x=0;x<64;x++){
#pragma HLS PIPELINE II=1
    if(x<lanes&&!finite_value(sum[x]))output_finite=false;
   }
   if(!output_finite){status=3;return;}
   for(unsigned x=0;x<lanes;x++){
#pragma HLS PIPELINE II=1
    phase[t*pixels+start+x]=sum[x];
   }
  }
 }
 status=0;
}
