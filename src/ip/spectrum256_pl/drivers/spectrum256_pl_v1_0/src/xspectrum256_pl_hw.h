// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// control
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 7  - auto_restart (Read/Write)
//        bit 9  - interrupt (Read)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0 - enable ap_done interrupt (Read/Write)
//        bit 1 - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0 - ap_done (Read/TOW)
//        bit 1 - ap_ready (Read/TOW)
//        others - reserved
// 0x10 : Data signal of motion
//        bit 31~0 - motion[31:0] (Read/Write)
// 0x14 : Data signal of motion
//        bit 31~0 - motion[63:32] (Read/Write)
// 0x18 : reserved
// 0x1c : Data signal of output_r
//        bit 31~0 - output_r[31:0] (Read/Write)
// 0x20 : Data signal of output_r
//        bit 31~0 - output_r[63:32] (Read/Write)
// 0x24 : reserved
// 0x28 : Data signal of operation
//        bit 31~0 - operation[31:0] (Read/Write)
// 0x2c : reserved
// 0x30 : Data signal of sequence_r
//        bit 31~0 - sequence_r[31:0] (Read/Write)
// 0x34 : reserved
// 0x38 : Data signal of valid_sample
//        bit 0  - valid_sample[0] (Read/Write)
//        others - reserved
// 0x3c : reserved
// 0x40 : Data signal of status
//        bit 31~0 - status[31:0] (Read)
// 0x44 : Control signal of status
//        bit 0  - status_ap_vld (Read/COR)
//        others - reserved
// 0x50 : Data signal of count
//        bit 31~0 - count[31:0] (Read)
// 0x54 : Control signal of count
//        bit 0  - count_ap_vld (Read/COR)
//        others - reserved
// 0x60 : Data signal of epoch
//        bit 31~0 - epoch[31:0] (Read)
// 0x64 : Control signal of epoch
//        bit 0  - epoch_ap_vld (Read/COR)
//        others - reserved
// 0x70 : Data signal of last_sequence
//        bit 31~0 - last_sequence[31:0] (Read)
// 0x74 : Control signal of last_sequence
//        bit 0  - last_sequence_ap_vld (Read/COR)
//        others - reserved
// 0x80 : Data signal of clipped_bins
//        bit 31~0 - clipped_bins[31:0] (Read)
// 0x84 : Control signal of clipped_bins
//        bit 0  - clipped_bins_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XSPECTRUM256_PL_CONTROL_ADDR_AP_CTRL            0x00
#define XSPECTRUM256_PL_CONTROL_ADDR_GIE                0x04
#define XSPECTRUM256_PL_CONTROL_ADDR_IER                0x08
#define XSPECTRUM256_PL_CONTROL_ADDR_ISR                0x0c
#define XSPECTRUM256_PL_CONTROL_ADDR_MOTION_DATA        0x10
#define XSPECTRUM256_PL_CONTROL_BITS_MOTION_DATA        64
#define XSPECTRUM256_PL_CONTROL_ADDR_OUTPUT_R_DATA      0x1c
#define XSPECTRUM256_PL_CONTROL_BITS_OUTPUT_R_DATA      64
#define XSPECTRUM256_PL_CONTROL_ADDR_OPERATION_DATA     0x28
#define XSPECTRUM256_PL_CONTROL_BITS_OPERATION_DATA     32
#define XSPECTRUM256_PL_CONTROL_ADDR_SEQUENCE_R_DATA    0x30
#define XSPECTRUM256_PL_CONTROL_BITS_SEQUENCE_R_DATA    32
#define XSPECTRUM256_PL_CONTROL_ADDR_VALID_SAMPLE_DATA  0x38
#define XSPECTRUM256_PL_CONTROL_BITS_VALID_SAMPLE_DATA  1
#define XSPECTRUM256_PL_CONTROL_ADDR_STATUS_DATA        0x40
#define XSPECTRUM256_PL_CONTROL_BITS_STATUS_DATA        32
#define XSPECTRUM256_PL_CONTROL_ADDR_STATUS_CTRL        0x44
#define XSPECTRUM256_PL_CONTROL_ADDR_COUNT_DATA         0x50
#define XSPECTRUM256_PL_CONTROL_BITS_COUNT_DATA         32
#define XSPECTRUM256_PL_CONTROL_ADDR_COUNT_CTRL         0x54
#define XSPECTRUM256_PL_CONTROL_ADDR_EPOCH_DATA         0x60
#define XSPECTRUM256_PL_CONTROL_BITS_EPOCH_DATA         32
#define XSPECTRUM256_PL_CONTROL_ADDR_EPOCH_CTRL         0x64
#define XSPECTRUM256_PL_CONTROL_ADDR_LAST_SEQUENCE_DATA 0x70
#define XSPECTRUM256_PL_CONTROL_BITS_LAST_SEQUENCE_DATA 32
#define XSPECTRUM256_PL_CONTROL_ADDR_LAST_SEQUENCE_CTRL 0x74
#define XSPECTRUM256_PL_CONTROL_ADDR_CLIPPED_BINS_DATA  0x80
#define XSPECTRUM256_PL_CONTROL_BITS_CLIPPED_BINS_DATA  32
#define XSPECTRUM256_PL_CONTROL_ADDR_CLIPPED_BINS_CTRL  0x84

