#include "phase_core.hpp"
#include <hls_math.h>
static float from_bits(ap_uint<32> v){union{unsigned u;float f;}x;x.u=v.to_uint();return x.f;}
static ap_uint<32> to_bits(float v){union{unsigned u;float f;}x;x.f=v;return x.u;}

// Dense DDR layout: four 96-bit states occupy three 128-bit AXI words.
// The internal compute stream retains its existing 128-bit representation.
static void read_words(const PhaseWord* state, hls::stream<PhaseWord>& words, unsigned count,unsigned mode) {
#pragma HLS INLINE off
 for(unsigned i=0;i<((mode?1:3)*count+3)/4;i++) {
#pragma HLS PIPELINE II=1
  words.write(mode==1?PhaseWord(0):state[i]);
 }
}
static void write_words(hls::stream<PhaseWord>& words, PhaseWord* state, unsigned count,unsigned mode) {
#pragma HLS INLINE off
 for(unsigned i=0;i<((mode?1:3)*count+3)/4;i++) {
#pragma HLS PIPELINE II=1
  PhaseWord value=words.read();if(mode!=2)state[i]=value;
 }
}
static void unpack_history(hls::stream<PhaseWord>& words,hls::stream<PhaseWord>& history,unsigned count,unsigned mode){
#pragma HLS INLINE off
 for(unsigned i=0;i<count;i+=4){
#pragma HLS PIPELINE II=4
  unsigned n=count-i<4?count-i:4;
  ap_uint<384> group=0;
  for(unsigned j=0;j<3;j++){
#pragma HLS UNROLL
   if(j<((mode?1:3)*n+3)/4)group.range(128*j+127,128*j)=words.read();
  }
  for(unsigned j=0;j<4;j++){
#pragma HLS UNROLL
   if(j<n){PhaseWord value=0;if(mode)value.range(31,0)=group.range(32*j+31,32*j);else value.range(95,0)=group.range(96*j+95,96*j);history.write(value);}
  }
 }
}
static void pack_history(hls::stream<PhaseWord>& updated,hls::stream<PhaseWord>& words,unsigned count,unsigned mode){
#pragma HLS INLINE off
 for(unsigned i=0;i<count;i+=4){
#pragma HLS PIPELINE II=4
  unsigned n=count-i<4?count-i:4;
  ap_uint<384> group=0;
  for(unsigned j=0;j<4;j++){
#pragma HLS UNROLL
   if(j<n){PhaseWord value=updated.read();if(mode)group.range(32*j+31,32*j)=value.range(31,0);else group.range(96*j+95,96*j)=value.range(95,0);}
  }
  for(unsigned j=0;j<3;j++){
#pragma HLS UNROLL
   if(j<((mode?1:3)*n+3)/4)words.write(group.range(128*j+127,128*j));
  }
 }
}
static void compute_phase(hls::stream<PhaseInput>& input,hls::stream<float>& output,
 hls::stream<PhaseWord>& history,hls::stream<PhaseWord>& updated,unsigned count,
 float b0,float b2,float a1,float a2,float alpha,bool first_frame,unsigned mode) {
#pragma HLS INLINE off
    phase_pixels: for (unsigned i=0; i<count; ++i) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_TRIPCOUNT min=64000 max=1344000
        PhaseInput p = input.read();
        float r = hls::sqrtf(p.rx*p.rx + p.ry*p.ry) + 1.0e-6f;
        float phi = hls::atan2f(p.band, r);
        // Integer packed accesses permit AXI burst inference. Keep reads regular
        // even on frame zero; uninitialized history bits never enter arithmetic.
        PhaseWord old=history.read();
        PhaseState s = first_frame ? PhaseState{phi, 0, 0, 0} :
            PhaseState{from_bits(old.range(31,0)),from_bits(old.range(63,32)),from_bits(old.range(95,64)),0};
        float x = phi-s.phi0;
        float y = b0*x+s.z1;
        s.z1 = -a1*y+s.z2;
        s.z2 = b2*x-a2*y;
        PhaseWord next=0;
        next.range(31,0)=to_bits(s.phi0);next.range(63,32)=to_bits(s.z1);next.range(95,64)=to_bits(s.z2);
        if(mode==1)next.range(31,0)=to_bits(phi);
        // Packed single-float phase shares the existing history AXI ports.
        if(mode==2)next=old;
        float angle = alpha*(mode==2?from_bits(old.range(31,0)):y);
        updated.write(next);
        output.write(mode==1?p.band:p.band*hls::cosf(angle) + r*hls::sinf(angle));
    }
}
static void phase_dataflow(hls::stream<PhaseInput>& input,hls::stream<float>& output,
 PhaseWord* state,unsigned count,float b0,float b2,float a1,float a2,float alpha,bool first_frame,unsigned mode) {
#pragma HLS DATAFLOW
 hls::stream<PhaseWord> history,updated,read_bus,write_bus;
#pragma HLS STREAM variable=history depth=128
#pragma HLS STREAM variable=updated depth=128
#pragma HLS STREAM variable=read_bus depth=128
#pragma HLS STREAM variable=write_bus depth=128
 // Each write depends on that pixel's completed read through both FIFOs.
 // Sequential indices do not alias across pixels. No frame overlap is allowed.
 read_words(state,read_bus,count,mode);
 unpack_history(read_bus,history,count,mode);
 compute_phase(input,output,history,updated,count,b0,b2,a1,a2,alpha,first_frame,mode);
 pack_history(updated,write_bus,count,mode);
 write_words(write_bus,state,count,mode);
}

// Source phase atan2(B, sqrt(Rx^2+Ry^2)+epsilon) is in [-pi/2, pi/2].
// With positive R, it cannot cross the +/-pi unwrap cut, so retaining phi0
// is sufficient. This relies on preserving the original phase definition.
// Transposed direct form II reduces four IIR history values to two.
void phase_core_shared(hls::stream<PhaseInput>& input, hls::stream<float>& output,
                PhaseWord* state, unsigned count, float b0, float b2,
                float a1, float a2, float alpha, bool first_frame,
                bool valid_frame, unsigned& status,unsigned mode) {
#pragma HLS INTERFACE axis port=input
#pragma HLS INTERFACE axis port=output
#pragma HLS INTERFACE m_axi port=state offset=slave bundle=history depth=1344000 max_read_burst_length=64 max_write_burst_length=64 num_read_outstanding=16 num_write_outstanding=16
#pragma HLS INTERFACE s_axilite port=state bundle=control
#pragma HLS INTERFACE s_axilite port=count bundle=control
#pragma HLS INTERFACE s_axilite port=b0 bundle=control
#pragma HLS INTERFACE s_axilite port=b2 bundle=control
#pragma HLS INTERFACE s_axilite port=a1 bundle=control
#pragma HLS INTERFACE s_axilite port=a2 bundle=control
#pragma HLS INTERFACE s_axilite port=alpha bundle=control
#pragma HLS INTERFACE s_axilite port=first_frame bundle=control
#pragma HLS INTERFACE s_axilite port=valid_frame bundle=control
#pragma HLS INTERFACE s_axilite port=status bundle=control
#pragma HLS INTERFACE s_axilite port=mode bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
    status = 0;
    if(mode>2){status=4;return;}
    // The dispatcher must validate CRC/completeness before starting a producer.
    // Rejection consumes no pixels and writes no temporal state.
    if (!valid_frame) { status = 1; return; }
    if (count == 0 || count > 1344000) { status = 2; return; }
    if (!(alpha >= 0 && alpha <= 30)) { status = 3; return; }
    phase_dataflow(input,output,state,count,b0,b2,a1,a2,alpha,first_frame,mode);
}
