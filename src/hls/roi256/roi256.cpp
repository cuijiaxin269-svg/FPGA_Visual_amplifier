#include <hls_math.h>
#include <stdint.h>
#include "../spectrum256/tables.hpp"
struct Complex {float re,im;};

static unsigned reverse8(unsigned x){
    unsigned r=0;
    for(int i=0;i<8;i++){
#pragma HLS UNROLL
        r=(r<<1)|((x>>i)&1);
    }
    return r;
}
static void fft_stage(const float ar[256],const float ai[256],
                      float br[256],float bi[256],unsigned stage,bool inverse){
#pragma HLS INLINE off
    // For a fixed stage, p/q enumerate each output index exactly once; the
    // two output arrays are not read. No WAW dependency exists within/across
    // butterflies. Preserve both physical write ports and remove false aliases.
#pragma HLS BIND_STORAGE variable=br type=ram_t2p impl=bram
#pragma HLS BIND_STORAGE variable=bi type=ram_t2p impl=bram
#pragma HLS DEPENDENCE variable=br inter false
#pragma HLS DEPENDENCE variable=bi inter false
#pragma HLS DEPENDENCE variable=br intra false
#pragma HLS DEPENDENCE variable=bi intra false
    for(unsigned b=0;b<128;b++){
#pragma HLS PIPELINE II=1
        unsigned half=1u<<stage,j=b&(half-1),p=((b>>stage)<<(stage+1))+j,q=p+half;
        unsigned k=j<<(7-stage);
        float c=cos256[k],s=inverse?sin256[k]:-sin256[k];
        float tr=ar[q]*c-ai[q]*s,ti=ar[q]*s+ai[q]*c;
        br[p]=ar[p]+tr;bi[p]=ai[p]+ti;
        br[q]=ar[p]-tr;bi[q]=ai[p]-ti;
    }
}
static void fft_line(Complex data[65536],unsigned row,bool column,bool inverse){
#pragma HLS INLINE off
    float ar[256],ai[256],br[256],bi[256];
#pragma HLS BIND_STORAGE variable=ar type=ram_t2p impl=bram
#pragma HLS BIND_STORAGE variable=ai type=ram_t2p impl=bram
#pragma HLS BIND_STORAGE variable=br type=ram_t2p impl=bram
#pragma HLS BIND_STORAGE variable=bi type=ram_t2p impl=bram
    for(unsigned i=0;i<256;i++){
#pragma HLS PIPELINE II=1
        Complex v=data[column?i*256+row:row*256+i];
        ar[reverse8(i)]=v.re;ai[reverse8(i)]=v.im;
    }
    for(unsigned stage=0;stage<8;stage++){
        if(!(stage&1))fft_stage(ar,ai,br,bi,stage,inverse);
        else fft_stage(br,bi,ar,ai,stage,inverse);
    }
    for(unsigned i=0;i<256;i++){
#pragma HLS PIPELINE II=1
        float scale=inverse?1.0f/256:1;
        data[column?i*256+row:row*256+i]={ar[i]*scale,ai[i]*scale};
    }
}
static void fft2(Complex data[65536],bool inverse){
#pragma HLS INLINE off
    for(unsigned direction=0;direction<2;direction++){
        for(unsigned row=0;row<256;row++){
            fft_line(data,row,direction!=0,inverse);
        }
    }
}
static float subpixel(float p,float c,float n){
    float d=p-2*c+n;
    return hls::fabsf(d)>1e-12f?.5f*(p-n)/d:0;
}
// One full-resolution input, selectable 256x256 ROI; outputs {dx,dy,peak,var}.
// No temporal decimation. Caller starts only on complete CRC-valid frames,
// supplies first_frame after a gap/config change, and checks returned status.
extern "C" void roi256(const uint16_t *input,float *output,unsigned x,unsigned y,
                        bool first_frame,bool valid_frame,unsigned &status){
#pragma HLS INTERFACE m_axi port=input offset=slave bundle=image depth=1024000 max_read_burst_length=256
#pragma HLS INTERFACE m_axi port=output offset=slave bundle=result depth=4
#pragma HLS INTERFACE s_axilite port=input bundle=control
#pragma HLS INTERFACE s_axilite port=output bundle=control
#pragma HLS INTERFACE s_axilite port=x bundle=control
#pragma HLS INTERFACE s_axilite port=y bundle=control
#pragma HLS INTERFACE s_axilite port=first_frame bundle=control
#pragma HLS INTERFACE s_axilite port=valid_frame bundle=control
#pragma HLS INTERFACE s_axilite port=status bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
    static Complex reference[65536],data[65536];
    static bool have_reference=false;
    static unsigned reference_x=0,reference_y=0;
#pragma HLS BIND_STORAGE variable=reference type=ram_2p impl=bram
#pragma HLS BIND_STORAGE variable=data type=ram_2p impl=bram
    status=1;
    if(!valid_frame){have_reference=false;return;}
    if(x>1024||y>544){have_reference=false;status=2;return;}
    if(first_frame||x!=reference_x||y!=reference_y)have_reference=false;
    uint32_t sum=0;uint64_t squares=0;bool range_ok=true;
    for(unsigned row=0;row<256;row++){
        for(unsigned col=0;col<256;col++){
#pragma HLS PIPELINE II=1
            uint16_t v=input[(y+row)*1280+x+col];
            if(v>1023)range_ok=false;
            sum+=v;squares+=uint32_t(v)*uint32_t(v);
            data[row*256+col]={float(v)*(hann256[row]*hann256[col]),0};
        }
    }
    if(!range_ok){have_reference=false;status=4;return;}
    float variance=float((squares<<16)-uint64_t(sum)*sum)/4294967296.0f;
    if(variance<=1){have_reference=false;status=3;return;}
    fft2(data,false);
    for(unsigned i=0;i<65536;i++){
#pragma HLS PIPELINE II=1
        Complex a=have_reference?reference[i]:data[i],b=data[i];
        if(!have_reference)reference[i]=b;
        float re=a.re*b.re+a.im*b.im,im=a.im*b.re-a.re*b.im;
        float norm=hls::sqrtf(re*re+im*im)+1e-9f;
        data[i]={re/norm,im/norm};
    }
    have_reference=true;reference_x=x;reference_y=y;
    fft2(data,true);
    // Finite IEEE floats have an order-preserving unsigned encoding. Avoid a
    // float comparator feedback path that would force an 11ns clock at II=1.
    uint32_t best=0;unsigned index=0;
    for(unsigned i=0;i<65536;i++){
#pragma HLS PIPELINE II=1
        union {float f;uint32_t u;} value;value.f=data[i].re;
        uint32_t key=(value.u&0x80000000u)?~value.u:(value.u^0x80000000u);
        if(key>best){best=key;index=i;}
    }
    float peak=data[index].re;
    unsigned ix=index&255,iy=index>>8;
    float dx=float(ix)+subpixel(data[iy*256+((ix-1)&255)].re,peak,data[iy*256+((ix+1)&255)].re);
    float dy=float(iy)+subpixel(data[((iy-1)&255)*256+ix].re,peak,data[((iy+1)&255)*256+ix].re);
    output[0]=dx>128?dx-256:dx;output[1]=dy>128?dy-256:dy;
    output[2]=peak;output[3]=variance;status=0;
}
