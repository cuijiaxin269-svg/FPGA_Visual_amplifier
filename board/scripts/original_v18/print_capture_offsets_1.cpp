#include <cstdio>
#include <cstddef>
#define _Static_assert static_assert
#include "../../sw/capture.h"
#define SHOW(field) std::printf("%s 0x%08x\n",#field,0xff0000u+(unsigned)offsetof(capture_control,field))
int main(){SHOW(sensor_frame_counter_mode);SHOW(sensor_frame_counter_readback);SHOW(sensor_frame_last);SHOW(sensor_frame_gaps);SHOW(sensor_frame_changes);SHOW(sensor_frame_sofs);SHOW(sequence_gaps);return 0;}
