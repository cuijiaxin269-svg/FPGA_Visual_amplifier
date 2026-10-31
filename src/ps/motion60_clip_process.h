#ifndef MOTION60_CLIP_PROCESS_H
#define MOTION60_CLIP_PROCESS_H
#include "motion60_clip_spatial.h"
#include "motion60_clip_layout.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef int (*motion_clip_filter)(void*,const float*,const float*,float*,unsigned,unsigned);
typedef int (*motion_clip_progress)(void*,unsigned stage,unsigned level,unsigned done,unsigned total);
typedef struct {
 motion_clip_spatial spatial;
 float *phase[3]; // chronological full planes per level
 float *tile_in,*tile_out,*kernel; // 120*64, 120*64, 120 floats
 void *context;
 motion_clip_filter filter; // synchronous completion, output immutable until returned
 motion_clip_progress progress; // optional; nonzero cancels at a safe boundary
} motion_clip_processor;
// Bind full-resolution processor buffers to the reviewed PS DDR layout.
// Only sets addresses; caller must drain all live masters before dereferencing.
int motion_clip_processor_bind(unsigned frames,motion_clip_processor*);
// Replaces raw only after complete phase generation/filtering. Any error means
// no playable clip; cancellation during reconstruction requires new recording.
int motion_clip_process(uint16_t *raw,unsigned frames,unsigned width,unsigned height,
                        double fps,double lo,double hi,float alpha,motion_clip_processor*);
#ifdef __cplusplus
}
#endif
#endif
