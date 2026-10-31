// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XMOTION60_SHARED_H
#define XMOTION60_SHARED_H

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
#include "xmotion60_shared_hw.h"

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
} XMotion60_shared_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XMotion60_shared;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XMotion60_shared_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XMotion60_shared_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XMotion60_shared_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XMotion60_shared_ReadReg(BaseAddress, RegOffset) \
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
int XMotion60_shared_Initialize(XMotion60_shared *InstancePtr, UINTPTR BaseAddress);
XMotion60_shared_Config* XMotion60_shared_LookupConfig(UINTPTR BaseAddress);
#else
int XMotion60_shared_Initialize(XMotion60_shared *InstancePtr, u16 DeviceId);
XMotion60_shared_Config* XMotion60_shared_LookupConfig(u16 DeviceId);
#endif
int XMotion60_shared_CfgInitialize(XMotion60_shared *InstancePtr, XMotion60_shared_Config *ConfigPtr);
#else
int XMotion60_shared_Initialize(XMotion60_shared *InstancePtr, const char* InstanceName);
int XMotion60_shared_Release(XMotion60_shared *InstancePtr);
#endif

void XMotion60_shared_Start(XMotion60_shared *InstancePtr);
u32 XMotion60_shared_IsDone(XMotion60_shared *InstancePtr);
u32 XMotion60_shared_IsIdle(XMotion60_shared *InstancePtr);
u32 XMotion60_shared_IsReady(XMotion60_shared *InstancePtr);
void XMotion60_shared_EnableAutoRestart(XMotion60_shared *InstancePtr);
void XMotion60_shared_DisableAutoRestart(XMotion60_shared *InstancePtr);

void XMotion60_shared_Set_input_r(XMotion60_shared *InstancePtr, u64 Data);
u64 XMotion60_shared_Get_input_r(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_output_r(XMotion60_shared *InstancePtr, u64 Data);
u64 XMotion60_shared_Get_output_r(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_state0_r(XMotion60_shared *InstancePtr, u64 Data);
u64 XMotion60_shared_Get_state0_r(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_state1_r(XMotion60_shared *InstancePtr, u64 Data);
u64 XMotion60_shared_Get_state1_r(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_state2_r(XMotion60_shared *InstancePtr, u64 Data);
u64 XMotion60_shared_Get_state2_r(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_b0(XMotion60_shared *InstancePtr, u32 Data);
u32 XMotion60_shared_Get_b0(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_b2(XMotion60_shared *InstancePtr, u32 Data);
u32 XMotion60_shared_Get_b2(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_a1(XMotion60_shared *InstancePtr, u32 Data);
u32 XMotion60_shared_Get_a1(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_a2(XMotion60_shared *InstancePtr, u32 Data);
u32 XMotion60_shared_Get_a2(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_alpha(XMotion60_shared *InstancePtr, u32 Data);
u32 XMotion60_shared_Get_alpha(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_first_frame(XMotion60_shared *InstancePtr, u32 Data);
u32 XMotion60_shared_Get_first_frame(XMotion60_shared *InstancePtr);
void XMotion60_shared_Set_mode(XMotion60_shared *InstancePtr, u32 Data);
u32 XMotion60_shared_Get_mode(XMotion60_shared *InstancePtr);
u32 XMotion60_shared_Get_status(XMotion60_shared *InstancePtr);
u32 XMotion60_shared_Get_status_vld(XMotion60_shared *InstancePtr);

void XMotion60_shared_InterruptGlobalEnable(XMotion60_shared *InstancePtr);
void XMotion60_shared_InterruptGlobalDisable(XMotion60_shared *InstancePtr);
void XMotion60_shared_InterruptEnable(XMotion60_shared *InstancePtr, u32 Mask);
void XMotion60_shared_InterruptDisable(XMotion60_shared *InstancePtr, u32 Mask);
void XMotion60_shared_InterruptClear(XMotion60_shared *InstancePtr, u32 Mask);
u32 XMotion60_shared_InterruptGetEnabled(XMotion60_shared *InstancePtr);
u32 XMotion60_shared_InterruptGetStatus(XMotion60_shared *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
