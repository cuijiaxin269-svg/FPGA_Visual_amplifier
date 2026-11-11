#ifndef MOTION60_H
#define MOTION60_H
#ifdef MOTION60_HMI
#include "hmi_device.h"
#endif
void motion60_init(void);
void motion60_idle(void);
void motion60_begin(void);
int motion60_prepare_reset(void);
void motion60_drain_poll(void);
int motion60_end(void);
void motion60_abort(void);
// 0: continue, 1: requested normal stop, negative: hardware/integrity fault.
int motion60_tick(unsigned dma_events);
#endif
