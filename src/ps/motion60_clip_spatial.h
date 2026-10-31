#ifndef MOTION60_CLIP_SPATIAL_H
#define MOTION60_CLIP_SPATIAL_H
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
// Four full-resolution float scratch planes, three band planes of N,N/4,N/16,
// and N/64 residual pixels. Caller supplies disjoint storage, no allocation.
typedef struct {float *a,*b,*tmp,*next,*band[3],*residual;} motion_clip_spatial;
int motion_clip_decompose(const uint16_t*,unsigned width,unsigned height,motion_clip_spatial*);
void motion_clip_phase(motion_clip_spatial*,unsigned width,unsigned height,unsigned level,float *phase);
void motion_clip_reconstruct(motion_clip_spatial*,unsigned width,unsigned height,
                             const float *delta[3],float alpha,uint16_t *output);
#ifdef __cplusplus
}
#endif
#endif
