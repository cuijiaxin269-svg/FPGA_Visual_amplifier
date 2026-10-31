#ifndef MOTION60_CLIP_DRIVER_H
#define MOTION60_CLIP_DRIVER_H
#include "motion60_clip_record.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef struct {
 void *context;
 uint32_t (*read)(void*,uint32_t);
 void (*write)(void*,uint32_t,uint32_t);
} motion_clip_io;
typedef struct {
 motion_clip_record record;
 motion_clip_io io;
 uint32_t base;
} motion_clip_driver;
// Zero initialize before first call; base must come from validated BD mapping.
int motion_clip_driver_begin(motion_clip_driver*,motion_clip_io,uint32_t base,uint32_t frames,int masters_idle);
int motion_clip_driver_frame(motion_clip_driver*,uint32_t sequence,uint32_t source,uint32_t write_slot,int clean,uint64_t sample,uint64_t now);
int motion_clip_driver_poll(motion_clip_driver*,uint32_t write_slot,int clean,uint64_t now);
#ifdef __cplusplus
}
#endif
#endif
