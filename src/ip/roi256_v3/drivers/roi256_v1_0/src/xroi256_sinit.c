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
#include "xroi256.h"

extern XRoi256_Config XRoi256_ConfigTable[];

#ifdef SDT
XRoi256_Config *XRoi256_LookupConfig(UINTPTR BaseAddress) {
	XRoi256_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XRoi256_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XRoi256_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XRoi256_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XRoi256_Initialize(XRoi256 *InstancePtr, UINTPTR BaseAddress) {
	XRoi256_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XRoi256_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XRoi256_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XRoi256_Config *XRoi256_LookupConfig(u16 DeviceId) {
	XRoi256_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XROI256_NUM_INSTANCES; Index++) {
		if (XRoi256_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XRoi256_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XRoi256_Initialize(XRoi256 *InstancePtr, u16 DeviceId) {
	XRoi256_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XRoi256_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XRoi256_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

