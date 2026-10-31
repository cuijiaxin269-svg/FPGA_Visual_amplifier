#define main original_temporal_test
#include "test_temporal.cpp"
#undef main
double kernel_cos(unsigned,unsigned,unsigned);
int main(){
 double maximum=0;
 for(unsigned n=30;n<=120;n++)for(unsigned k=1;k<=n/2;k++)for(unsigned lag=0;lag<n;lag++){
  double expected=std::cos(2*3.14159265358979323846*double(k)*double(lag)/double(n));
  maximum=std::fmax(maximum,std::fabs(kernel_cos(k,lag,n)-expected));
 }
 std::printf("Kernel cosine all N=30..120 max_error=%.12g\n",maximum);
 if(maximum>1e-12)return 9;
 return original_temporal_test();
}
