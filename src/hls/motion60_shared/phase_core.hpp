#pragma once
#include <ap_int.h>
#include <hls_stream.h>

// Three float operands from the spatial stage. State is external and persistent.
struct PhaseInput { float band, rx, ry; };
struct PhaseState { float phi0, z1, z2, reserved; };
typedef ap_uint<128> PhaseWord;
// DDR stores ceil(3*count/4) PhaseWords: four {phi0,z1,z2} states per three words.
// The compute FIFO uses one PhaseWord per pixel; its upper 32 bits are zero.
void phase_core_shared(hls::stream<PhaseInput>& input, hls::stream<float>& output,
                PhaseWord* state, unsigned count, float b0, float b2,
                float a1, float a2, float alpha, bool first_frame,
                bool valid_frame, unsigned& status,unsigned mode);

// mode 0: causal dense history; 1: emit packed phase; 2: read packed filtered phase.
