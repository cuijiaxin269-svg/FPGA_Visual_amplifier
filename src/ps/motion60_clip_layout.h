#ifndef MOTION60_CLIP_LAYOUT_H
#define MOTION60_CLIP_LAYOUT_H
#include <stdint.h>
// Exclusive clip mode: live VDMA, motion, ROI, and display masters MUST be
// drained before these regions can be used. In particular, phase storage
// intentionally overlaps the inactive live frame/state buffers.
#define CLIP_WIDTH 1280u
#define CLIP_HEIGHT 800u
#define CLIP_PIXELS (CLIP_WIDTH*CLIP_HEIGHT)
#define CLIP_MIN_FRAMES 30u
#define CLIP_MAX_FRAMES 120u
#define CLIP_PHASE_BASE 0x02000000u
#define CLIP_RAW_BASE 0x2a000000u
#define CLIP_WORK_BASE 0x39000000u
#define CLIP_DDR_END 0x40000000u
typedef struct {
 uint32_t frames,raw_base,raw_end,phase_base[3],phase_end,work_base,work_end;
 uint32_t replay_base,replay_end;
} motion_clip_layout;
// No writes/MMIO: rejects invalid lengths without altering the result.
static inline int motion_clip_layout_make(uint32_t frames,motion_clip_layout *out){
 if(!out||frames<CLIP_MIN_FRAMES||frames>CLIP_MAX_FRAMES)return -1;
 motion_clip_layout value;
 value.frames=frames;
 value.raw_base=CLIP_RAW_BASE;value.raw_end=CLIP_RAW_BASE+frames*CLIP_PIXELS*2u;
 value.phase_base[0]=CLIP_PHASE_BASE;
 value.phase_base[1]=value.phase_base[0]+frames*CLIP_PIXELS*4u;
 value.phase_base[2]=value.phase_base[1]+frames*(CLIP_PIXELS/4u)*4u;
 value.phase_end=value.phase_base[2]+frames*(CLIP_PIXELS/16u)*4u;
 value.work_base=CLIP_WORK_BASE;value.work_end=CLIP_DDR_END;
 // After ALL frames have supplied phase and ALL temporal filtering finishes,
 // reconstruct each frame in work memory, then replace just its raw frame.
 // Reprocessing requires a new recording once raw pixels are overwritten.
 value.replay_base=value.raw_base;value.replay_end=value.raw_end;
 if(value.phase_end>value.raw_base||value.raw_end>value.work_base)return -2;
 *out=value;return 0;
}
#endif
