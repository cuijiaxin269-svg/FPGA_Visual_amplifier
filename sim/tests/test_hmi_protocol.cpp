#include "../../src/ps/hmi_link.h"
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>
#define REQUIRE(x) do{if(!(x)){std::printf("FAIL protocol line %d: %s\n",__LINE__,#x);return 1;}}while(0)
static std::vector<hmi_request> requests;
static std::vector<hmi_roi_request> roi_requests;
static std::vector<std::pair<unsigned,uint32_t>> packets;
static std::vector<std::string> sent;
static bool writable=true;
static void request(void*,const hmi_request*r){requests.push_back(*r);}
static void roi_request(void*c,const hmi_roi_request*r){if(c)(*(unsigned*)c)++;roi_requests.push_back(*r);}
static void native(void*,uint8_t c,uint32_t v){packets.push_back({c,v});}
static int send(void*,const uint8_t*p,size_t n){if(!writable)return 0;sent.emplace_back((const char*)p,n);return 1;}
static void feed(hmi_parser&p,const std::string&s){for(unsigned char c:s)hmi_parser_feed(&p,c);}
static std::string page(unsigned n){return std::string("\x66",1)+char(n)+std::string("\xff\xff\xff",3);}
static int test_roi(){
 hmi_parser p;unsigned callback_count=0;
 hmi_parser_init(&p,&callback_count,request,native);hmi_parser_set_roi_handler(&p,roi_request);
 size_t old_requests=requests.size();
 feed(p,"MAGROI 42 512 272 256 1\r");REQUIRE(roi_requests.empty());feed(p,"\n");
 REQUIRE(roi_requests.size()==1&&roi_requests.back().valid&&callback_count==1);
 const hmi_roi_config &first=roi_requests.back().config;
 REQUIRE(first.seq==42&&first.x==512&&first.y==272&&first.size==256&&first.enable==1);
 for(const char*s:{"MAGROI 0 0 0 1 0","MAGROI 65535 1279 799 1 1","MAGROI 1 480 0 800 1","MAGROI 2 1024 544 256 0","MAGROI 0003 0000 0000 0001 1"}){
  feed(p,std::string(s)+"\r\n");REQUIRE(roi_requests.back().valid);
 }
 REQUIRE(p.commands==6&&requests.size()==old_requests);
 for(const char*s:{"MAGROI","MAGROI ","MAGROI 1 0 0 1","MAGROI 1 0 0 1 1 2","MAGROI 1 0 0 1 1 ","MAGROI  1 0 0 1 1","MAGROI 1  0 0 1 1","MAGROI -1 0 0 1 1","MAGROI +1 0 0 1 1","MAGROI 1 0.0 0 1 1","MAGROI 65536 0 0 1 1","MAGROI 1 1280 0 1 1","MAGROI 1 0 800 1 1","MAGROI 1 0 0 0 1","MAGROI 1 0 0 801 1","MAGROI 1 0 0 1 2","MAGROI 1 1025 544 256 1","MAGROI 1 1024 545 256 0","MAGROI 1 481 0 800 1","MAGROI 42949672960 0 0 1 1","MAGROI 1 0 0 4294967296 1"}){
  size_t before=roi_requests.size();feed(p,std::string(s)+"\r\n");REQUIRE(roi_requests.size()==before+1&&!roi_requests.back().valid);
 }
 size_t before=roi_requests.size();feed(p,"MAGROI 9 0 0 ");hmi_parser_resync(&p);
 feed(p,"1 1\r\nMAGROI 10 0 0 1 1\r\n");REQUIRE(roi_requests.size()==before+1&&roi_requests.back().config.seq==10);
 before=roi_requests.size();feed(p,"MAGROI "+std::string(120,'9')+"\r\nMAGROI 11 0 0 1 1\r\n");
 REQUIRE(p.overlong==1&&roi_requests.size()==before+1&&roi_requests.back().config.seq==11);
 feed(p,page(0)+"MAGROI 12 0 0 1 1\r\nALPHA 12\r\n");REQUIRE(roi_requests.back().config.seq==12&&requests.back().value==12);
 REQUIRE(requests.size()==old_requests+1);

 hmi_link l;hmi_device_state state={};hmi_link_init(&l,&callback_count,request,send);hmi_link_set_roi_handler(&l,roi_request);
 sent.clear();writable=true;hmi_link_poll(&l,&state,0);feed(l.parser,page(0));
 for(unsigned i=1;i<30;i++)hmi_link_poll(&l,&state,i);
 for(const auto&s:sent)REQUIRE(s.find("page0.roi_")==std::string::npos);
 /* An invalid ROI must not enable new fields on a legacy screen. */
 feed(l.parser,"MAGROI 20 0 0 0 1\r\n");sent.clear();hmi_link_poll(&l,&state,30);REQUIRE(sent.empty());
 unsigned count=callback_count;feed(l.parser,"MAGROI 20 0 0 256 1\r\n");
 REQUIRE(callback_count==count+1&&roi_requests.back().valid);
 state.roi.seen=1;state.roi.target={20,0,0,256,1};state.roi.actual={19,512,272,256,1};
 state.roi.applied_valid=1;state.roi.status=HMI_APPLIED;state.roi.generation=1;
 writable=false;hmi_link_poll(&l,&state,31);REQUIRE(sent.empty()&&!l.roi_sent_valid);
 state.roi.target={21,1024,544,256,1};state.roi.status=HMI_QUEUED;state.roi.generation++;
 writable=true;hmi_link_poll(&l,&state,32);REQUIRE(sent.size()==1&&l.roi_sent_valid);
 REQUIRE(sent[0].find("page0.roi_seq.val=21")!=std::string::npos&&sent[0].find("page0.roi_aseq.val=19")!=std::string::npos);
 REQUIRE(sent[0].find("page0.roi_x.val=1024")!=std::string::npos&&sent[0].find("page0.roi_ax.val=512")!=std::string::npos);
 REQUIRE(sent[0].find("page0.roi_valid.val=1")!=std::string::npos&&sent[0].find("QUEUED")!=std::string::npos&&sent[0].find("APPLIED")==std::string::npos);
 REQUIRE(sent[0].size()<=512&&sent[0].substr(sent[0].size()-3)==std::string("\xff\xff\xff",3));
 sent.clear();for(unsigned i=33;i<50;i++)hmi_link_poll(&l,&state,i);REQUIRE(sent.empty());
 /* Keypad editing never receives a ROI feedback batch. */
 hmi_link_poll(&l,&state,500);feed(l.parser,page(2));sent.clear();state.roi.generation++;
 for(unsigned i=501;i<520;i++)hmi_link_poll(&l,&state,i);
 for(const auto&s:sent)REQUIRE(s.find("page0.roi_")==std::string::npos);
 hmi_link_poll(&l,&state,1000);feed(l.parser,page(0));sent.clear();hmi_link_poll(&l,&state,1001);
 REQUIRE(sent.size()==1&&sent[0].find("page0.roi_seq.val=21")!=std::string::npos);
 /* Reconnect refreshes feedback even when the application generation is unchanged. */
 hmi_link_fault(&l);feed(l.parser,"\r\n");hmi_link_poll(&l,&state,1010);feed(l.parser,page(0));sent.clear();
 for(unsigned i=1011;i<1030;i++)hmi_link_poll(&l,&state,i);
 bool refreshed=false;for(const auto&s:sent)if(s.find("page0.roi_seq.val=21")!=std::string::npos)refreshed=true;
 REQUIRE(refreshed);
 return 0;
}
int main(){
 hmi_parser p;hmi_parser_init(&p,0,request,native);
 feed(p,"VIEW 2\r");REQUIRE(requests.empty());feed(p,"\nALPHA 50\r\nEXPOSURE 898\r\nSTART\r\nSTOP\r\n");
 REQUIRE(requests.size()==5&&p.commands==5&&requests[1].value==50&&requests[4].operation==HMI_STOP);
 for(const char*s:{"ALPHA -1","ALPHA 51","ALPHA 1.0","ALPHA 1 2","ALPHA  1","ALPHA 1 ","VIEW 3","EXPOSURE 0","EXPOSURE 899","START 1","STOP 0","alpha 3","ALPHA 99999999999999"}){
  feed(p,std::string(s)+"\r\n");REQUIRE(!requests.back().valid);
 }
 for(const char*s:{"ALPHA 0","ALPHA 12","ALPHA 30","ALPHA 31","ALPHA 50","EXPOSURE 1","EXPOSURE 320","EXPOSURE 898","VIEW 0","VIEW 1","VIEW 2"}){
  feed(p,std::string(s)+"\r\n");REQUIRE(requests.back().valid);
 }
 size_t before=requests.size();feed(p,"START\nSTOP\r\nVIEW 0\r\n");REQUIRE(requests.size()==before+1&&requests.back().operation==HMI_SET_VIEW);
 feed(p,std::string(120,'A')+"START\r\nSTOP\r\n");REQUIRE(p.overlong==1&&requests.back().operation==HMI_STOP);
 /* Numeric payload contains three FF bytes; length must win over delimiter. */
 feed(p,std::string("\x71\xff\xff\xff\x7f\xff\xff\xff",8)+page(2)+std::string("\x1a\xff\xff\xff",4)+"ALPHA 31\r\n");
 REQUIRE(packets.size()==3&&packets[0].second==0x7fffffffu&&packets[1].second==2&&requests.back().value==31);
 feed(p,std::string("\x66\x00\xff\xff\x00",5)+"\r\nSTART\r\n");REQUIRE(requests.back().operation==HMI_START&&p.corrupt_packets);
 before=requests.size();feed(p,"STA");hmi_parser_resync(&p);feed(p,"RT\r\nSTOP\r\n");REQUIRE(requests.size()==before+1&&requests.back().operation==HMI_STOP);
 hmi_link l;hmi_link_init(&l,0,request,send);hmi_device_state state={};
 feed(l.parser,std::string("\x71\xff\xff\xff\x7f\xff\xff\xff",8));
 REQUIRE(l.numeric_replies==1&&l.last_number==0x7fffffffu);
 for(unsigned i=0;i<4;i++){state.generation[i]=1;state.status[i]=HMI_QUEUED;}
 state.target[0]=2;state.target[1]=12;state.target[2]=320;state.status[3]=HMI_STOPPED;
 hmi_link_poll(&l,&state,0);REQUIRE(sent.back()==std::string("sendme\xff\xff\xff",9));
 feed(l.parser,page(2));
 for(unsigned i=1;i<15;i++)hmi_link_poll(&l,&state,i);
 for(const auto&s:sent)REQUIRE(s.find(".en=")==std::string::npos&&s.find("page0.run.val")==std::string::npos&&s.find("page0.hgain.val")==std::string::npos);
 REQUIRE(l.values_dirty); /* Keypad draft is not overwritten. */
 hmi_link_poll(&l,&state,500);feed(l.parser,page(0));
 for(unsigned i=501;i<530;i++)hmi_link_poll(&l,&state,i);
 REQUIRE(!l.values_dirty);bool slider=false;
 for(const auto&s:sent){REQUIRE(s.size()>=3&&s.substr(s.size()-3)==std::string("\xff\xff\xff",3));if(s.find("page0.hgain.val=12")!=std::string::npos)slider=true;}
 REQUIRE(slider);
 sent.clear();writable=false;state.status[1]=HMI_APPLIED;state.generation[1]++;
 hmi_link_poll(&l,&state,540);state.status[1]=HMI_WAIT;state.generation[1]++;
 writable=true;hmi_link_poll(&l,&state,541);REQUIRE(sent.size()==1&&sent[0].find("WAIT ACK")!=std::string::npos&&sent[0].find("APPLIED")==std::string::npos);
 /* Ordinary polling cannot overwrite an unsubmitted local exposure. */
 sent.clear();for(unsigned i=550;i<580;i++)hmi_link_poll(&l,&state,i);REQUIRE(sent.empty());
 hmi_link_poll(&l,&state,1000);hmi_link_poll(&l,&state,1301);REQUIRE(!l.online);
 hmi_link_poll(&l,&state,1500);feed(l.parser,page(0));REQUIRE(l.values_dirty);
 feed(l.parser,std::string("\x88\xff\xff\xff",4));REQUIRE(!l.online&&l.page==255);
 REQUIRE(test_roi()==0);
 std::puts("HMI_PROTOCOL_LINK_PASSED strict_crlf ranges fragmentation binary_ff overflow resync keypad stale_results reconnect magroi_ranges magroi_atomic_feedback legacy_screen_compatibility");return 0;
}
