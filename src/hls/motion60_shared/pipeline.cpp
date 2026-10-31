#include "phase_core.hpp"
#include <hls_math.h>
#ifndef MOTION_WIDTH
#define MOTION_WIDTH 1280
#define MOTION_HEIGHT 800
#endif

// ELF2 clamps the smallest pyramid dimension to 8. Fixed 2x hardware
// matches that rule only for input dimensions >=64 and divisible by eight.
static_assert(MOTION_WIDTH>=64 && MOTION_HEIGHT>=64 && MOTION_WIDTH%8==0 && MOTION_HEIGHT%8==0,
              "Three-scale hardware requires dimensions >=64 and divisible by eight");
static int reflect(int x,int n) {return x<0?-x:(x>=n?2*n-2-x:x);}

// Separable 5-tap filters. Five cached rows; no spatial intermediates in DDR.
// A row's horizontal and vertical passes each take W cycles at II=1.
template<int W,int H,bool GRAD>
void stencil(hls::stream<float>& in,hls::stream<PhaseInput>& out) {
 float even[5][W], odd[5][W], raw[5][W];
#pragma HLS ARRAY_PARTITION variable=even complete dim=1
#pragma HLS ARRAY_PARTITION variable=odd complete dim=1
#pragma HLS ARRAY_PARTITION variable=raw complete dim=1
#pragma HLS BIND_STORAGE variable=even type=ram_2p impl=bram
#pragma HLS BIND_STORAGE variable=odd type=ram_2p impl=bram
#pragma HLS BIND_STORAGE variable=raw type=ram_2p impl=bram
 for(int y=0;y<H+2;++y) {
  if(y<H) {
   float win[5];
#pragma HLS ARRAY_PARTITION variable=win complete
   float p0=in.read(),p1=in.read(),p2=in.read();
   win[0]=p2;win[1]=p1;win[2]=p0;win[3]=p1;win[4]=p2;
   horizontal: for(int x=0;x<W;++x) {
#pragma HLS PIPELINE II=1
    even[y%5][x]=(win[0]+4*win[1]+6*win[2]+4*win[3]+win[4])*.0625f;
    if(GRAD) odd[y%5][x]=(-win[0]-2*win[1]+2*win[3]+win[4])*.125f;
    raw[y%5][x]=win[2];
    if(x<W-1) {
     float next=x+3<W?in.read():(x+3==W?win[3]:win[1]);
     for(int k=0;k<4;++k)win[k]=win[k+1];
     win[4]=next;
    }
   }
  }
  if(y>=2) {
   vertical: for(int x=0;x<W;++x) {
#pragma HLS PIPELINE II=1
    float e[5],o[5];
#pragma HLS ARRAY_PARTITION variable=e complete
#pragma HLS ARRAY_PARTITION variable=o complete
    for(int k=0;k<5;++k) {
#pragma HLS UNROLL
     int row=reflect(y-4+k,H)%5;
     e[k]=even[row][x];
     if(GRAD)o[k]=odd[row][x];
    }
    PhaseInput p;
    if(GRAD) {
     p.band=raw[(y-2)%5][x];
     p.rx=(o[0]+4*o[1]+6*o[2]+4*o[3]+o[4])*.0625f;
     p.ry=(-e[0]-2*e[1]+2*e[3]+e[4])*.125f;
    } else {p.band=(e[0]+4*e[1]+6*e[2]+4*e[3]+e[4])*.0625f;p.rx=0;p.ry=0;}
    out.write(p);
   }
  }
 }
}

template<int N> void blur_fork(hls::stream<PhaseInput>& in,hls::stream<float>& a,hls::stream<float>& b) {
 for(int i=0;i<N;++i) {
#pragma HLS PIPELINE II=1
  float v=in.read().band;a.write(v);b.write(v);
 }
}
template<int N> void fork_float(hls::stream<float>& in,hls::stream<float>& a,hls::stream<float>& b) {
 for(int i=0;i<N;++i) {
#pragma HLS PIPELINE II=1
  float v=in.read();a.write(v);b.write(v);
 }
}
template<int W,int H> void downsample(hls::stream<float>& in,hls::stream<float>& out) {
 float line[W/2];
 for(int y=0;y<H;++y)for(int x=0;x<W/2;++x) {
#pragma HLS PIPELINE II=2
  float a=in.read(),b=in.read();float sum=a+b;
  if(!(y&1))line[x]=sum;
  else out.write((line[x]+sum)*.25f);
 }
}
template<int W,int H> void upsample(hls::stream<float>& in,hls::stream<float>& out) {
 float rows[2][W];
#pragma HLS ARRAY_PARTITION variable=rows complete dim=1
#pragma HLS BIND_STORAGE variable=rows type=ram_2p impl=bram
 int loaded=-1;
 for(int y=0;y<H*2;++y) {
  int lo=y==0?0:(y-1)/2;
  int hi=y==H*2-1?H-1:(y+1)/2;
  float wy=(y&1)?.25f:.75f;
  if(hi>loaded) {
   for(int x=0;x<W;++x) {
#pragma HLS PIPELINE II=1
    rows[hi%2][x]=in.read();
   }
   loaded=hi;
  }
  for(int x=0;x<W*2;++x) {
#pragma HLS PIPELINE II=1
   int left=x==0?0:(x-1)/2;
   int right=x==W*2-1?W-1:(x+1)/2;
   float wx=(x&1)?.25f:.75f;
   float a=rows[lo%2][left]*(1-wx)+rows[lo%2][right]*wx;
   float b=rows[hi%2][left]*(1-wx)+rows[hi%2][right]*wx;
   out.write(a*(1-wy)+b*wy);
  }
 }
}
template<int N,bool ADD> void combine(hls::stream<float>& a,hls::stream<float>& b,hls::stream<float>& out) {
 for(int i=0;i<N;++i) {
#pragma HLS PIPELINE II=1
  float x=a.read(),y=b.read();out.write(ADD?x+y:x-y);
 }
}
template<int W,int H> void pyramid(hls::stream<float>& in,hls::stream<float>& band,hls::stream<float>& next) {
#pragma HLS DATAFLOW
 hls::stream<PhaseInput> blur;
 hls::stream<float> full,dsinput,small,usinput,large;
#pragma HLS STREAM variable=full depth=8192
#pragma HLS STREAM variable=blur depth=32
#pragma HLS STREAM variable=dsinput depth=32
#pragma HLS STREAM variable=small depth=32
#pragma HLS STREAM variable=usinput depth=32
#pragma HLS STREAM variable=large depth=32
 stencil<W,H,false>(in,blur);
 blur_fork<W*H>(blur,full,dsinput);
 downsample<W,H>(dsinput,small);
 fork_float<W*H/4>(small,next,usinput);
 upsample<W/2,H/2>(usinput,large);
 combine<W*H,false>(full,large,band);
}
template<int W,int H> void phase_band(hls::stream<float>& in,hls::stream<float>& out,
 PhaseWord* state,float b0,float b2,float a1,float a2,float alpha,bool first,unsigned mode) {
#pragma HLS DATAFLOW
 hls::stream<PhaseInput> gradients;
#pragma HLS STREAM variable=gradients depth=64
 stencil<W,H,true>(in,gradients);
 unsigned status;
 phase_core_shared(gradients,out,state,W*H,b0,b2,a1,a2,alpha,first,true,status,mode);
}
template<int W,int H> void reconstruct(hls::stream<float>& band,hls::stream<float>& small,hls::stream<float>& out) {
#pragma HLS DATAFLOW
 hls::stream<float> large;
#pragma HLS STREAM variable=large depth=64
 upsample<W/2,H/2>(small,large);
 combine<W*H,true>(band,large,out);
}
static void read_image(const ap_uint<16>* image,hls::stream<float>& out) {
 for(int i=0;i<MOTION_WIDTH*MOTION_HEIGHT;++i) {
#pragma HLS PIPELINE II=1
  out.write((float)image[i].to_uint());
 }
}
static void write_image(hls::stream<float>& in,ap_uint<16>* image) {
 for(int i=0;i<MOTION_WIDTH*MOTION_HEIGHT;++i) {
#pragma HLS PIPELINE II=1
  float x=in.read();image[i]=(unsigned)(x<0?0:(x>1023?1023:x+.5f));
 }
}
static void shared_dataflow(const ap_uint<16>* input,ap_uint<16>* output,
 PhaseWord* state0,PhaseWord* state1,PhaseWord* state2,
 float b0,float b2,float a1,float a2,float alpha,bool first_frame,unsigned mode) {
#pragma HLS DATAFLOW
 hls::stream<float> g0,g1,g2,res,band0,band1,band2,p0,p1,p2,r0,r1,r2;
#pragma HLS STREAM variable=g0 depth=8192
#pragma HLS STREAM variable=g1 depth=8192
#pragma HLS STREAM variable=g2 depth=8192
#pragma HLS STREAM variable=res depth=8192
#pragma HLS STREAM variable=band0 depth=8192
#pragma HLS STREAM variable=band1 depth=8192
#pragma HLS STREAM variable=band2 depth=8192
// Full-width co-simulation proved 32768 insufficient: fine-band backpressure
// stops the pyramid fork before the coarse gradient can produce its first row.
// Reserve 128K samples (over 100 production-width rows) for startup skew.
#pragma HLS STREAM variable=p0 depth=131072
#pragma HLS STREAM variable=p1 depth=16384
#pragma HLS STREAM variable=p2 depth=8192
#pragma HLS STREAM variable=r0 depth=8192
#pragma HLS STREAM variable=r1 depth=8192
#pragma HLS STREAM variable=r2 depth=8192
 read_image(input,g0);
 pyramid<MOTION_WIDTH,MOTION_HEIGHT>(g0,band0,g1);
 pyramid<MOTION_WIDTH/2,MOTION_HEIGHT/2>(g1,band1,g2);
 pyramid<MOTION_WIDTH/4,MOTION_HEIGHT/4>(g2,band2,res);
 phase_band<MOTION_WIDTH,MOTION_HEIGHT>(band0,p0,state0,b0,b2,a1,a2,alpha,first_frame,mode);
 phase_band<MOTION_WIDTH/2,MOTION_HEIGHT/2>(band1,p1,state1,b0,b2,a1,a2,alpha,first_frame,mode);
 phase_band<MOTION_WIDTH/4,MOTION_HEIGHT/4>(band2,p2,state2,b0,b2,a1,a2,alpha,first_frame,mode);
 reconstruct<MOTION_WIDTH/4,MOTION_HEIGHT/4>(p2,res,r2);
 reconstruct<MOTION_WIDTH/2,MOTION_HEIGHT/2>(p1,r2,r1);
 reconstruct<MOTION_WIDTH,MOTION_HEIGHT>(p0,r1,r0);
 write_image(r0,output);
}
void motion60_shared(const ap_uint<16>* input,ap_uint<16>* output,
 PhaseWord* state0,PhaseWord* state1,PhaseWord* state2,
 float b0,float b2,float a1,float a2,float alpha,bool first_frame,unsigned mode,unsigned &status) {
#pragma HLS INTERFACE m_axi port=input offset=slave bundle=images depth=1024000 max_read_burst_length=64
#pragma HLS INTERFACE m_axi port=output offset=slave bundle=images depth=1024000 max_write_burst_length=64
#pragma HLS INTERFACE m_axi port=state0 offset=slave bundle=state0 depth=1024000 max_read_burst_length=64 max_write_burst_length=64
#pragma HLS INTERFACE m_axi port=state1 offset=slave bundle=state1 depth=256000 max_read_burst_length=64 max_write_burst_length=64
#pragma HLS INTERFACE m_axi port=state2 offset=slave bundle=state2 depth=64000 max_read_burst_length=64 max_write_burst_length=64
#pragma HLS INTERFACE s_axilite port=return bundle=control
#pragma HLS INTERFACE s_axilite port=input bundle=control
#pragma HLS INTERFACE s_axilite port=output bundle=control
#pragma HLS INTERFACE s_axilite port=state0 bundle=control
#pragma HLS INTERFACE s_axilite port=state1 bundle=control
#pragma HLS INTERFACE s_axilite port=state2 bundle=control
#pragma HLS INTERFACE s_axilite port=b0 bundle=control
#pragma HLS INTERFACE s_axilite port=b2 bundle=control
#pragma HLS INTERFACE s_axilite port=a1 bundle=control
#pragma HLS INTERFACE s_axilite port=a2 bundle=control
#pragma HLS INTERFACE s_axilite port=alpha bundle=control
#pragma HLS INTERFACE s_axilite port=first_frame bundle=control
#pragma HLS INTERFACE s_axilite port=mode bundle=control
#pragma HLS INTERFACE s_axilite port=status bundle=control
 status=1;
 if(mode>2 || !(alpha>=0 && alpha<=50))return;
 shared_dataflow(input,output,state0,state1,state2,b0,b2,a1,a2,alpha,first_frame,mode);
 status=0;
}
