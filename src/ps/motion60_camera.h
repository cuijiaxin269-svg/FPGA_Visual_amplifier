#ifndef MOTION60_CAMERA_H
#define MOTION60_CAMERA_H
#include <stdint.h>
// Separate extension: preserve the existing 133-word acquisition ABI.
typedef struct {
 uint32_t magic,revision,applied_revision,mirror,flip;
 uint32_t mirror_readback,flip_readback,pattern_readback;
 uint32_t exposure_readback,gain_readback,rejected_commands;
 uint32_t exposure_lines,gain_raw,test_pattern,line_time_ns;
} motion60_camera_control;
#ifdef MOTION60_TEST_IO
extern volatile motion60_camera_control test_camera_control;
#define CAMERA_CONTROL (&test_camera_control)
#else
#define CAMERA_CONTROL ((volatile motion60_camera_control *)(uintptr_t)0x00ff1300u)
#endif
#endif
