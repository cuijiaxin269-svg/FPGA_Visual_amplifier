// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xclip_temporal_full.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XClip_temporal_full_CfgInitialize(XClip_temporal_full *InstancePtr, XClip_temporal_full_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XClip_temporal_full_Start(XClip_temporal_full *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_AP_CTRL) & 0x80;
    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XClip_temporal_full_IsDone(XClip_temporal_full *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XClip_temporal_full_IsIdle(XClip_temporal_full *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XClip_temporal_full_IsReady(XClip_temporal_full *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XClip_temporal_full_EnableAutoRestart(XClip_temporal_full *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XClip_temporal_full_DisableAutoRestart(XClip_temporal_full *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_AP_CTRL, 0);
}

void XClip_temporal_full_Set_phase(XClip_temporal_full *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_PHASE_DATA, (u32)(Data));
    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_PHASE_DATA + 4, (u32)(Data >> 32));
}

u64 XClip_temporal_full_Get_phase(XClip_temporal_full *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_PHASE_DATA);
    Data += (u64)XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_PHASE_DATA + 4) << 32;
    return Data;
}

void XClip_temporal_full_Set_frames(XClip_temporal_full *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_FRAMES_DATA, Data);
}

u32 XClip_temporal_full_Get_frames(XClip_temporal_full *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_FRAMES_DATA);
    return Data;
}

void XClip_temporal_full_Set_pixels(XClip_temporal_full *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_PIXELS_DATA, Data);
}

u32 XClip_temporal_full_Get_pixels(XClip_temporal_full *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_PIXELS_DATA);
    return Data;
}

void XClip_temporal_full_Set_fps(XClip_temporal_full *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_FPS_DATA, (u32)(Data));
    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_FPS_DATA + 4, (u32)(Data >> 32));
}

u64 XClip_temporal_full_Get_fps(XClip_temporal_full *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_FPS_DATA);
    Data += (u64)XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_FPS_DATA + 4) << 32;
    return Data;
}

void XClip_temporal_full_Set_low_r(XClip_temporal_full *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_LOW_R_DATA, (u32)(Data));
    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_LOW_R_DATA + 4, (u32)(Data >> 32));
}

u64 XClip_temporal_full_Get_low_r(XClip_temporal_full *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_LOW_R_DATA);
    Data += (u64)XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_LOW_R_DATA + 4) << 32;
    return Data;
}

void XClip_temporal_full_Set_high_r(XClip_temporal_full *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_HIGH_R_DATA, (u32)(Data));
    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_HIGH_R_DATA + 4, (u32)(Data >> 32));
}

u64 XClip_temporal_full_Get_high_r(XClip_temporal_full *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_HIGH_R_DATA);
    Data += (u64)XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_HIGH_R_DATA + 4) << 32;
    return Data;
}

void XClip_temporal_full_Set_valid_clip(XClip_temporal_full *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_VALID_CLIP_DATA, Data);
}

u32 XClip_temporal_full_Get_valid_clip(XClip_temporal_full *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_VALID_CLIP_DATA);
    return Data;
}

u32 XClip_temporal_full_Get_status(XClip_temporal_full *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_STATUS_DATA);
    return Data;
}

u32 XClip_temporal_full_Get_status_vld(XClip_temporal_full *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_STATUS_CTRL);
    return Data & 0x1;
}

void XClip_temporal_full_InterruptGlobalEnable(XClip_temporal_full *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_GIE, 1);
}

void XClip_temporal_full_InterruptGlobalDisable(XClip_temporal_full *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_GIE, 0);
}

void XClip_temporal_full_InterruptEnable(XClip_temporal_full *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_IER);
    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_IER, Register | Mask);
}

void XClip_temporal_full_InterruptDisable(XClip_temporal_full *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_IER);
    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_IER, Register & (~Mask));
}

void XClip_temporal_full_InterruptClear(XClip_temporal_full *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_temporal_full_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_ISR, Mask);
}

u32 XClip_temporal_full_InterruptGetEnabled(XClip_temporal_full *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_IER);
}

u32 XClip_temporal_full_InterruptGetStatus(XClip_temporal_full *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XClip_temporal_full_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_TEMPORAL_FULL_CONTROL_ADDR_ISR);
}

