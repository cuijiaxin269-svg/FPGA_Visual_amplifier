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
// 0x10 : Data signal of input_r
//        bit 31~0 - input_r[31:0] (Read/Write)
// 0x14 : Data signal of input_r
//        bit 31~0 - input_r[63:32] (Read/Write)
// 0x18 : reserved
// 0x1c : Data signal of output_r
//        bit 31~0 - output_r[31:0] (Read/Write)
// 0x20 : Data signal of output_r
//        bit 31~0 - output_r[63:32] (Read/Write)
// 0x24 : reserved
// 0x28 : Data signal of x
//        bit 31~0 - x[31:0] (Read/Write)
// 0x2c : reserved
// 0x30 : Data signal of y
//        bit 31~0 - y[31:0] (Read/Write)
// 0x34 : reserved
// 0x38 : Data signal of first_frame
//        bit 0  - first_frame[0] (Read/Write)
//        others - reserved
// 0x3c : reserved
// 0x40 : Data signal of valid_frame
//        bit 0  - valid_frame[0] (Read/Write)
//        others - reserved
// 0x44 : reserved
// 0x48 : Data signal of status
//        bit 31~0 - status[31:0] (Read)
// 0x4c : Control signal of status
//        bit 0  - status_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XROI256_CONTROL_ADDR_AP_CTRL          0x00
#define XROI256_CONTROL_ADDR_GIE              0x04
#define XROI256_CONTROL_ADDR_IER              0x08
#define XROI256_CONTROL_ADDR_ISR              0x0c
#define XROI256_CONTROL_ADDR_INPUT_R_DATA     0x10
#define XROI256_CONTROL_BITS_INPUT_R_DATA     64
#define XROI256_CONTROL_ADDR_OUTPUT_R_DATA    0x1c
#define XROI256_CONTROL_BITS_OUTPUT_R_DATA    64
#define XROI256_CONTROL_ADDR_X_DATA           0x28
#define XROI256_CONTROL_BITS_X_DATA           32
#define XROI256_CONTROL_ADDR_Y_DATA           0x30
#define XROI256_CONTROL_BITS_Y_DATA           32
#define XROI256_CONTROL_ADDR_FIRST_FRAME_DATA 0x38
#define XROI256_CONTROL_BITS_FIRST_FRAME_DATA 1
#define XROI256_CONTROL_ADDR_VALID_FRAME_DATA 0x40
#define XROI256_CONTROL_BITS_VALID_FRAME_DATA 1
#define XROI256_CONTROL_ADDR_STATUS_DATA      0x48
#define XROI256_CONTROL_BITS_STATUS_DATA      32
#define XROI256_CONTROL_ADDR_STATUS_CTRL      0x4c

