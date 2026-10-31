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
#include "xspectrum256_pl.h"

extern XSpectrum256_pl_Config XSpectrum256_pl_ConfigTable[];

#ifdef SDT
XSpectrum256_pl_Config *XSpectrum256_pl_LookupConfig(UINTPTR BaseAddress) {
	XSpectrum256_pl_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XSpectrum256_pl_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XSpectrum256_pl_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XSpectrum256_pl_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XSpectrum256_pl_Initialize(XSpectrum256_pl *InstancePtr, UINTPTR BaseAddress) {
	XSpectrum256_pl_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XSpectrum256_pl_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XSpectrum256_pl_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XSpectrum256_pl_Config *XSpectrum256_pl_LookupConfig(u16 DeviceId) {
	XSpectrum256_pl_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XSPECTRUM256_PL_NUM_INSTANCES; Index++) {
		if (XSpectrum256_pl_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XSpectrum256_pl_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XSpectrum256_pl_Initialize(XSpectrum256_pl *InstancePtr, u16 DeviceId) {
	XSpectrum256_pl_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XSpectrum256_pl_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XSpectrum256_pl_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

