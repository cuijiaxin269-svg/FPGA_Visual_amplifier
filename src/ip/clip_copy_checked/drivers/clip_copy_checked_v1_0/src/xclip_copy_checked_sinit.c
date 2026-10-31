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
#include "xclip_copy_checked.h"

extern XClip_copy_checked_Config XClip_copy_checked_ConfigTable[];

#ifdef SDT
XClip_copy_checked_Config *XClip_copy_checked_LookupConfig(UINTPTR BaseAddress) {
	XClip_copy_checked_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XClip_copy_checked_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XClip_copy_checked_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XClip_copy_checked_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XClip_copy_checked_Initialize(XClip_copy_checked *InstancePtr, UINTPTR BaseAddress) {
	XClip_copy_checked_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XClip_copy_checked_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XClip_copy_checked_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XClip_copy_checked_Config *XClip_copy_checked_LookupConfig(u16 DeviceId) {
	XClip_copy_checked_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XCLIP_COPY_CHECKED_NUM_INSTANCES; Index++) {
		if (XClip_copy_checked_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XClip_copy_checked_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XClip_copy_checked_Initialize(XClip_copy_checked *InstancePtr, u16 DeviceId) {
	XClip_copy_checked_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XClip_copy_checked_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XClip_copy_checked_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

