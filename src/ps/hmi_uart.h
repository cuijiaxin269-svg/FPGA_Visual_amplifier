#ifndef HMI_UART_H
#define HMI_UART_H
#include <stdint.h>
#include <stddef.h>
typedef struct {uint32_t rx_bytes,tx_bytes,rx_overflow,rx_errors,tx_full,interrupts,unexpected_irq;} hmi_uart_stats;
extern volatile hmi_uart_stats hmi_uart_counters;
void hmi_uart_init(void);
int hmi_uart_read(uint8_t *);
/* Copy one COMPLETE native command atomically; 0 means backpressure. */
int hmi_uart_write(const uint8_t *,size_t);
int hmi_uart_fault(void);
void hmi_irq_dispatch(void);
#endif
