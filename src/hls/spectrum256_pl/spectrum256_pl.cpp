#include <hls_math.h>
#include "../spectrum256/tables.hpp"

// Independent window engine: 256 chronological {dx,dy} float samples, px.
// The caller must provide a complete CRC-valid, contiguous window. Publishing
// at 5Hz does not change the required per-frame displacement sampling rate.
static void spectrum256_array(const float *motion, float *amplitude,
                            bool valid_window, unsigned &status) {
    status=1;
    if(!valid_window)return;
    float samples[512], windowed[256], result[258];
    bool finite=true;
    for(int i=0;i<512;i++){
#pragma HLS PIPELINE II=1
        float v=motion[i];samples[i]=v;
        union {float f;unsigned u;} bits;bits.f=v;
        if((bits.u&0x7f800000u)==0x7f800000u)finite=false;
    }
    if(!finite){status=2;return;}
    for(int axis=0;axis<2;axis++){
        float total=0,weighted=0;
        for(int n=0;n<256;n++){
#pragma HLS PIPELINE II=8
            float v=samples[2*n+axis];
            total+=v;weighted+=(float(n)-127.5f)*v;
        }
        float mean=total/256.0f;
        // Sum((n-127.5)^2), n=0..255, is 1398080.
        float slope=weighted/1398080.0f;
        for(int n=0;n<256;n++){
#pragma HLS PIPELINE II=1
            windowed[n]=(samples[2*n+axis]-mean-(float(n)-127.5f)*slope)*hann256[n];
        }
        // Direct DFT at the 129 real-signal bins. Same transform as rfft;
        // sharing arithmetic saves resources at the 5Hz publication cadence.
        for(int k=0;k<129;k++){
            float re=0,im=0;
            for(int n=0;n<256;n++){
#pragma HLS PIPELINE II=8
                unsigned phase=(k*n)&255;
                re+=windowed[n]*cos256[phase];
                im-=windowed[n]*sin256[phase];
            }
            result[2*k+axis]=hls::sqrtf(re*re+im*im)*(2.0f/127.5f);
        }
    }
    for(int i=0;i<258;i++){
#pragma HLS PIPELINE II=1
        amplitude[i]=result[i];
    }
    status=0;
}

// op=0 reset, op=1 ingest one PL ROI result, op=2 publish the current window.
// PS owns only sequence/epoch scheduling and register configuration.
// Output: 258 IEEE float amplitude words, then 129 packed X/Y bar words.
extern "C" void spectrum256_pl(const float *motion,unsigned *output,
 unsigned operation,unsigned sequence,bool valid_sample,unsigned &status,
 unsigned &count,unsigned &epoch,unsigned &last_sequence,unsigned &clipped_bins){
#pragma HLS INTERFACE m_axi port=motion offset=slave bundle=input_mem depth=2 max_read_burst_length=2
#pragma HLS INTERFACE m_axi port=output offset=slave bundle=output_mem depth=387 max_write_burst_length=64
#pragma HLS INTERFACE s_axilite port=motion bundle=control
#pragma HLS INTERFACE s_axilite port=output bundle=control
#pragma HLS INTERFACE s_axilite port=operation bundle=control
#pragma HLS INTERFACE s_axilite port=sequence bundle=control
#pragma HLS INTERFACE s_axilite port=valid_sample bundle=control
#pragma HLS INTERFACE s_axilite port=status bundle=control
#pragma HLS INTERFACE s_axilite port=count bundle=control
#pragma HLS INTERFACE s_axilite port=epoch bundle=control
#pragma HLS INTERFACE s_axilite port=last_sequence bundle=control
#pragma HLS INTERFACE s_axilite port=clipped_bins bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
 static float ring[512];
 static unsigned head=0,used=0,generation=0,last=0;
 static bool have=false;
#pragma HLS BIND_STORAGE variable=ring type=ram_2p impl=bram
 status=0;clipped_bins=0;
 if(operation==0){head=used=last=0;have=false;generation++;}
 else if(operation==1){
  float x=0,y=0;bool good=valid_sample;
  if(good){x=motion[0];y=motion[1];}
  union{float f;unsigned u;}bx,by;bx.f=x;by.f=y;
  good=good&&((bx.u&0x7f800000u)!=0x7f800000u)&&((by.u&0x7f800000u)!=0x7f800000u)&&x>=-256&&x<=256&&y>=-256&&y<=256;
  if(!good){head=used=last=0;have=false;generation++;status=2;}
  else{
   if(have&&sequence!=last+1u){head=used=0;generation++;}
   ring[2*head]=x;ring[2*head+1]=y;head=(head+1u)&255u;
   if(used<256)used++;last=sequence;have=true;
  }
 }else if(operation==2){
  if(used!=256){status=4;}
  else{
   float chronological[512],amplitude[258];unsigned words[387];
   for(unsigned i=0;i<256;i++){
#pragma HLS PIPELINE II=1
    unsigned j=(head+i)&255u;chronological[2*i]=ring[2*j];chronological[2*i+1]=ring[2*j+1];
   }
   unsigned transform_status;
   spectrum256_array(chronological,amplitude,true,transform_status);
   bool good=transform_status==0;unsigned clipped=0;
   for(unsigned k=0;k<129;k++){
    unsigned bar=0;
    for(unsigned axis=0;axis<2;axis++){
#pragma HLS PIPELINE II=1
     union{float f;unsigned u;}a;a.f=amplitude[2*k+axis];
     if((a.u&0x7f800000u)==0x7f800000u||a.f<0)good=false;
     // Same fixed 4px full scale as the existing HDMI OSD.
     unsigned height=a.f>=4?255u:(a.f>=0?unsigned(a.f*63.75f+.5f):0u);
     if(a.f>4)clipped++;
     bar|=height<<(8*axis);words[2*k+axis]=a.u;
    }
    words[258+k]=bar;
   }
   if(!good)status=3;
   else{
    for(unsigned i=0;i<387;i++){
#pragma HLS PIPELINE II=1
     output[i]=words[i];
    }
    clipped_bins=clipped;
   }
  }
 }else status=1;
 count=used;epoch=generation;last_sequence=last;
}
