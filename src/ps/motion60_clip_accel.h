#ifndef MOTION60_CLIP_ACCEL_H
#define MOTION60_CLIP_ACCEL_H
#include "motion60_clip_driver.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef struct {
 motion_clip_io io;
 uint64_t (*clock)(void*);
 uint32_t base,busy,error,completed,max_us;
 uint64_t started;
} motion_clip_accel;
// Initialize fields once before use; never overwrite a busy/error accelerator.
int motion_clip_accel_poll(motion_clip_accel*);
int motion_clip_accel_filter(void*,const float*,const float*,float*,unsigned,unsigned);
#ifdef __cplusplus
}
#endif
#endif
