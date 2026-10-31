#include "motion60_clip_playback.h"
static uint32_t readreg(motion_clip_playback*s,unsigned offset){return s->io.read(s->io.context,s->base+offset);}
static void writereg(motion_clip_playback*s,unsigned offset,unsigned value){s->io.write(s->io.context,s->base+offset,value);}
void motion_clip_playback_stop(motion_clip_playback*s){
 if(s->active&&!s->stopping){writereg(s,0,readreg(s,0)&~1u);s->stopping=1;s->stop_started=s->clock(s->io.context);}
}
static int fail(motion_clip_playback*s,unsigned error){if(!s->error)s->error=error;motion_clip_playback_stop(s);return -(int)s->error;}
int motion_clip_playback_start(motion_clip_playback*s,unsigned frames,int processed){
 motion_clip_layout layout;
 if(!s->io.read||!s->io.write||!s->clock||!s->base||s->active||s->stopping||!processed||motion_clip_layout_make(frames,&layout))return -160;
 if(readreg(s,0)&1u)return -160;
 writereg(s,0,4);uint64_t deadline=s->clock(s->io.context)+40000000u;
 while(readreg(s,0)&4u)if(s->clock(s->io.context)>deadline)return -161;
 s->frames=frames;s->raw_base=layout.replay_base;s->slot=0;s->next_frame=3%frames;
 s->current_frame=0;s->transitions=0;s->first_transition=0;s->last_transition=0;s->error=0;
 for(unsigned i=0;i<3;i++)writereg(s,0x5c+4*i,s->raw_base+i*CLIP_PIXELS*2u);
 writereg(s,0x58,CLIP_WIDTH*2u);writereg(s,0x54,CLIP_WIDTH*2u);
 writereg(s,0x28,0);writereg(s,0,0x00011003u);writereg(s,0x50,CLIP_HEIGHT);
 s->active=1;s->changed=s->clock(s->io.context);s->last_poll=s->changed;return 0;
}
int motion_clip_playback_poll(motion_clip_playback*s){
 if(!s->active)return s->error?-(int)s->error:0;
 uint64_t now=s->clock(s->io.context);unsigned status=readreg(s,4);
 if(s->stopping){
  if(status&1u){s->active=0;s->stopping=0;}
  else if(now-s->stop_started>40000000u&&!s->error)s->error=165;
  return s->error?-(int)s->error:0;
 }
 if(status&0x4ff0u)return fail(s,162);
 if(now-s->last_poll>8000000u)return fail(s,163);
 s->last_poll=now;
 unsigned current=(readreg(s,0x28)>>16)&31u;
 if(current>=3)return fail(s,164);
 if(current!=s->slot){
  if(current!=(s->slot+1u)%3u)return fail(s,163);
  // The previous slot is now inactive and will not be used for two boundaries.
  // PG020 Programming Sequence: update address, then VSIZE to commit next boundary.
  writereg(s,0x5c+4*s->slot,s->raw_base+s->next_frame*CLIP_PIXELS*2u);
  writereg(s,0x50,CLIP_HEIGHT);
  s->next_frame=(s->next_frame+1u)%s->frames;s->current_frame=(s->current_frame+1u)%s->frames;
  s->slot=current;s->changed=now;
  if(!s->transitions)s->first_transition=now;
  s->last_transition=now;s->transitions++;
 }else if(now-s->changed>16000000u)return fail(s,163);
 if(status&0x1000u)writereg(s,4,0x1000u);
 return 0;
}
