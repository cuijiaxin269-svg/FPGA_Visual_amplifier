#ifndef MOTION60_SPECTRUM_DRIVER_H
#define MOTION60_SPECTRUM_DRIVER_H
#include "motion60_spectrum_window.h"
#include "spectrum_ui.h"
#ifdef __cplusplus
extern "C" {
#endif
#define SPECTRUM_ROI_BASE 0x43c10000u
#define SPECTRUM_FFT_BASE 0x43c20000u
#define SPECTRUM_OSD_BASE 0x43c30000u
#define SPECTRUM_ROI_RESULT 0x19800000u
#define SPECTRUM_FFT_INPUT 0x19801000u
#define SPECTRUM_FFT_OUTPUT 0x19802000u
typedef struct {
 void *context;
 uint32_t (*read)(void*,uint32_t);
 void (*write)(void*,uint32_t,uint32_t);
} motion_spectrum_io;
typedef struct {
 motion_spectrum_io io;
 motion_spectrum_window window;
 motion_spectrum_snapshot snapshot;
 float frozen[512];
 uint16_t bars[129],upload[256];
 spectrum_ui ui;
 uint32_t roi_busy,fft_busy,roi_first,roi_sequence,roi_epoch;
 uint32_t x,y,error,state,dirty,upload_position,uploading,upload_epoch,upload_state;
 uint32_t awaiting_display,expected_display,enable;
 uint32_t submitted_enable,displayed_enable,display_generation;
 uint32_t valid_samples,fft_results,stale_results,last_roi_us,max_roi_us,clipped_bins;
 uint64_t roi_started,fft_started,display_started;
#ifdef MOTION60_PL_SPECTRUM
 uint32_t reset_pending,sample_pending,sample_sequence,sample_epoch;
 uint32_t pl_operation,pl_epoch,pl_sequence;
#endif
} motion_spectrum_driver;
int motion_spectrum_driver_init(motion_spectrum_driver*,motion_spectrum_io);
void motion_spectrum_invalidate(motion_spectrum_driver*,uint32_t state);
int motion_spectrum_roi_configure(motion_spectrum_driver*,uint32_t x,uint32_t y);
int motion_spectrum_frame_start(motion_spectrum_driver*,uint32_t input,uint32_t sequence,int first,uint64_t now);
int motion_spectrum_poll(motion_spectrum_driver*,uint64_t now);
#ifdef __cplusplus
}
#endif
#endif
