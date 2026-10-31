#ifndef MOTION60_CLIP_PL_H
#define MOTION60_CLIP_PL_H
#include "motion60_clip_driver.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef struct {
 motion_clip_io io;
 uint64_t (*clock)(void*);
 int (*progress)(void*,unsigned stage,unsigned level,unsigned done,unsigned total);
 void *progress_context;
 uint32_t spatial_base,temporal_base,copy_base;
 uint32_t busy,error,active_base,active_status,completed,max_us;
 uint64_t started;
} motion_clip_pl;
// No pixel pointers are dereferenced by this driver. Every transfer is PL AXI.
// Caller must first drain capture/display/ROI and revoke clip readiness.
int motion_clip_pl_run(motion_clip_pl*,unsigned frames,double fps,double low,double high,float alpha);
// After timeout the active master still owns memory. Poll until busy clears;
// error remains latched and the partially processed clip must not be played.
int motion_clip_pl_poll(motion_clip_pl*);
#ifdef __cplusplus
}
#endif
#endif
