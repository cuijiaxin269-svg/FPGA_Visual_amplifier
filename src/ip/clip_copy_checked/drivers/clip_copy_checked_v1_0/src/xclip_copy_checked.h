// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XCLIP_COPY_CHECKED_H
#define XCLIP_COPY_CHECKED_H

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
#include "xclip_copy_checked_hw.h"

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
} XClip_copy_checked_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XClip_copy_checked;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XClip_copy_checked_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XClip_copy_checked_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XClip_copy_checked_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XClip_copy_checked_ReadReg(BaseAddress, RegOffset) \
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
int XClip_copy_checked_Initialize(XClip_copy_checked *InstancePtr, UINTPTR BaseAddress);
XClip_copy_checked_Config* XClip_copy_checked_LookupConfig(UINTPTR BaseAddress);
#else
int XClip_copy_checked_Initialize(XClip_copy_checked *InstancePtr, u16 DeviceId);
XClip_copy_checked_Config* XClip_copy_checked_LookupConfig(u16 DeviceId);
#endif
int XClip_copy_checked_CfgInitialize(XClip_copy_checked *InstancePtr, XClip_copy_checked_Config *ConfigPtr);
#else
int XClip_copy_checked_Initialize(XClip_copy_checked *InstancePtr, const char* InstanceName);
int XClip_copy_checked_Release(XClip_copy_checked *InstancePtr);
#endif

void XClip_copy_checked_Start(XClip_copy_checked *InstancePtr);
u32 XClip_copy_checked_IsDone(XClip_copy_checked *InstancePtr);
u32 XClip_copy_checked_IsIdle(XClip_copy_checked *InstancePtr);
u32 XClip_copy_checked_IsReady(XClip_copy_checked *InstancePtr);
void XClip_copy_checked_EnableAutoRestart(XClip_copy_checked *InstancePtr);
void XClip_copy_checked_DisableAutoRestart(XClip_copy_checked *InstancePtr);

void XClip_copy_checked_Set_source(XClip_copy_checked *InstancePtr, u64 Data);
u64 XClip_copy_checked_Get_source(XClip_copy_checked *InstancePtr);
void XClip_copy_checked_Set_destination(XClip_copy_checked *InstancePtr, u64 Data);
u64 XClip_copy_checked_Get_destination(XClip_copy_checked *InstancePtr);
void XClip_copy_checked_Set_valid_source(XClip_copy_checked *InstancePtr, u32 Data);
u32 XClip_copy_checked_Get_valid_source(XClip_copy_checked *InstancePtr);
u32 XClip_copy_checked_Get_status(XClip_copy_checked *InstancePtr);
u32 XClip_copy_checked_Get_status_vld(XClip_copy_checked *InstancePtr);

void XClip_copy_checked_InterruptGlobalEnable(XClip_copy_checked *InstancePtr);
void XClip_copy_checked_InterruptGlobalDisable(XClip_copy_checked *InstancePtr);
void XClip_copy_checked_InterruptEnable(XClip_copy_checked *InstancePtr, u32 Mask);
void XClip_copy_checked_InterruptDisable(XClip_copy_checked *InstancePtr, u32 Mask);
void XClip_copy_checked_InterruptClear(XClip_copy_checked *InstancePtr, u32 Mask);
u32 XClip_copy_checked_InterruptGetEnabled(XClip_copy_checked *InstancePtr);
u32 XClip_copy_checked_InterruptGetStatus(XClip_copy_checked *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
