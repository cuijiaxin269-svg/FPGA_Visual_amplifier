#include "hmi_link.h"
typedef struct{uint8_t bytes[512];unsigned n;} text_buffer;
static void text(text_buffer*b,const char*s){while(*s&&b->n<sizeof(b->bytes))b->bytes[b->n++]=(uint8_t)*s++;}
static void number(text_buffer*b,uint32_t v){char a[10];unsigned n=0;do{a[n++]=(char)('0'+v%10);v/=10;}while(v);while(n&&b->n<sizeof(b->bytes))b->bytes[b->n++]=(uint8_t)a[--n];}
static void end(text_buffer*b){if(b->n+3<=sizeof(b->bytes)){b->bytes[b->n++]=255;b->bytes[b->n++]=255;b->bytes[b->n++]=255;}}
static void assign(text_buffer*b,const char*name,uint32_t v){text(b,name);text(b,"=");number(b,v);end(b);}
static void native(void*c,uint8_t code,uint32_t value){
 hmi_link*l=(hmi_link*)c;
 if(code==0x71){l->last_number=value;l->numeric_replies++;return;}
 if(code==0x66){
  if(!l->awaiting_page)return;
  l->awaiting_page=0;
  if(value>2){l->online=0;l->page=255;return;}
  if(!l->online||(value==1&&l->page!=1)){l->reconnects++;l->values_dirty=1;l->screen_epoch++;l->sync_step=0;}
  if(l->page!=value){l->private_dirty=1;l->private_step=0;}
  l->online=1;l->page=value;
  /* query_deadline encodes the latest bounded query's timestamp. */
  l->last_response=l->query_deadline-300u;
 }else if(code==0x88||code==0x89){
  l->online=0;l->page=255;l->values_dirty=1;l->private_dirty=1;
  l->sync_step=l->private_step=0;l->next_query=0;l->awaiting_page=0;
 }else if(code!=1&&code!=0x65&&code!=0x67&&code!=0x68&&code!=0x70&&code!=0x71&&code!=0x86&&code!=0x87){
  l->native_errors++;l->page=255;l->private_dirty=1;l->private_step=0;l->next_query=0;
 }
}
static void request(void*c,const hmi_request*r){
 hmi_link*l=(hmi_link*)c;
 /* Do not overwrite local edits in response to ordinary touch commands. */
 if(l->request)l->request(l->context,r);
}
void hmi_link_init(hmi_link*l,void*c,hmi_request_fn r,hmi_send_fn s){
 unsigned char*p=(unsigned char*)l;for(size_t i=0;i<sizeof(*l);i++)p[i]=0;
 l->request=r;l->context=c;l->send=s;l->page=255;l->values_dirty=1;l->screen_epoch=1;
 hmi_parser_init(&l->parser,l,request,native);
 for(unsigned i=0;i<HMI_FIELDS;i++)l->sent[i]=~0u;
}
void hmi_link_fault(hmi_link*l){
 hmi_parser_resync(&l->parser);l->transport_faults++;
 l->online=0;l->page=255;l->next_query=0;l->awaiting_page=0;
}
static int send(hmi_link*l,text_buffer*b){return l->send&&l->send(l->context,b->bytes,b->n);}
static void private_values(text_buffer*b,const hmi_device_state*s,unsigned step){
 unsigned view=s->target[HMI_VIEW],a=s->target[HMI_ALPHA];
 switch(step){
 case 0:assign(b,"page0.raw.val",view==0);assign(b,"page0.mag.val",view==1);assign(b,"page0.panel.val",view==2);break;
 case 1:assign(b,"page0.hgain.val",a);assign(b,"page0.p0.val",a==0);assign(b,"page0.p12.val",a==12);assign(b,"page0.p50.val",a==50);break;
 case 2:assign(b,"page0.hexp.val",s->target[HMI_EXPOSURE]);break;
 case 3:assign(b,"page0.run.val",s->running);break;
 }
}
void hmi_link_poll(hmi_link*l,const hmi_device_state*s,uint64_t ms){
 text_buffer b={{0},0};
 if(l->awaiting_page&&ms>=l->query_deadline){l->awaiting_page=0;l->online=0;l->page=255;}
 if(ms>=l->next_query&&!l->awaiting_page){
  text(&b,"sendme");end(&b);
  if(send(l,&b)){l->awaiting_page=1;l->query_deadline=ms+300;l->next_query=ms+500;}
  return;
 }
 if(!l->online||l->page==1)return; /* Wait out the original startup animation. */
 for(unsigned i=0;i<HMI_FIELDS;i++){
  unsigned changed=l->sent[i]!=s->generation[i]||l->last.status[i]!=s->status[i]||l->value_epoch!=l->screen_epoch;
  if(!changed)continue;
  static const char*const statuses[]={"page0.vstatus.txt=\"","page0.astatus.txt=\"","page0.estatus.txt=\"","page0.rstatus.txt=\""};
  static const char*const timers[]={"page0.vack.en","page0.aack.en","page0.eack.en","page0.rack.en"};
  text(&b,statuses[i]);text(&b,hmi_status_text(s->status[i]));text(&b,"\"");end(&b);
  if(i==HMI_RUN)assign(&b,"page0.runreq.val",s->status[i]==HMI_WAIT?s->requested_run:s->running);
  if(i==HMI_VIEW){
   assign(&b,"page0.mode.val",s->target[HMI_VIEW]);
   if(l->page==0)private_values(&b,s,0);
  }
  if(l->page==0){
   if(s->status[i]!=HMI_WAIT)assign(&b,timers[i],0);
   if(i==HMI_RUN&&s->status[i]!=HMI_WAIT)assign(&b,"page0.run.val",s->running);
  }
  if(send(l,&b)){l->sent[i]=s->generation[i];l->last.status[i]=s->status[i];l->last.running=s->running;
   /* A new epoch must refresh all groups once, not repeatedly group zero. */
   if(l->value_epoch!=l->screen_epoch){for(unsigned k=i+1;k<HMI_FIELDS;k++)l->sent[k]=~0u;l->value_epoch=l->screen_epoch;}}
  return;
 }
 /* Full parameter synchronization is only performed on initial/recovered
    connections, and postponed until the user leaves the keypad. */
 if(l->values_dirty&&l->page==0){
  static const char*const names[]={"page0.mode.val","page0.alpha.val","page0.exposure.val"};
  if(l->sync_step<3)assign(&b,names[l->sync_step],s->target[l->sync_step]);
  else private_values(&b,s,l->sync_step-3);
  if(send(l,&b)&&++l->sync_step==7){l->values_dirty=0;l->sync_step=0;l->private_dirty=0;}
  return;
 }
 /* Returning from the keypad: its own page script restores draft controls.
    Only timers and the run button need reconciliation here. */
 if(l->private_dirty&&l->page==0){
  static const char*const timers[]={"page0.vack.en","page0.aack.en","page0.eack.en","page0.rack.en"};
  for(unsigned i=0;i<HMI_FIELDS;i++)if(s->status[i]!=HMI_WAIT)assign(&b,timers[i],0);
  if(s->status[HMI_RUN]!=HMI_WAIT)assign(&b,"page0.run.val",s->running);
  if(send(l,&b))l->private_dirty=0;
 }
}
