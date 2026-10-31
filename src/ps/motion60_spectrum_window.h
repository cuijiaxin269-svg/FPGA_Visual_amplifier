#ifndef MOTION60_SPECTRUM_WINDOW_H
#define MOTION60_SPECTRUM_WINDOW_H
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
typedef struct {
 float xy[256][2];
 uint32_t head,count,last_sequence,have_sequence,epoch;
 uint32_t phase,due;
} motion_spectrum_window;
typedef struct {uint32_t first_sequence,last_sequence,epoch;} motion_spectrum_snapshot;
void motion_spectrum_window_init(motion_spectrum_window *w);
void motion_spectrum_window_reset(motion_spectrum_window *w);
int motion_spectrum_window_push(motion_spectrum_window *w,float dx,float dy,
                               uint32_t sequence,int valid);
int motion_spectrum_window_take(motion_spectrum_window *w,float output[512],
                               motion_spectrum_snapshot *snapshot);
int motion_spectrum_window_current(const motion_spectrum_window *w,
                                  const motion_spectrum_snapshot *snapshot);
#ifdef __cplusplus
}
#endif
#endif
