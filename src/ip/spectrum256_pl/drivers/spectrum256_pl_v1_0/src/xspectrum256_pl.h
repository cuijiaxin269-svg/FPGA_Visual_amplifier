// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XSPECTRUM256_PL_H
#define XSPECTRUM256_PL_H

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
#include "xspectrum256_pl_hw.h"

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
} XSpectrum256_pl_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XSpectrum256_pl;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XSpectrum256_pl_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XSpectrum256_pl_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XSpectrum256_pl_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XSpectrum256_pl_ReadReg(BaseAddress, RegOffset) \
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
int XSpectrum256_pl_Initialize(XSpectrum256_pl *InstancePtr, UINTPTR BaseAddress);
XSpectrum256_pl_Config* XSpectrum256_pl_LookupConfig(UINTPTR BaseAddress);
#else
int XSpectrum256_pl_Initialize(XSpectrum256_pl *InstancePtr, u16 DeviceId);
XSpectrum256_pl_Config* XSpectrum256_pl_LookupConfig(u16 DeviceId);
#endif
int XSpectrum256_pl_CfgInitialize(XSpectrum256_pl *InstancePtr, XSpectrum256_pl_Config *ConfigPtr);
#else
int XSpectrum256_pl_Initialize(XSpectrum256_pl *InstancePtr, const char* InstanceName);
int XSpectrum256_pl_Release(XSpectrum256_pl *InstancePtr);
#endif

void XSpectrum256_pl_Start(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_IsDone(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_IsIdle(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_IsReady(XSpectrum256_pl *InstancePtr);
void XSpectrum256_pl_EnableAutoRestart(XSpectrum256_pl *InstancePtr);
void XSpectrum256_pl_DisableAutoRestart(XSpectrum256_pl *InstancePtr);

void XSpectrum256_pl_Set_motion(XSpectrum256_pl *InstancePtr, u64 Data);
u64 XSpectrum256_pl_Get_motion(XSpectrum256_pl *InstancePtr);
void XSpectrum256_pl_Set_output_r(XSpectrum256_pl *InstancePtr, u64 Data);
u64 XSpectrum256_pl_Get_output_r(XSpectrum256_pl *InstancePtr);
void XSpectrum256_pl_Set_operation(XSpectrum256_pl *InstancePtr, u32 Data);
u32 XSpectrum256_pl_Get_operation(XSpectrum256_pl *InstancePtr);
void XSpectrum256_pl_Set_sequence_r(XSpectrum256_pl *InstancePtr, u32 Data);
u32 XSpectrum256_pl_Get_sequence_r(XSpectrum256_pl *InstancePtr);
void XSpectrum256_pl_Set_valid_sample(XSpectrum256_pl *InstancePtr, u32 Data);
u32 XSpectrum256_pl_Get_valid_sample(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_Get_status(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_Get_status_vld(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_Get_count(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_Get_count_vld(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_Get_epoch(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_Get_epoch_vld(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_Get_last_sequence(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_Get_last_sequence_vld(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_Get_clipped_bins(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_Get_clipped_bins_vld(XSpectrum256_pl *InstancePtr);

void XSpectrum256_pl_InterruptGlobalEnable(XSpectrum256_pl *InstancePtr);
void XSpectrum256_pl_InterruptGlobalDisable(XSpectrum256_pl *InstancePtr);
void XSpectrum256_pl_InterruptEnable(XSpectrum256_pl *InstancePtr, u32 Mask);
void XSpectrum256_pl_InterruptDisable(XSpectrum256_pl *InstancePtr, u32 Mask);
void XSpectrum256_pl_InterruptClear(XSpectrum256_pl *InstancePtr, u32 Mask);
u32 XSpectrum256_pl_InterruptGetEnabled(XSpectrum256_pl *InstancePtr);
u32 XSpectrum256_pl_InterruptGetStatus(XSpectrum256_pl *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
