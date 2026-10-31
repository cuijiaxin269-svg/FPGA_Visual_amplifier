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
// 0x10 : Data signal of phase
//        bit 31~0 - phase[31:0] (Read/Write)
// 0x14 : Data signal of phase
//        bit 31~0 - phase[63:32] (Read/Write)
// 0x18 : reserved
// 0x1c : Data signal of frames
//        bit 31~0 - frames[31:0] (Read/Write)
// 0x20 : reserved
// 0x24 : Data signal of pixels
//        bit 31~0 - pixels[31:0] (Read/Write)
// 0x28 : reserved
// 0x2c : Data signal of fps
//        bit 31~0 - fps[31:0] (Read/Write)
// 0x30 : Data signal of fps
//        bit 31~0 - fps[63:32] (Read/Write)
// 0x34 : reserved
// 0x38 : Data signal of low_r
//        bit 31~0 - low_r[31:0] (Read/Write)
// 0x3c : Data signal of low_r
//        bit 31~0 - low_r[63:32] (Read/Write)
// 0x40 : reserved
// 0x44 : Data signal of high_r
//        bit 31~0 - high_r[31:0] (Read/Write)
// 0x48 : Data signal of high_r
//        bit 31~0 - high_r[63:32] (Read/Write)
// 0x4c : reserved
// 0x50 : Data signal of valid_clip
//        bit 0  - valid_clip[0] (Read/Write)
//        others - reserved
// 0x54 : reserved
// 0x58 : Data signal of status
//        bit 31~0 - status[31:0] (Read)
// 0x5c : Control signal of status
//        bit 0  - status_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_AP_CTRL         0x00
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_GIE             0x04
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_IER             0x08
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_ISR             0x0c
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_PHASE_DATA      0x10
#define XCLIP_TEMPORAL_FULL_CONTROL_BITS_PHASE_DATA      64
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_FRAMES_DATA     0x1c
#define XCLIP_TEMPORAL_FULL_CONTROL_BITS_FRAMES_DATA     32
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_PIXELS_DATA     0x24
#define XCLIP_TEMPORAL_FULL_CONTROL_BITS_PIXELS_DATA     32
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_FPS_DATA        0x2c
#define XCLIP_TEMPORAL_FULL_CONTROL_BITS_FPS_DATA        64
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_LOW_R_DATA      0x38
#define XCLIP_TEMPORAL_FULL_CONTROL_BITS_LOW_R_DATA      64
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_HIGH_R_DATA     0x44
#define XCLIP_TEMPORAL_FULL_CONTROL_BITS_HIGH_R_DATA     64
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_VALID_CLIP_DATA 0x50
#define XCLIP_TEMPORAL_FULL_CONTROL_BITS_VALID_CLIP_DATA 1
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_STATUS_DATA     0x58
#define XCLIP_TEMPORAL_FULL_CONTROL_BITS_STATUS_DATA     32
#define XCLIP_TEMPORAL_FULL_CONTROL_ADDR_STATUS_CTRL     0x5c

