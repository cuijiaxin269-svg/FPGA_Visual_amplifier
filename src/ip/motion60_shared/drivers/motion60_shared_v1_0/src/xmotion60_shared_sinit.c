// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2.1 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xmotion60_shared.h"

extern XMotion60_shared_Config XMotion60_shared_ConfigTable[];

#ifdef SDT
XMotion60_shared_Config *XMotion60_shared_LookupConfig(UINTPTR BaseAddress) {
	XMotion60_shared_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XMotion60_shared_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XMotion60_shared_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XMotion60_shared_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XMotion60_shared_Initialize(XMotion60_shared *InstancePtr, UINTPTR BaseAddress) {
	XMotion60_shared_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XMotion60_shared_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XMotion60_shared_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XMotion60_shared_Config *XMotion60_shared_LookupConfig(u16 DeviceId) {
	XMotion60_shared_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XMOTION60_SHARED_NUM_INSTANCES; Index++) {
		if (XMotion60_shared_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XMotion60_shared_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XMotion60_shared_Initialize(XMotion60_shared *InstancePtr, u16 DeviceId) {
	XMotion60_shared_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XMotion60_shared_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XMotion60_shared_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

