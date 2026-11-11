/* Square display composition. Included only by the capture scheduler.
 * HLS remains full-frame; every job binds the raw frame, output slot and ROI.
 * The capture ring is not lockable: the existing timeout/overwrite guard MUST
 * remain active until this additional AXI master has completed its writes. */
#include "hmi_protocol.h"
#define MAGROI_BASE 0x43c60000u
#define MAGROI_ID 0x524f4931u
#define MAGROI_VIDEO 0x43c30000u
#define ROI_BAND_MAX_MILLIHZ 15000u
typedef struct {
 hmi_roi_config config;
 uint32_t revision,frame;
} motion_roi_record;
static motion_roi_record roi_target,roi_job,roi_slots[3],roi_observed,roi_wait,roi_actual;
static unsigned roi_seen,roi_started,roi_finished,roi_fault,roi_slot_valid;
static unsigned roi_observed_valid,roi_wait_valid,roi_actual_valid;
static uint32_t roi_wait_video,roi_wait_underflows,roi_wait_framing;
static uint32_t roi_observed_underflows,roi_observed_framing;
static uint64_t roi_started_at;
static uint32_t roi_last_us,roi_max_us;
static inline int motion_roi_equal(const hmi_roi_config*a,const hmi_roi_config*b){
 return a->seq==b->seq&&a->x==b->x&&a->y==b->y&&a->size==b->size&&a->enable==b->enable;
}
static inline int motion_roi_valid(const hmi_roi_config*c){
 return c->seq<=65535u&&c->enable<=1u&&c->size&&c->size<=HEIGHT&&
        c->x<=WIDTH-c->size&&c->y<=HEIGHT-c->size;
}
/* Return 1 for a new target, 0 for an idempotent retransmission, -1 for a
 * malformed/stale request. Screen reconnects read back target.seq first. */
static inline int motion_roi_accept(const hmi_roi_config*c){
 if(!motion_roi_valid(c))return -1;
 if(c->enable&&hi_milli>ROI_BAND_MAX_MILLIHZ)return -1;
 if(roi_seen){
  uint32_t delta=(c->seq-roi_target.config.seq)&65535u;
  if(!delta)return motion_roi_equal(c,&roi_target.config)?0:-1;
  if(delta>=32768u)return -1;
 }
 roi_target.config=*c;roi_target.revision++;roi_seen=1;return 1;
}
static void motion_roi_reset_display(void){
 roi_slot_valid=roi_observed_valid=roi_wait_valid=roi_actual_valid=0;
}
static void motion_roi_init(void){
 hmi_roi_config initial={0,512,272,256,0};
 roi_target.config=initial;roi_target.revision=roi_target.frame=0;
 roi_seen=roi_started=roi_finished=roi_fault=0;
 roi_last_us=roi_max_us=0;motion_roi_reset_display();
}
static void motion_roi_begin(void){
 roi_started=roi_finished=roi_fault=0;motion_roi_reset_display();
 roi_last_us=roi_max_us=0;
}
static void motion_roi_job_begin(unsigned frame){
 roi_job=roi_target;roi_job.frame=frame;
 roi_started=roi_finished=roi_fault=0;
 /* Never let metadata for a previous use of this slot escape. */
 roi_slot_valid&=~(1u<<out_slot);
}
/* 0: still owned; 1: all composition writes acknowledged; <0: unusable frame. */
static int motion_roi_service(void){
 if(roi_fault)return -(int)roi_fault;
 if(!motion_done)return 0;
 if(!roi_job.config.enable)return 1;
 // S2MM resets its current-slot field to zero once HALTED. After normal STOP
 // the capture shutdown path has already saved/validated ownership; zero is
 // not evidence that a halted writer is overwriting source slot zero.
 if(!roi_finished&&!(rd(VDMA_BASE+0x34)&1u)&&
    ((rd(VDMA_BASE+0x28)>>24)&31u)==in_slot){
  roi_fault=192;return -192;
 }
 if(!roi_started){
  if(rd(MAGROI_BASE)!=MAGROI_ID||(rd(MAGROI_BASE+4)&1u)){
   roi_fault=190;return -190;
  }
  wr(MAGROI_BASE+0x10,FRAME0+in_slot*FRAME_SPACING);
  wr(MAGROI_BASE+0x14,OUT_BASE+out_slot*FRAME_SPACING);
  wr(MAGROI_BASE+0x18,roi_job.config.x);
  wr(MAGROI_BASE+0x1c,roi_job.config.y);
  wr(MAGROI_BASE+0x20,roi_job.config.size);
  /* Border belongs to the composed frame, never to an unrelated live OSD.
   * It occupies up to two pixels INSIDE the square; outside stays exact raw. */
  wr(MAGROI_BASE+0x24,1u);
  roi_started_at=timer_ticks();roi_started=1;
  wr(MAGROI_BASE+4,1u);return 0;
 }
 if(roi_finished)return 1;
 uint32_t control=rd(MAGROI_BASE+4);
 if(control&1u)return 0;
 if(!(control&2u)||rd(MAGROI_BASE+8)){
  roi_fault=191;return -191;
 }
 roi_finished=1;roi_last_us=(uint32_t)((timer_ticks()-roi_started_at)/400u);
 if(roi_last_us>roi_max_us)roi_max_us=roi_last_us;
 return 1;
}
static void motion_roi_publish(void){
 roi_slots[out_slot]=roi_job;roi_slot_valid|=1u<<out_slot;
}
/* DMA completion alone precedes the last pixels at HDMI. First witness a
 * slot in MM2S, then a subsequent completion, then two renderer frame wraps
 * without underflow/framing errors. Keep the witnessed metadata by value:
 * the DDR slot may have been recycled before this conservative ACK is due. */
static void motion_roi_display_poll(unsigned dma_completed){
 if(!roi_seen)return;
 uint32_t video=rd(MAGROI_VIDEO+0x20);
 uint32_t underflows=rd(MAGROI_VIDEO+0x24),framing=rd(MAGROI_VIDEO+0x28);
 if(roi_wait_valid){
  if(underflows!=roi_wait_underflows||framing!=roi_wait_framing||tm[5]||mailbox.error){
   roi_wait_valid=0;
  }else if((uint32_t)(video-roi_wait_video)>=2u){
   roi_actual=roi_wait;roi_actual_valid=1;roi_wait_valid=0;
  }
 }
 if(!dma_completed)return;
 if(roi_observed_valid&&!roi_wait_valid&&
    underflows==roi_observed_underflows&&framing==roi_observed_framing){
  roi_wait=roi_observed;roi_wait_video=video;
  roi_wait_underflows=underflows;roi_wait_framing=framing;roi_wait_valid=1;
 }
 unsigned active=(rd(DISPLAY+0x28)>>16)&31u;
 roi_observed_valid=active<3u&&(roi_slot_valid&(1u<<active))!=0;
 if(roi_observed_valid){
  roi_observed=roi_slots[active];
  roi_observed_underflows=underflows;roi_observed_framing=framing;
 }
}
