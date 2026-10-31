#define clip_copy clip_copy_checked
#define main legacy_copy_test
#include "../clip_copy/test_clip_copy.cpp"
#undef main
int main(){
 int e=legacy_copy_test();if(e)return e;
 std::vector<ap_uint<128>> source(128000),dest(128000);unsigned status;
 // First/last sample and every packed lane must retain the upper-bit check.
 for(unsigned lane=0;lane<8;lane++){
  unsigned at=lane&1?127999:0;source[at]=0;source[at].range(16*lane+15,16*lane)=1024;
  clip_copy_checked(source.data(),dest.data(),true,status);
  if(status!=2||dest[at]!=source[at])return 8;
  source[at]=0;
 }
 clip_copy_checked(source.data(),dest.data(),true,status);if(status)return 9;
 std::puts("PASS checked copy: RAW10 upper-bit faults all eight lanes, first/last words, recovery, no repair");
 return 0;
}
