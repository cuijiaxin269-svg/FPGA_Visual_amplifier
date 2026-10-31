// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XCLIP_TEMPORAL_FULL_H
#define XCLIP_TEMPORAL_FULL_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xclip_temporal_full_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Control_BaseAddress;
} XClip_temporal_full_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XClip_temporal_full;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XClip_temporal_full_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XClip_temporal_full_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XClip_temporal_full_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XClip_temporal_full_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XClip_temporal_full_Initialize(XClip_temporal_full *InstancePtr, UINTPTR BaseAddress);
XClip_temporal_full_Config* XClip_temporal_full_LookupConfig(UINTPTR BaseAddress);
#else
int XClip_temporal_full_Initialize(XClip_temporal_full *InstancePtr, u16 DeviceId);
XClip_temporal_full_Config* XClip_temporal_full_LookupConfig(u16 DeviceId);
#endif
int XClip_temporal_full_CfgInitialize(XClip_temporal_full *InstancePtr, XClip_temporal_full_Config *ConfigPtr);
#else
int XClip_temporal_full_Initialize(XClip_temporal_full *InstancePtr, const char* InstanceName);
int XClip_temporal_full_Release(XClip_temporal_full *InstancePtr);
#endif

void XClip_temporal_full_Start(XClip_temporal_full *InstancePtr);
u32 XClip_temporal_full_IsDone(XClip_temporal_full *InstancePtr);
u32 XClip_temporal_full_IsIdle(XClip_temporal_full *InstancePtr);
u32 XClip_temporal_full_IsReady(XClip_temporal_full *InstancePtr);
void XClip_temporal_full_EnableAutoRestart(XClip_temporal_full *InstancePtr);
void XClip_temporal_full_DisableAutoRestart(XClip_temporal_full *InstancePtr);

void XClip_temporal_full_Set_phase(XClip_temporal_full *InstancePtr, u64 Data);
u64 XClip_temporal_full_Get_phase(XClip_temporal_full *InstancePtr);
void XClip_temporal_full_Set_frames(XClip_temporal_full *InstancePtr, u32 Data);
u32 XClip_temporal_full_Get_frames(XClip_temporal_full *InstancePtr);
void XClip_temporal_full_Set_pixels(XClip_temporal_full *InstancePtr, u32 Data);
u32 XClip_temporal_full_Get_pixels(XClip_temporal_full *InstancePtr);
void XClip_temporal_full_Set_fps(XClip_temporal_full *InstancePtr, u64 Data);
u64 XClip_temporal_full_Get_fps(XClip_temporal_full *InstancePtr);
void XClip_temporal_full_Set_low_r(XClip_temporal_full *InstancePtr, u64 Data);
u64 XClip_temporal_full_Get_low_r(XClip_temporal_full *InstancePtr);
void XClip_temporal_full_Set_high_r(XClip_temporal_full *InstancePtr, u64 Data);
u64 XClip_temporal_full_Get_high_r(XClip_temporal_full *InstancePtr);
void XClip_temporal_full_Set_valid_clip(XClip_temporal_full *InstancePtr, u32 Data);
u32 XClip_temporal_full_Get_valid_clip(XClip_temporal_full *InstancePtr);
u32 XClip_temporal_full_Get_status(XClip_temporal_full *InstancePtr);
u32 XClip_temporal_full_Get_status_vld(XClip_temporal_full *InstancePtr);

void XClip_temporal_full_InterruptGlobalEnable(XClip_temporal_full *InstancePtr);
void XClip_temporal_full_InterruptGlobalDisable(XClip_temporal_full *InstancePtr);
void XClip_temporal_full_InterruptEnable(XClip_temporal_full *InstancePtr, u32 Mask);
void XClip_temporal_full_InterruptDisable(XClip_temporal_full *InstancePtr, u32 Mask);
void XClip_temporal_full_InterruptClear(XClip_temporal_full *InstancePtr, u32 Mask);
u32 XClip_temporal_full_InterruptGetEnabled(XClip_temporal_full *InstancePtr);
u32 XClip_temporal_full_InterruptGetStatus(XClip_temporal_full *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
