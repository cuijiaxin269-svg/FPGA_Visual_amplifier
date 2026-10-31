#include <hls_math.h>
#include "tables.hpp"

// Independent window engine: 256 chronological {dx,dy} float samples, px.
// The caller must provide a complete CRC-valid, contiguous window. Publishing
// at 5Hz does not change the required per-frame displacement sampling rate.
extern "C" void spectrum256(const float *motion, float *amplitude,
                            bool valid_window, unsigned &status) {
#pragma HLS INTERFACE m_axi port=motion offset=slave bundle=input_mem depth=512 max_read_burst_length=64
#pragma HLS INTERFACE m_axi port=amplitude offset=slave bundle=output_mem depth=258 max_write_burst_length=64
#pragma HLS INTERFACE s_axilite port=motion bundle=control
#pragma HLS INTERFACE s_axilite port=amplitude bundle=control
#pragma HLS INTERFACE s_axilite port=valid_window bundle=control
#pragma HLS INTERFACE s_axilite port=status bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
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
