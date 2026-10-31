#include <ap_int.h>
// One exact 1280x800 u16 frame, no filtering or bit-depth conversion.
// Caller owns disjoint, 16-byte aligned source/destination buffers and retains
// the source until completion. A later CRC/sequence fault invalidates the clip.
extern "C" void clip_copy_checked(const ap_uint<128> *source, ap_uint<128> *destination,
                          bool valid_source, unsigned &status){
#pragma HLS INTERFACE m_axi port=source offset=slave bundle=input_mem depth=128000 max_read_burst_length=128 num_read_outstanding=2
#pragma HLS INTERFACE m_axi port=destination offset=slave bundle=output_mem depth=128000 max_write_burst_length=128 num_write_outstanding=2
#pragma HLS INTERFACE s_axilite port=source bundle=control
#pragma HLS INTERFACE s_axilite port=destination bundle=control
#pragma HLS INTERFACE s_axilite port=valid_source bundle=control
#pragma HLS INTERFACE s_axilite port=status bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
 status=1;if(!valid_source)return;
 ap_uint<128> block[128];
 bool invalid_pixel=false;
#pragma HLS BIND_STORAGE variable=block type=ram_2p impl=bram
 for(unsigned base=0;base<128000;base+=128){
  for(unsigned i=0;i<128;i++){
#pragma HLS PIPELINE II=1
   block[i]=source[base+i];
   for(unsigned lane=0;lane<8;lane++){
#pragma HLS UNROLL
    if(block[i].range(lane*16+15,lane*16+10)!=0)invalid_pixel=true;
   }
  }
  for(unsigned i=0;i<128;i++){
#pragma HLS PIPELINE II=1
   destination[base+i]=block[i];
  }
 }
 // Destination is never publishable on error; source bits are not repaired.
 status=invalid_pixel?2:0;
}
