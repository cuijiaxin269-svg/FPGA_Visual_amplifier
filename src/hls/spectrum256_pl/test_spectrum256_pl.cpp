#include <cmath>
#include <cstdio>
#include <limits>
#include <vector>
extern "C" void spectrum256(const float*,float*,bool,unsigned&);
extern "C" void spectrum256_pl(const float*,unsigned*,unsigned,unsigned,bool,unsigned&,unsigned&,unsigned&,unsigned&,unsigned&);
#define CHECK(x) do{if(!(x)){std::printf("FAIL spectrum PL line %d\n",__LINE__);return 1;}}while(0)
int main(){
 float roi[2]={};unsigned result[388]={};unsigned status,count,epoch,last,clipped;
 auto call=[&](unsigned op,unsigned seq,bool valid=true){spectrum256_pl(roi,result,op,seq,valid,status,count,epoch,last,clipped);};
 result[0]=123;result[387]=0xfeed1234;
 call(0,0);CHECK(!status&&!count);unsigned initial_epoch=epoch;
 call(2,0);CHECK(status==4&&result[0]==123);
 std::vector<float> history;
 for(unsigned i=0;i<300;i++){
  roi[0]=20*std::sin(2*3.141592653589793*17*i/256);
  roi[1]=.75f*std::cos(2*3.141592653589793*39*i/256);
  history.push_back(roi[0]);history.push_back(roi[1]);call(1,i);
  CHECK(!status&&count==(i<255?i+1:256)&&epoch==initial_epoch&&last==i);
 }
 call(2,0);CHECK(!status&&count==256&&last==299&&clipped>0&&result[387]==0xfeed1234);
 float reference[258];unsigned ref_status;spectrum256(history.data()+88,reference,true,ref_status);CHECK(!ref_status);
 for(unsigned k=0;k<129;k++){
  unsigned expected_bar=0;
  for(unsigned axis=0;axis<2;axis++){
   union{float f;unsigned u;}a;a.u=result[2*k+axis];CHECK(a.f==reference[2*k+axis]);
   unsigned h=a.f>=4?255u:unsigned(a.f*63.75f+.5f);expected_bar|=h<<(8*axis);
  }
  CHECK(result[258+k]==expected_bar);
 }
 call(1,301);CHECK(!status&&count==1&&epoch==initial_epoch+1&&last==301);
 call(1,302,false);CHECK(status==2&&!count&&epoch==initial_epoch+2);
 roi[0]=std::numeric_limits<float>::quiet_NaN();call(1,303);CHECK(status==2&&!count);
 roi[0]=257;call(1,304);CHECK(status==2&&!count);
 roi[0]=0;call(1,0xffffffffu);call(1,0);CHECK(!status&&count==2&&last==0);
 call(99,0);CHECK(status==1&&count==2);
 call(0,0);CHECK(!status&&!count&&!last);
 std::puts("PASS PL spectrum ring wrap/order, transform equivalence, packed bars/clipping, gap/invalid reset, sequence wrap");
 return 0;
}
