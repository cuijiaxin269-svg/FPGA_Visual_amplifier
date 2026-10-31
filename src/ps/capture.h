#ifndef CAPTURE_H
#define CAPTURE_H
#include <stdint.h>
#include <stddef.h>
#define WIDTH 1280u
#define HEIGHT 800u
#define STRIDE 2560u
#define FRAME_BYTES (STRIDE*HEIGHT)
#define FRAME0 0x10000000u
#define FRAME_SPACING 0x00200000u
#define CTRL_BASE 0x41200000u
#define VDMA_BASE 0x43000000u
#define I2C_BASE 0xe0004000u
#define MAILBOX_BASE 0x00ff0000u
// Timestamp storage lives separately, since 8192 samples exceed the 64KiB mailbox.
typedef struct {
 uint32_t magic, command, electrical_ok, status, error, sensor_address, sensor_id;
 uint32_t duration_ms, test_pattern, ddr_errors, dma_events, dma_status, stats[16];
 uint32_t sample_count, sequence_gaps;
 uint32_t stopped_write_slot, valid_buffer_mask;
 uint32_t phy_hs_settle;
 uint32_t csi_isr_observed, csi_csr_observed;
 uint32_t sensor_prepare_raw, sensor_prepare_readback;
 uint32_t sensor_lpx_ns, sensor_lpx_readback;
 uint32_t sensor_clock_gated, sensor_clock_readback;
 uint32_t sensor_lpx_raw;
 uint32_t capture_source_command;
 uint32_t sensor_lp_drive, sensor_lp_drive_readback;
 uint32_t csi_isr_before_stream_off;
 uint32_t sensor_frame_last, sensor_frame_gaps, sensor_frame_changes, sensor_frame_sofs;
 uint32_t first_error_sof, first_error_timestamp_lo, first_error_timestamp_hi, first_error_isr;
 uint32_t ecc_diagnostic_rearm, ecc_observed_events;
 uint32_t sensor_hs_zero_ns, sensor_hs_zero_readback;
 uint32_t sensor_clock_first_bit;
 uint32_t sensor_mipi_period, sensor_mipi_period_readback;
 uint32_t phy_manual_taps, phy_tap_l0, phy_tap_l1, phy_tap_readback;
 uint32_t csi_warmup_end_isr;
 uint32_t sensor_frame_counter_mode, sensor_frame_counter_readback;
 uint32_t sensor_hs_trail_ns, sensor_hs_trail_readback;
 uint32_t sensor_frame_counter_ctrl_readback;
 uint32_t test_frame_limit, write_slot_before_stop, csi_boundary_drain_us;
 uint32_t halted_write_slot;
 uint32_t diagnostic_rearm_mask, crc_observed_events, diagnostic_logged_events;
 uint32_t sensor_hs_vcm, sensor_hs_vcm_readback, sensor_hs_drive, sensor_hs_drive_readback;
 uint32_t sensor_cfg_failed_reg, sensor_cfg_readback, sensor_cfg_expected, sensor_cfg_stage;
 uint32_t phy_active_tap_reload, phy_active_tap_readback;
 uint32_t sccb_gpio_mode;
 uint32_t sensor_solid_test, sensor_solid_value, sensor_solid_ctrl_readback;
 uint32_t sensor_solid_pixel_readback[4];
 uint32_t sensor_solid_second;
 uint32_t sensor_bar_readback;
 uint32_t sensor_d1_skew, sensor_d1_skew_readback;
 uint32_t sensor_exposure_lines, sensor_gain_raw;
 uint32_t sensor_exposure_readback, sensor_gain_readback;
 uint32_t sensor_d0_skew, sensor_clock_skew;
 uint32_t sensor_d0_skew_readback, sensor_clock_skew_readback;
 uint32_t sensor_pclk_invert, sensor_pclk_invert_readback;
 // 0=full acquisition; 1=400Mbps/60fps; 2=800Mbps slow rows; 3=640Mbps slow rows.
 uint32_t sensor_half_rate_diagnostic, sensor_m_div_readback, sensor_hts_readback;
 uint32_t recovered_byte_div256_edges, recovered_clock_elapsed_lo, recovered_clock_elapsed_hi;
 uint32_t sensor_clk_post_min_ns, sensor_clk_post_min_readback, sensor_clk_post_ui_readback;
 uint32_t sensor_clock_out_skew, sensor_clock_out_skew_readback;
 // Clock candidates:0=original,1=640 with /4 system branch,2=640 original
 // /5 system branch,3=752 original dividers. Imaging cadence is measured.
 uint32_t sensor_fullrate640, sensor_pll1_readback, sensor_vts_readback;
 uint32_t sensor_pll1_reference_readback, sensor_pll2_reference_readback, sensor_pll2_div_readback;
 uint32_t sensor_prime_fast_readback, sensor_prime_restore_readback;
 uint32_t sensor_iref_code, sensor_iref_readback;
 // Appended ABI fields; previous131words retain their offsets.
 uint32_t sensor_hstx_open_term, sensor_hstx_open_term_readback;
} capture_control;
_Static_assert(sizeof(capture_control)==133u*4u,"JTAG mailbox ABI mismatch");
extern volatile capture_control mailbox;
static inline uint32_t rd(uint32_t a){return *(volatile uint32_t *)(uintptr_t)a;}
static inline void wr(uint32_t a,uint32_t v){*(volatile uint32_t *)(uintptr_t)a=v;__asm__ volatile("dsb sy":::"memory");}
uint64_t timer_ticks(void);
void delay_us(uint32_t us);
int sensor_read(uint8_t addr,uint16_t reg,uint8_t *v);
int sensor_write(uint8_t addr,uint16_t reg,uint8_t v);
int sensor_probe(uint8_t *addr,uint16_t *id);
int sensor_gpio_probe(uint8_t *addr,uint16_t *id,uint32_t *samples);
int sensor_bus_recover(void);
int sensor_select_gpio(int enable);
int sensor_configure(uint8_t addr,int pattern);
#endif
