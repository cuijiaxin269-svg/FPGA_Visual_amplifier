#ifndef MOTION60_CLIP_PLAYBACK_H
#define MOTION60_CLIP_PLAYBACK_H
#include "motion60_clip_driver.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef struct {
 motion_clip_io io;uint64_t (*clock)(void*);
 uint32_t base,frames,raw_base,active,stopping,error,slot,next_frame,current_frame,transitions;
 uint64_t changed,last_poll,first_transition,last_transition,stop_started;
} motion_clip_playback;
int motion_clip_playback_start(motion_clip_playback*,unsigned frames,int processed);
void motion_clip_playback_stop(motion_clip_playback*);
int motion_clip_playback_poll(motion_clip_playback*);
#ifdef __cplusplus
}
#endif
#endif
