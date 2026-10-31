#ifndef HMI_DIAGNOSTICS_H
#define HMI_DIAGNOSTICS_H
#include <stdint.h>
#define HMI_TRACE_SIZE 8192u
/* Separate read-only JTAG diagnostics; the original mailbox ABI is unchanged.
   Trace records UART FIFO traffic, not an electrical logic-analyzer capture. */
typedef struct {
 uint32_t magic,version;
 uint32_t rx_total,tx_total;
 uint8_t rx[HMI_TRACE_SIZE],tx[HMI_TRACE_SIZE];
} hmi_trace_record;
extern volatile uint32_t hmi_diagnostics[64];
extern volatile hmi_trace_record hmi_trace;
/* JTAG-only native UART probe. Host writes data/length, then request last;
   waits for completed before reusing the buffer. result=1 is TX acceptance,
   not a screen ACK or a successful device operation. */
typedef struct {
 uint32_t magic,version,request,completed,result,length;
 uint8_t command[96];
} hmi_probe_record;
extern volatile hmi_probe_record hmi_probe;
#endif
