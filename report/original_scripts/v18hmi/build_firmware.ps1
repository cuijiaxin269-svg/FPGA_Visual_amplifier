param([string]$GccRoot='D:/xilinx/Vitis/2021.2/gnu/aarch32/nt/gcc-arm-none-eabi/bin')
$ErrorActionPreference='Stop'
$hmiBuildRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
Push-Location $hmiBuildRoot
try {
 New-Item -ItemType Directory -Force 'build/firmware' | Out-Null
 $sources=@('sw/start.S','sw/main.c','sw/platform.c','sw/ov9281.c','sw/motion60.c','sw/motion60_spectrum_pl_driver.c','sw/motion60_clip_record.c','sw/motion60_clip_driver.c','sw/motion60_clip_pl.c','sw/motion60_clip_playback.c','sw/hmi_protocol.c','sw/hmi_link.c','sw/hmi_uart.c')
 # MMU is disabled: packed wire bytes must never become unaligned word loads.
 & (Join-Path $GccRoot 'arm-none-eabi-gcc.exe') -DMOTION60_HMI -DMOTION60_BUTTON -DMOTION60_CAMERA_CONTROLS -DMOTION60_FIRMWARE -DMOTION60_SPECTRUM -DMOTION60_CLIP -DMOTION60_PL_OFFLINE -DMOTION60_PL_SPECTRUM -mcpu=cortex-a9 -marm -mfloat-abi=soft -mno-unaligned-access -O2 -g -ffreestanding -fno-builtin -Wall -Wextra -Werror -nostdlib '-Wl,--build-id=none,-Map=build/firmware/motion60.map' -T sw/link.ld @sources -lgcc -o 'build/firmware/motion60.elf'
 if($LASTEXITCODE){throw 'HMI firmware compile/link failed'}
 & (Join-Path $GccRoot 'arm-none-eabi-size.exe') 'build/firmware/motion60.elf'
 if($LASTEXITCODE){throw 'ELF inspection failed'}
 & C:/msys64/ucrt64/bin/python.exe -I -B scripts/input_receipt.py firmware
 if($LASTEXITCODE){throw 'Firmware input receipt failed'}
 Write-Output 'HMI_ARM_FIRMWARE_BUILT'
} finally {Pop-Location}
