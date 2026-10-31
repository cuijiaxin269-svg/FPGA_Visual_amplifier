// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xspectrum256_pl.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XSpectrum256_pl_CfgInitialize(XSpectrum256_pl *InstancePtr, XSpectrum256_pl_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XSpectrum256_pl_Start(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_AP_CTRL) & 0x80;
    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XSpectrum256_pl_IsDone(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XSpectrum256_pl_IsIdle(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XSpectrum256_pl_IsReady(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XSpectrum256_pl_EnableAutoRestart(XSpectrum256_pl *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XSpectrum256_pl_DisableAutoRestart(XSpectrum256_pl *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_AP_CTRL, 0);
}

void XSpectrum256_pl_Set_motion(XSpectrum256_pl *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_MOTION_DATA, (u32)(Data));
    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_MOTION_DATA + 4, (u32)(Data >> 32));
}

u64 XSpectrum256_pl_Get_motion(XSpectrum256_pl *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_MOTION_DATA);
    Data += (u64)XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_MOTION_DATA + 4) << 32;
    return Data;
}

void XSpectrum256_pl_Set_output_r(XSpectrum256_pl *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_OUTPUT_R_DATA, (u32)(Data));
    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_OUTPUT_R_DATA + 4, (u32)(Data >> 32));
}

u64 XSpectrum256_pl_Get_output_r(XSpectrum256_pl *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_OUTPUT_R_DATA);
    Data += (u64)XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_OUTPUT_R_DATA + 4) << 32;
    return Data;
}

void XSpectrum256_pl_Set_operation(XSpectrum256_pl *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_OPERATION_DATA, Data);
}

u32 XSpectrum256_pl_Get_operation(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_OPERATION_DATA);
    return Data;
}

void XSpectrum256_pl_Set_sequence_r(XSpectrum256_pl *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_SEQUENCE_R_DATA, Data);
}

u32 XSpectrum256_pl_Get_sequence_r(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_SEQUENCE_R_DATA);
    return Data;
}

void XSpectrum256_pl_Set_valid_sample(XSpectrum256_pl *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_VALID_SAMPLE_DATA, Data);
}

u32 XSpectrum256_pl_Get_valid_sample(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_VALID_SAMPLE_DATA);
    return Data;
}

u32 XSpectrum256_pl_Get_status(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_STATUS_DATA);
    return Data;
}

u32 XSpectrum256_pl_Get_status_vld(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_STATUS_CTRL);
    return Data & 0x1;
}

u32 XSpectrum256_pl_Get_count(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_COUNT_DATA);
    return Data;
}

u32 XSpectrum256_pl_Get_count_vld(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_COUNT_CTRL);
    return Data & 0x1;
}

u32 XSpectrum256_pl_Get_epoch(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_EPOCH_DATA);
    return Data;
}

u32 XSpectrum256_pl_Get_epoch_vld(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_EPOCH_CTRL);
    return Data & 0x1;
}

u32 XSpectrum256_pl_Get_last_sequence(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_LAST_SEQUENCE_DATA);
    return Data;
}

u32 XSpectrum256_pl_Get_last_sequence_vld(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_LAST_SEQUENCE_CTRL);
    return Data & 0x1;
}

u32 XSpectrum256_pl_Get_clipped_bins(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_CLIPPED_BINS_DATA);
    return Data;
}

u32 XSpectrum256_pl_Get_clipped_bins_vld(XSpectrum256_pl *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_CLIPPED_BINS_CTRL);
    return Data & 0x1;
}

void XSpectrum256_pl_InterruptGlobalEnable(XSpectrum256_pl *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_GIE, 1);
}

void XSpectrum256_pl_InterruptGlobalDisable(XSpectrum256_pl *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_GIE, 0);
}

void XSpectrum256_pl_InterruptEnable(XSpectrum256_pl *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_IER);
    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_IER, Register | Mask);
}

void XSpectrum256_pl_InterruptDisable(XSpectrum256_pl *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_IER);
    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_IER, Register & (~Mask));
}

void XSpectrum256_pl_InterruptClear(XSpectrum256_pl *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSpectrum256_pl_WriteReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_ISR, Mask);
}

u32 XSpectrum256_pl_InterruptGetEnabled(XSpectrum256_pl *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_IER);
}

u32 XSpectrum256_pl_InterruptGetStatus(XSpectrum256_pl *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XSpectrum256_pl_ReadReg(InstancePtr->Control_BaseAddress, XSPECTRUM256_PL_CONTROL_ADDR_ISR);
}

