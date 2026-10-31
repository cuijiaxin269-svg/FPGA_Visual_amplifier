#ifndef MOTION60_CLIP_RECORD_H
#define MOTION60_CLIP_RECORD_H
#include "motion60_clip_layout.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef struct {
 motion_clip_layout layout;
 uint32_t committed,busy,ready,error,have_sequence,last_sequence,pending_sequence;
 uint32_t source,destination;
 uint64_t started,first_sample,last_sample,pending_sample;
} motion_clip_record;
// Initialize only after all prior masters have drained. A zero-initialized
// object is required before the first call. No function below performs MMIO.
int motion_clip_record_begin(motion_clip_record*,uint32_t frames,int masters_idle);
void motion_clip_record_fault(motion_clip_record*,uint32_t reason);
int motion_clip_record_start(motion_clip_record*,uint32_t sequence,uint32_t source,
                            uint32_t write_slot,int clean,uint64_t sample,uint64_t now);
int motion_clip_record_check(motion_clip_record*,uint32_t write_slot,int clean,uint64_t now);
int motion_clip_record_complete(motion_clip_record*,uint32_t write_slot,int clean,
                               int copy_ok,uint64_t now);
#ifdef __cplusplus
}
#endif
#endif
