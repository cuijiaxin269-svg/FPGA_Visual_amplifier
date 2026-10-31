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
// 0x10 : Data signal of source
//        bit 31~0 - source[31:0] (Read/Write)
// 0x14 : Data signal of source
//        bit 31~0 - source[63:32] (Read/Write)
// 0x18 : reserved
// 0x1c : Data signal of destination
//        bit 31~0 - destination[31:0] (Read/Write)
// 0x20 : Data signal of destination
//        bit 31~0 - destination[63:32] (Read/Write)
// 0x24 : reserved
// 0x28 : Data signal of valid_source
//        bit 0  - valid_source[0] (Read/Write)
//        others - reserved
// 0x2c : reserved
// 0x30 : Data signal of status
//        bit 31~0 - status[31:0] (Read)
// 0x34 : Control signal of status
//        bit 0  - status_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XCLIP_COPY_CHECKED_CONTROL_ADDR_AP_CTRL           0x00
#define XCLIP_COPY_CHECKED_CONTROL_ADDR_GIE               0x04
#define XCLIP_COPY_CHECKED_CONTROL_ADDR_IER               0x08
#define XCLIP_COPY_CHECKED_CONTROL_ADDR_ISR               0x0c
#define XCLIP_COPY_CHECKED_CONTROL_ADDR_SOURCE_DATA       0x10
#define XCLIP_COPY_CHECKED_CONTROL_BITS_SOURCE_DATA       64
#define XCLIP_COPY_CHECKED_CONTROL_ADDR_DESTINATION_DATA  0x1c
#define XCLIP_COPY_CHECKED_CONTROL_BITS_DESTINATION_DATA  64
#define XCLIP_COPY_CHECKED_CONTROL_ADDR_VALID_SOURCE_DATA 0x28
#define XCLIP_COPY_CHECKED_CONTROL_BITS_VALID_SOURCE_DATA 1
#define XCLIP_COPY_CHECKED_CONTROL_ADDR_STATUS_DATA       0x30
#define XCLIP_COPY_CHECKED_CONTROL_BITS_STATUS_DATA       32
#define XCLIP_COPY_CHECKED_CONTROL_ADDR_STATUS_CTRL       0x34

