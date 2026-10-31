// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xclip_copy_checked.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XClip_copy_checked_CfgInitialize(XClip_copy_checked *InstancePtr, XClip_copy_checked_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XClip_copy_checked_Start(XClip_copy_checked *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_AP_CTRL) & 0x80;
    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XClip_copy_checked_IsDone(XClip_copy_checked *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XClip_copy_checked_IsIdle(XClip_copy_checked *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XClip_copy_checked_IsReady(XClip_copy_checked *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XClip_copy_checked_EnableAutoRestart(XClip_copy_checked *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XClip_copy_checked_DisableAutoRestart(XClip_copy_checked *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_AP_CTRL, 0);
}

void XClip_copy_checked_Set_source(XClip_copy_checked *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_SOURCE_DATA, (u32)(Data));
    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_SOURCE_DATA + 4, (u32)(Data >> 32));
}

u64 XClip_copy_checked_Get_source(XClip_copy_checked *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_SOURCE_DATA);
    Data += (u64)XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_SOURCE_DATA + 4) << 32;
    return Data;
}

void XClip_copy_checked_Set_destination(XClip_copy_checked *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_DESTINATION_DATA, (u32)(Data));
    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_DESTINATION_DATA + 4, (u32)(Data >> 32));
}

u64 XClip_copy_checked_Get_destination(XClip_copy_checked *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_DESTINATION_DATA);
    Data += (u64)XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_DESTINATION_DATA + 4) << 32;
    return Data;
}

void XClip_copy_checked_Set_valid_source(XClip_copy_checked *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_VALID_SOURCE_DATA, Data);
}

u32 XClip_copy_checked_Get_valid_source(XClip_copy_checked *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_VALID_SOURCE_DATA);
    return Data;
}

u32 XClip_copy_checked_Get_status(XClip_copy_checked *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_STATUS_DATA);
    return Data;
}

u32 XClip_copy_checked_Get_status_vld(XClip_copy_checked *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_STATUS_CTRL);
    return Data & 0x1;
}

void XClip_copy_checked_InterruptGlobalEnable(XClip_copy_checked *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_GIE, 1);
}

void XClip_copy_checked_InterruptGlobalDisable(XClip_copy_checked *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_GIE, 0);
}

void XClip_copy_checked_InterruptEnable(XClip_copy_checked *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_IER);
    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_IER, Register | Mask);
}

void XClip_copy_checked_InterruptDisable(XClip_copy_checked *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_IER);
    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_IER, Register & (~Mask));
}

void XClip_copy_checked_InterruptClear(XClip_copy_checked *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XClip_copy_checked_WriteReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_ISR, Mask);
}

u32 XClip_copy_checked_InterruptGetEnabled(XClip_copy_checked *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_IER);
}

u32 XClip_copy_checked_InterruptGetStatus(XClip_copy_checked *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XClip_copy_checked_ReadReg(InstancePtr->Control_BaseAddress, XCLIP_COPY_CHECKED_CONTROL_ADDR_ISR);
}

