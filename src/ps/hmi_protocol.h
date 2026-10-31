#ifndef HMI_PROTOCOL_H
#define HMI_PROTOCOL_H
#include <stdint.h>
#include <stddef.h>
typedef enum { HMI_VIEW, HMI_ALPHA, HMI_EXPOSURE, HMI_RUN, HMI_FIELDS } hmi_field;
typedef enum { HMI_SET_VIEW, HMI_SET_ALPHA, HMI_SET_EXPOSURE, HMI_START, HMI_STOP, HMI_UNKNOWN } hmi_operation;
typedef enum { HMI_SET, HMI_QUEUED, HMI_WAIT, HMI_APPLIED, HMI_RUNNING, HMI_STOPPED, HMI_BUSY, HMI_REJECTED, HMI_ERROR } hmi_status;
typedef struct { hmi_operation operation; uint32_t value; unsigned valid; } hmi_request;
typedef void (*hmi_request_fn)(void *,const hmi_request *);
typedef void (*hmi_native_fn)(void *,uint8_t,uint32_t);
typedef struct {
 char line[96]; uint8_t packet[96];
 unsigned length,cr,discard,native_length,native_expected,ff;
 uint32_t commands,rejected,native_packets,corrupt_packets,overlong;
 void *context; hmi_request_fn request; hmi_native_fn native;
} hmi_parser;
void hmi_parser_init(hmi_parser *,void *,hmi_request_fn,hmi_native_fn);
void hmi_parser_feed(hmi_parser *,uint8_t);
/* On a transport gap, discard through the next complete delimiter. */
void hmi_parser_resync(hmi_parser *);
const char *hmi_status_text(hmi_status);
#endif
