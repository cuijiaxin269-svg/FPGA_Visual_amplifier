#include "hmi_protocol.h"
static int same(const char *a,const char *b){while(*a&&*a==*b){a++;b++;}return *a==*b;}
static void parse(hmi_parser *p){
 hmi_request r={HMI_UNKNOWN,0,0};
 char *arg=0;unsigned n=0;
 while(p->line[n]&&p->line[n]!=' ')n++;
 if(p->line[n]){p->line[n]=0;arg=p->line+n+1;}
 if(same(p->line,"VIEW"))r.operation=HMI_SET_VIEW;
 else if(same(p->line,"ALPHA"))r.operation=HMI_SET_ALPHA;
 else if(same(p->line,"EXPOSURE"))r.operation=HMI_SET_EXPOSURE;
 else if(same(p->line,"START"))r.operation=HMI_START;
 else if(same(p->line,"STOP"))r.operation=HMI_STOP;
 if(r.operation==HMI_START||r.operation==HMI_STOP)r.valid=!arg;
 else if(r.operation!=HMI_UNKNOWN&&arg&&*arg){
  r.valid=1;
  for(;*arg;arg++){
   if(*arg<'0'||*arg>'9'||r.value>100000u){r.valid=0;break;}
   r.value=r.value*10u+(unsigned)(*arg-'0');
  }
  unsigned max=r.operation==HMI_SET_VIEW?2u:r.operation==HMI_SET_ALPHA?50u:898u;
  if(r.value>max||(r.operation==HMI_SET_EXPOSURE&&!r.value))r.valid=0;
 }
 if(r.valid)p->commands++;else p->rejected++;
 if(p->request)p->request(p->context,&r);
}
static unsigned packet_size(uint8_t c){
 switch(c){
 case 0x66:return 5;
 case 0x71:return 8;
 case 0x65:return 7;
 case 0x67:case 0x68:return 9;
 case 0x70:return 96; /* Bounded variable-length string; not requested by v1. */
 case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 9:
 case 0x11:case 0x12:case 0x1a:case 0x1b:case 0x1c:case 0x1d:
 case 0x1e:case 0x1f:case 0x20:case 0x23:case 0x24:
 case 0x86:case 0x87:case 0x88:case 0x89:return 4;
 default:return 0;
 }
}
void hmi_parser_init(hmi_parser*p,void*c,hmi_request_fn r,hmi_native_fn n){
 unsigned char *b=(unsigned char*)p;for(size_t i=0;i<sizeof(*p);i++)b[i]=0;
 p->context=c;p->request=r;p->native=n;
}
void hmi_parser_resync(hmi_parser*p){
 p->length=p->cr=p->native_length=p->native_expected=p->ff=0;p->discard=1;
}
void hmi_parser_feed(hmi_parser*p,uint8_t c){
 if(p->discard){
  if((p->cr&&c=='\n')||(c==0xff&&p->ff==2)){p->discard=p->cr=p->ff=0;return;}
  p->cr=c=='\r';p->ff=c==0xff?p->ff+1:0;return;
 }
 if(p->native_length){
  p->packet[p->native_length++]=c;
  p->ff=c==0xff?p->ff+1:0;
  unsigned complete=p->packet[0]==0x70?p->ff==3:p->native_length==p->native_expected;
  if(complete){
   unsigned n=p->native_length;
   if(n>=4&&p->packet[n-1]==0xff&&p->packet[n-2]==0xff&&p->packet[n-3]==0xff){
    uint32_t value=p->packet[0]==0x66?p->packet[1]:0;
    if(p->packet[0]==0x71)value=(uint32_t)p->packet[1]|((uint32_t)p->packet[2]<<8)|((uint32_t)p->packet[3]<<16)|((uint32_t)p->packet[4]<<24);
    p->native_packets++;if(p->native)p->native(p->context,p->packet[0],value);
    p->native_length=p->native_expected=p->ff=0;
   }else{p->corrupt_packets++;hmi_parser_resync(p);}
  }else if(p->native_length==sizeof(p->packet)){p->corrupt_packets++;hmi_parser_resync(p);}
  return;
 }
 if(!p->length&&!p->cr){
  unsigned n=packet_size(c);
  if(n){p->packet[0]=c;p->native_length=1;p->native_expected=n;p->ff=0;return;}
  if(c==0xff)return; /* Tolerate standalone native terminators. */
 }
 if(p->cr){
  p->cr=0;
  if(c=='\n'){
   if(p->length){p->line[p->length]=0;parse(p);}p->length=0;return;
  }
  p->corrupt_packets++;hmi_parser_resync(p);return;
 }
 if(c=='\r'){p->cr=1;return;}
 if(c<' '||c>126){p->corrupt_packets++;hmi_parser_resync(p);return;}
 if(p->length==sizeof(p->line)-1){p->overlong++;hmi_parser_resync(p);return;}
 p->line[p->length++]=(char)c;
}
const char *hmi_status_text(hmi_status s){
 static const char*const text[]={"SET","QUEUED","WAIT ACK","APPLIED","RUNNING","STOPPED","BUSY","REJECTED","ERROR"};
 return (unsigned)s<sizeof(text)/sizeof(text[0])?text[s]:"ERROR";
}
