// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xroi256.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XRoi256_CfgInitialize(XRoi256 *InstancePtr, XRoi256_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XRoi256_Start(XRoi256 *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_AP_CTRL) & 0x80;
    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XRoi256_IsDone(XRoi256 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XRoi256_IsIdle(XRoi256 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XRoi256_IsReady(XRoi256 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XRoi256_EnableAutoRestart(XRoi256 *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XRoi256_DisableAutoRestart(XRoi256 *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_AP_CTRL, 0);
}

void XRoi256_Set_input_r(XRoi256 *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_INPUT_R_DATA, (u32)(Data));
    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_INPUT_R_DATA + 4, (u32)(Data >> 32));
}

u64 XRoi256_Get_input_r(XRoi256 *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_INPUT_R_DATA);
    Data += (u64)XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_INPUT_R_DATA + 4) << 32;
    return Data;
}

void XRoi256_Set_output_r(XRoi256 *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_OUTPUT_R_DATA, (u32)(Data));
    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_OUTPUT_R_DATA + 4, (u32)(Data >> 32));
}

u64 XRoi256_Get_output_r(XRoi256 *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_OUTPUT_R_DATA);
    Data += (u64)XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_OUTPUT_R_DATA + 4) << 32;
    return Data;
}

void XRoi256_Set_x(XRoi256 *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_X_DATA, Data);
}

u32 XRoi256_Get_x(XRoi256 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_X_DATA);
    return Data;
}

void XRoi256_Set_y(XRoi256 *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_Y_DATA, Data);
}

u32 XRoi256_Get_y(XRoi256 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_Y_DATA);
    return Data;
}

void XRoi256_Set_first_frame(XRoi256 *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_FIRST_FRAME_DATA, Data);
}

u32 XRoi256_Get_first_frame(XRoi256 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_FIRST_FRAME_DATA);
    return Data;
}

void XRoi256_Set_valid_frame(XRoi256 *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_VALID_FRAME_DATA, Data);
}

u32 XRoi256_Get_valid_frame(XRoi256 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_VALID_FRAME_DATA);
    return Data;
}

u32 XRoi256_Get_status(XRoi256 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_STATUS_DATA);
    return Data;
}

u32 XRoi256_Get_status_vld(XRoi256 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_STATUS_CTRL);
    return Data & 0x1;
}

void XRoi256_InterruptGlobalEnable(XRoi256 *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_GIE, 1);
}

void XRoi256_InterruptGlobalDisable(XRoi256 *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_GIE, 0);
}

void XRoi256_InterruptEnable(XRoi256 *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_IER);
    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_IER, Register | Mask);
}

void XRoi256_InterruptDisable(XRoi256 *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_IER);
    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_IER, Register & (~Mask));
}

void XRoi256_InterruptClear(XRoi256 *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XRoi256_WriteReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_ISR, Mask);
}

u32 XRoi256_InterruptGetEnabled(XRoi256 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_IER);
}

u32 XRoi256_InterruptGetStatus(XRoi256 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XRoi256_ReadReg(InstancePtr->Control_BaseAddress, XROI256_CONTROL_ADDR_ISR);
}

