static int display_poll(motion_spectrum_driver*s,uint64_t now){
 if(s->awaiting_display){
  if(read32(s,SPECTRUM_OSD_BASE+0x14)==s->expected_display){
   s->awaiting_display=0;s->displayed_enable=s->submitted_enable;s->display_generation++;
  }
  else if(now-s->display_started>40000000u)return fail(s,130);
  else return 0;
 }
 // Abort an incomplete upload after a gap. Refill all bins before committing.
 if(s->uploading&&s->upload_epoch!=s->window.epoch){s->uploading=0;s->dirty=1;}
 if(!s->uploading&&s->dirty&&(read32(s,SPECTRUM_OSD_BASE+4)&1u)){
  s->upload_position=0;s->upload_state=s->state;s->upload_epoch=s->window.epoch;
  for(unsigned i=0;i<256;i++)s->upload[i]=s->state==1?s->ui.words[i]:0;
  s->uploading=1;s->dirty=0;
 }
 if(s->uploading){
  if(!(read32(s,SPECTRUM_OSD_BASE+4)&1u))return fail(s,131);
  // Bound CPU work per poll; motion completion polling must stay responsive.
  for(unsigned n=0;n<4&&s->upload_position<256;n++){
   unsigned i=s->upload_position++;
   write32(s,SPECTRUM_OSD_BASE+8,i|((uint32_t)s->upload[i]<<8));
  }
  if(s->upload_position==256){
   s->expected_display=read32(s,SPECTRUM_OSD_BASE+0x14)+1u;
   s->submitted_enable=s->enable;
   write32(s,SPECTRUM_OSD_BASE+12,(s->upload_state<<1)|s->submitted_enable);
   s->awaiting_display=1;s->display_started=now;s->uploading=0;
  }
 }
 return 0;
}
