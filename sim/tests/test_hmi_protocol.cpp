#include "../../src/ps/hmi_link.h"
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>
#define REQUIRE(x) do{if(!(x)){std::printf("FAIL protocol line %d: %s\n",__LINE__,#x);return 1;}}while(0)
static std::vector<hmi_request> requests;
static std::vector<std::pair<unsigned,uint32_t>> packets;
static std::vector<std::string> sent;
static bool writable=true;
static void request(void*,const hmi_request*r){requests.push_back(*r);}
static void native(void*,uint8_t c,uint32_t v){packets.push_back({c,v});}
static int send(void*,const uint8_t*p,size_t n){if(!writable)return 0;sent.emplace_back((const char*)p,n);return 1;}
static void feed(hmi_parser&p,const std::string&s){for(unsigned char c:s)hmi_parser_feed(&p,c);}
static std::string page(unsigned n){return std::string("\x66",1)+char(n)+std::string("\xff\xff\xff",3);}
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
 std::puts("HMI_PROTOCOL_LINK_PASSED strict_crlf ranges fragmentation binary_ff overflow resync keypad stale_results reconnect");return 0;
}
