#ifndef HMI_DEVICE_H
#define HMI_DEVICE_H
#include "hmi_protocol.h"
typedef struct {
 hmi_roi_config target,actual;
 unsigned seen,applied_valid;
 hmi_status status;
 uint32_t generation;
} hmi_roi_state;
typedef struct {
 uint32_t target[3],actual[3],valid[3],running,requested_run;
 hmi_status status[HMI_FIELDS];
 uint32_t generation[HMI_FIELDS];
 hmi_roi_state roi;
} hmi_device_state;
void motion60_hmi_request(void *,const hmi_request *);
void motion60_hmi_snapshot(hmi_device_state *);
void motion60_hmi_poll(void);
void motion60_hmi_completed(int error);
void motion60_hmi_started(void);
#endif
