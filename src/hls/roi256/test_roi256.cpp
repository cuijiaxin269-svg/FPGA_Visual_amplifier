#include <cstdio>
#include <cmath>
#include <string>
#include <vector>
#include <stdint.h>
extern "C" void roi256(const uint16_t*,float*,unsigned,unsigned,bool,bool,unsigned&);
int main(int argc,char**argv){
    if(argc!=2)return 1;
    std::string dir=argv[1];std::vector<uint16_t>frame(1024000);
    float expected[16],out[6];unsigned status;float maximum=0;
    FILE*f=std::fopen((dir+"/expected.bin").c_str(),"rb");if(!f)return 2;
    size_t n=std::fread(expected,sizeof(float),16,f);std::fclose(f);if(n!=16)return 3;
    for(unsigned t=0;t<4;t++){
        f=std::fopen((dir+"/input"+std::to_string(t)+".bin").c_str(),"rb");if(!f)return 4;
        n=std::fread(frame.data(),sizeof(uint16_t),1024000,f);std::fclose(f);if(n!=1024000)return 5;
        for(float&v:out)v=-9999;
        roi256(frame.data(),out+1,512,272,t==0,true,status);
        if(status||out[0]!=-9999||out[5]!=-9999)return 6;
        for(int j=0;j<4;j++){
            float error=std::fabs(out[j+1]-expected[t*4+j]);
            if(j<2&&error>maximum)maximum=error;
            float limit=j==3?.05f:.002f;
            if(!std::isfinite(out[j+1])||error>limit){std::printf("FAIL frame=%u field=%d actual=%g expected=%g error=%g\n",t,j,out[j+1],expected[t*4+j],error);return 7;}
        }
    }
    for(float&v:out)v=-9999;
    roi256(frame.data(),out+1,512,272,false,false,status);if(status!=1)return 8;
    for(float v:out)if(v!=-9999)return 9;
    roi256(frame.data(),out+1,512,272,false,true,status);
    if(status||std::fabs(out[1])>.0001f||std::fabs(out[2])>.0001f)return 10;
    for(float&v:out)v=-9999;
    roi256(frame.data(),out+1,1025,272,false,true,status);if(status!=2)return 11;
    for(float v:out)if(v!=-9999)return 12;
    for(auto&v:frame)v=511;
    roi256(frame.data(),out+1,512,272,true,true,status);if(status!=3)return 13;
    for(float v:out)if(v!=-9999)return 14;
    frame[272*1280+512]=65535;
    roi256(frame.data(),out+1,512,272,true,true,status);if(status!=4)return 15;
    for(float v:out)if(v!=-9999)return 16;
    std::printf("ROI256_PASS maximum_displacement_error_px=%g invalid_and_low_texture_preserve_output=1\n",maximum);
    return 0;
}
