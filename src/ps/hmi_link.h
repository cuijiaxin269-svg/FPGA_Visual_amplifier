#ifndef HMI_LINK_H
#define HMI_LINK_H
#include "hmi_device.h"
typedef int (*hmi_send_fn)(void *,const uint8_t *,size_t);
typedef struct {
 hmi_parser parser;
 hmi_device_state last;
 hmi_send_fn send;hmi_request_fn request;void *context;
 hmi_roi_request_fn roi_request;
 uint32_t sent[HMI_FIELDS],value_epoch,screen_epoch;
 unsigned page,online,sync_step,private_step,private_dirty,values_dirty,awaiting_page;
 uint64_t next_query,last_response,query_deadline;
 uint32_t native_errors,reconnects,transport_faults;
 uint32_t last_number,numeric_replies;
 uint32_t roi_sent,roi_epoch;
 unsigned roi_sent_valid;
} hmi_link;
void hmi_link_init(hmi_link *,void *,hmi_request_fn,hmi_send_fn);
void hmi_link_set_roi_handler(hmi_link *,hmi_roi_request_fn);
void hmi_link_poll(hmi_link *,const hmi_device_state *,uint64_t milliseconds);
void hmi_link_fault(hmi_link *);
#endif
