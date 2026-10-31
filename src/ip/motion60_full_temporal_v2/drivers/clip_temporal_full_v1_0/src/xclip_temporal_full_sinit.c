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
#include "xclip_temporal_full.h"

extern XClip_temporal_full_Config XClip_temporal_full_ConfigTable[];

#ifdef SDT
XClip_temporal_full_Config *XClip_temporal_full_LookupConfig(UINTPTR BaseAddress) {
	XClip_temporal_full_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XClip_temporal_full_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XClip_temporal_full_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XClip_temporal_full_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XClip_temporal_full_Initialize(XClip_temporal_full *InstancePtr, UINTPTR BaseAddress) {
	XClip_temporal_full_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XClip_temporal_full_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XClip_temporal_full_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XClip_temporal_full_Config *XClip_temporal_full_LookupConfig(u16 DeviceId) {
	XClip_temporal_full_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XCLIP_TEMPORAL_FULL_NUM_INSTANCES; Index++) {
		if (XClip_temporal_full_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XClip_temporal_full_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XClip_temporal_full_Initialize(XClip_temporal_full *InstancePtr, u16 DeviceId) {
	XClip_temporal_full_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XClip_temporal_full_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XClip_temporal_full_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

