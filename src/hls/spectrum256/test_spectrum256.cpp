#include <cstdio>
#include <cmath>
#include <limits>
#include <string>
extern "C" void spectrum256(const float*,float*,bool,unsigned&);
int main(int argc,char**argv){
    if(argc!=2)return 2;
    float input[512],reference[258],out[260];unsigned status;
    std::string root=argv[1];float maximum=0;
    for(int test=0;test<4;test++){
        std::string prefix=root+"/case"+std::to_string(test);
        FILE*f=std::fopen((prefix+"_input.bin").c_str(),"rb");
        if(!f)return 3;
        size_t count=std::fread(input,sizeof(float),512,f);std::fclose(f);if(count!=512)return 4;
        f=std::fopen((prefix+"_expected.bin").c_str(),"rb");if(!f)return 5;
        count=std::fread(reference,sizeof(float),258,f);std::fclose(f);if(count!=258)return 6;
        for(float&v:out)v=-1234;
        spectrum256(input,out+1,true,status);
        if(status||out[0]!=-1234||out[259]!=-1234)return 7;
        for(int i=0;i<258;i++){
            float error=std::fabs(out[i+1]-reference[i]);
            if(!std::isfinite(out[i+1])||error>0.0001f){std::printf("FAIL case=%d bin=%d error=%g\n",test,i,error);return 8;}
            if(error>maximum)maximum=error;
        }
    }
    for(float&v:out)v=-1234;
    spectrum256(input,out+1,false,status);if(status!=1)return 9;
    for(float v:out)if(v!=-1234)return 10;
    input[37]=std::numeric_limits<float>::quiet_NaN();
    spectrum256(input,out+1,true,status);if(status!=2)return 11;
    for(float v:out)if(v!=-1234)return 12;
    std::printf("SPECTRUM256_PASS max_amplitude_error_px=%g invalid_preserves_output=1\n",maximum);
    return 0;
}
