// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XROI256_H
#define XROI256_H

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
#include "xroi256_hw.h"

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
} XRoi256_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XRoi256;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XRoi256_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XRoi256_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XRoi256_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XRoi256_ReadReg(BaseAddress, RegOffset) \
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
int XRoi256_Initialize(XRoi256 *InstancePtr, UINTPTR BaseAddress);
XRoi256_Config* XRoi256_LookupConfig(UINTPTR BaseAddress);
#else
int XRoi256_Initialize(XRoi256 *InstancePtr, u16 DeviceId);
XRoi256_Config* XRoi256_LookupConfig(u16 DeviceId);
#endif
int XRoi256_CfgInitialize(XRoi256 *InstancePtr, XRoi256_Config *ConfigPtr);
#else
int XRoi256_Initialize(XRoi256 *InstancePtr, const char* InstanceName);
int XRoi256_Release(XRoi256 *InstancePtr);
#endif

void XRoi256_Start(XRoi256 *InstancePtr);
u32 XRoi256_IsDone(XRoi256 *InstancePtr);
u32 XRoi256_IsIdle(XRoi256 *InstancePtr);
u32 XRoi256_IsReady(XRoi256 *InstancePtr);
void XRoi256_EnableAutoRestart(XRoi256 *InstancePtr);
void XRoi256_DisableAutoRestart(XRoi256 *InstancePtr);

void XRoi256_Set_input_r(XRoi256 *InstancePtr, u64 Data);
u64 XRoi256_Get_input_r(XRoi256 *InstancePtr);
void XRoi256_Set_output_r(XRoi256 *InstancePtr, u64 Data);
u64 XRoi256_Get_output_r(XRoi256 *InstancePtr);
void XRoi256_Set_x(XRoi256 *InstancePtr, u32 Data);
u32 XRoi256_Get_x(XRoi256 *InstancePtr);
void XRoi256_Set_y(XRoi256 *InstancePtr, u32 Data);
u32 XRoi256_Get_y(XRoi256 *InstancePtr);
void XRoi256_Set_first_frame(XRoi256 *InstancePtr, u32 Data);
u32 XRoi256_Get_first_frame(XRoi256 *InstancePtr);
void XRoi256_Set_valid_frame(XRoi256 *InstancePtr, u32 Data);
u32 XRoi256_Get_valid_frame(XRoi256 *InstancePtr);
u32 XRoi256_Get_status(XRoi256 *InstancePtr);
u32 XRoi256_Get_status_vld(XRoi256 *InstancePtr);

void XRoi256_InterruptGlobalEnable(XRoi256 *InstancePtr);
void XRoi256_InterruptGlobalDisable(XRoi256 *InstancePtr);
void XRoi256_InterruptEnable(XRoi256 *InstancePtr, u32 Mask);
void XRoi256_InterruptDisable(XRoi256 *InstancePtr, u32 Mask);
void XRoi256_InterruptClear(XRoi256 *InstancePtr, u32 Mask);
u32 XRoi256_InterruptGetEnabled(XRoi256 *InstancePtr);
u32 XRoi256_InterruptGetStatus(XRoi256 *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
