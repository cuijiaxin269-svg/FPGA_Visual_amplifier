#include <ap_int.h>
#include <cstdio>
#include <vector>
extern "C" void clip_copy(const ap_uint<128>*,ap_uint<128>*,bool,unsigned&);
int main(){
 std::vector<ap_uint<128>> input(128002),output(128002);
 ap_uint<128> guard=~ap_uint<128>(0);unsigned status=0;
 for(unsigned i=0;i<128002;i++){input[i]=guard;output[i]=guard;}
 unsigned random=7100;
 for(unsigned i=0;i<128000;i++){
  ap_uint<128> value=0;
  for(unsigned p=0;p<8;p++){
   random^=random<<13;random^=random>>17;random^=random<<5;
   value.range(p*16+15,p*16)=random&1023u;
  }
  input[i+1]=value;
 }
 clip_copy(input.data()+1,output.data()+1,false,status);
 if(status!=1)return 1;
 for(auto value:output)if(value!=guard)return 2;
 clip_copy(input.data()+1,output.data()+1,true,status);
 if(status)return 3;
 if(output[0]!=guard||output[128001]!=guard)return 4;
 for(unsigned i=0;i<128000;i++)if(output[i+1]!=input[i+1])return 5;
 for(unsigned i=1;i<=128000;i++)input[i]=0;
 clip_copy(input.data()+1,output.data()+1,true,status);
 if(status||output[0]!=guard||output[128001]!=guard)return 6;
 for(unsigned i=1;i<=128000;i++)if(output[i]!=0)return 7;
 std::printf("PASS clip copy full 1280x800 RAW10/u16 random+black; bounds; invalid unchanged\n");
 return 0;
}
