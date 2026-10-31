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
// 0x28 : Data signal of state0_r
//        bit 31~0 - state0_r[31:0] (Read/Write)
// 0x2c : Data signal of state0_r
//        bit 31~0 - state0_r[63:32] (Read/Write)
// 0x30 : reserved
// 0x34 : Data signal of state1_r
//        bit 31~0 - state1_r[31:0] (Read/Write)
// 0x38 : Data signal of state1_r
//        bit 31~0 - state1_r[63:32] (Read/Write)
// 0x3c : reserved
// 0x40 : Data signal of state2_r
//        bit 31~0 - state2_r[31:0] (Read/Write)
// 0x44 : Data signal of state2_r
//        bit 31~0 - state2_r[63:32] (Read/Write)
// 0x48 : reserved
// 0x4c : Data signal of b0
//        bit 31~0 - b0[31:0] (Read/Write)
// 0x50 : reserved
// 0x54 : Data signal of b2
//        bit 31~0 - b2[31:0] (Read/Write)
// 0x58 : reserved
// 0x5c : Data signal of a1
//        bit 31~0 - a1[31:0] (Read/Write)
// 0x60 : reserved
// 0x64 : Data signal of a2
//        bit 31~0 - a2[31:0] (Read/Write)
// 0x68 : reserved
// 0x6c : Data signal of alpha
//        bit 31~0 - alpha[31:0] (Read/Write)
// 0x70 : reserved
// 0x74 : Data signal of first_frame
//        bit 0  - first_frame[0] (Read/Write)
//        others - reserved
// 0x78 : reserved
// 0x7c : Data signal of mode
//        bit 31~0 - mode[31:0] (Read/Write)
// 0x80 : reserved
// 0x84 : Data signal of status
//        bit 31~0 - status[31:0] (Read)
// 0x88 : Control signal of status
//        bit 0  - status_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XMOTION60_SHARED_CONTROL_ADDR_AP_CTRL          0x00
#define XMOTION60_SHARED_CONTROL_ADDR_GIE              0x04
#define XMOTION60_SHARED_CONTROL_ADDR_IER              0x08
#define XMOTION60_SHARED_CONTROL_ADDR_ISR              0x0c
#define XMOTION60_SHARED_CONTROL_ADDR_INPUT_R_DATA     0x10
#define XMOTION60_SHARED_CONTROL_BITS_INPUT_R_DATA     64
#define XMOTION60_SHARED_CONTROL_ADDR_OUTPUT_R_DATA    0x1c
#define XMOTION60_SHARED_CONTROL_BITS_OUTPUT_R_DATA    64
#define XMOTION60_SHARED_CONTROL_ADDR_STATE0_R_DATA    0x28
#define XMOTION60_SHARED_CONTROL_BITS_STATE0_R_DATA    64
#define XMOTION60_SHARED_CONTROL_ADDR_STATE1_R_DATA    0x34
#define XMOTION60_SHARED_CONTROL_BITS_STATE1_R_DATA    64
#define XMOTION60_SHARED_CONTROL_ADDR_STATE2_R_DATA    0x40
#define XMOTION60_SHARED_CONTROL_BITS_STATE2_R_DATA    64
#define XMOTION60_SHARED_CONTROL_ADDR_B0_DATA          0x4c
#define XMOTION60_SHARED_CONTROL_BITS_B0_DATA          32
#define XMOTION60_SHARED_CONTROL_ADDR_B2_DATA          0x54
#define XMOTION60_SHARED_CONTROL_BITS_B2_DATA          32
#define XMOTION60_SHARED_CONTROL_ADDR_A1_DATA          0x5c
#define XMOTION60_SHARED_CONTROL_BITS_A1_DATA          32
#define XMOTION60_SHARED_CONTROL_ADDR_A2_DATA          0x64
#define XMOTION60_SHARED_CONTROL_BITS_A2_DATA          32
#define XMOTION60_SHARED_CONTROL_ADDR_ALPHA_DATA       0x6c
#define XMOTION60_SHARED_CONTROL_BITS_ALPHA_DATA       32
#define XMOTION60_SHARED_CONTROL_ADDR_FIRST_FRAME_DATA 0x74
#define XMOTION60_SHARED_CONTROL_BITS_FIRST_FRAME_DATA 1
#define XMOTION60_SHARED_CONTROL_ADDR_MODE_DATA        0x7c
#define XMOTION60_SHARED_CONTROL_BITS_MODE_DATA        32
#define XMOTION60_SHARED_CONTROL_ADDR_STATUS_DATA      0x84
#define XMOTION60_SHARED_CONTROL_BITS_STATUS_DATA      32
#define XMOTION60_SHARED_CONTROL_ADDR_STATUS_CTRL      0x88

