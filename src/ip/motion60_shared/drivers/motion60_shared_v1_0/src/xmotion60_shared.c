// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xmotion60_shared.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XMotion60_shared_CfgInitialize(XMotion60_shared *InstancePtr, XMotion60_shared_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XMotion60_shared_Start(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_AP_CTRL) & 0x80;
    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XMotion60_shared_IsDone(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XMotion60_shared_IsIdle(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XMotion60_shared_IsReady(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XMotion60_shared_EnableAutoRestart(XMotion60_shared *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XMotion60_shared_DisableAutoRestart(XMotion60_shared *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_AP_CTRL, 0);
}

void XMotion60_shared_Set_input_r(XMotion60_shared *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_INPUT_R_DATA, (u32)(Data));
    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_INPUT_R_DATA + 4, (u32)(Data >> 32));
}

u64 XMotion60_shared_Get_input_r(XMotion60_shared *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_INPUT_R_DATA);
    Data += (u64)XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_INPUT_R_DATA + 4) << 32;
    return Data;
}

void XMotion60_shared_Set_output_r(XMotion60_shared *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_OUTPUT_R_DATA, (u32)(Data));
    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_OUTPUT_R_DATA + 4, (u32)(Data >> 32));
}

u64 XMotion60_shared_Get_output_r(XMotion60_shared *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_OUTPUT_R_DATA);
    Data += (u64)XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_OUTPUT_R_DATA + 4) << 32;
    return Data;
}

void XMotion60_shared_Set_state0_r(XMotion60_shared *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE0_R_DATA, (u32)(Data));
    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE0_R_DATA + 4, (u32)(Data >> 32));
}

u64 XMotion60_shared_Get_state0_r(XMotion60_shared *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE0_R_DATA);
    Data += (u64)XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE0_R_DATA + 4) << 32;
    return Data;
}

void XMotion60_shared_Set_state1_r(XMotion60_shared *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE1_R_DATA, (u32)(Data));
    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE1_R_DATA + 4, (u32)(Data >> 32));
}

u64 XMotion60_shared_Get_state1_r(XMotion60_shared *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE1_R_DATA);
    Data += (u64)XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE1_R_DATA + 4) << 32;
    return Data;
}

void XMotion60_shared_Set_state2_r(XMotion60_shared *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE2_R_DATA, (u32)(Data));
    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE2_R_DATA + 4, (u32)(Data >> 32));
}

u64 XMotion60_shared_Get_state2_r(XMotion60_shared *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE2_R_DATA);
    Data += (u64)XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATE2_R_DATA + 4) << 32;
    return Data;
}

void XMotion60_shared_Set_b0(XMotion60_shared *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_B0_DATA, Data);
}

u32 XMotion60_shared_Get_b0(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_B0_DATA);
    return Data;
}

void XMotion60_shared_Set_b2(XMotion60_shared *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_B2_DATA, Data);
}

u32 XMotion60_shared_Get_b2(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_B2_DATA);
    return Data;
}

void XMotion60_shared_Set_a1(XMotion60_shared *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_A1_DATA, Data);
}

u32 XMotion60_shared_Get_a1(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_A1_DATA);
    return Data;
}

void XMotion60_shared_Set_a2(XMotion60_shared *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_A2_DATA, Data);
}

u32 XMotion60_shared_Get_a2(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_A2_DATA);
    return Data;
}

void XMotion60_shared_Set_alpha(XMotion60_shared *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_ALPHA_DATA, Data);
}

u32 XMotion60_shared_Get_alpha(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_ALPHA_DATA);
    return Data;
}

void XMotion60_shared_Set_first_frame(XMotion60_shared *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_FIRST_FRAME_DATA, Data);
}

u32 XMotion60_shared_Get_first_frame(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_FIRST_FRAME_DATA);
    return Data;
}

void XMotion60_shared_Set_mode(XMotion60_shared *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_MODE_DATA, Data);
}

u32 XMotion60_shared_Get_mode(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_MODE_DATA);
    return Data;
}

u32 XMotion60_shared_Get_status(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATUS_DATA);
    return Data;
}

u32 XMotion60_shared_Get_status_vld(XMotion60_shared *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_STATUS_CTRL);
    return Data & 0x1;
}

void XMotion60_shared_InterruptGlobalEnable(XMotion60_shared *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_GIE, 1);
}

void XMotion60_shared_InterruptGlobalDisable(XMotion60_shared *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_GIE, 0);
}

void XMotion60_shared_InterruptEnable(XMotion60_shared *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_IER);
    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_IER, Register | Mask);
}

void XMotion60_shared_InterruptDisable(XMotion60_shared *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_IER);
    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_IER, Register & (~Mask));
}

void XMotion60_shared_InterruptClear(XMotion60_shared *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMotion60_shared_WriteReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_ISR, Mask);
}

u32 XMotion60_shared_InterruptGetEnabled(XMotion60_shared *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_IER);
}

u32 XMotion60_shared_InterruptGetStatus(XMotion60_shared *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XMotion60_shared_ReadReg(InstancePtr->Control_BaseAddress, XMOTION60_SHARED_CONTROL_ADDR_ISR);
}

