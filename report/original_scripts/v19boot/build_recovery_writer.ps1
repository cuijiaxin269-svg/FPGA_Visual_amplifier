$ErrorActionPreference='Stop'
$writerRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
Push-Location $writerRoot
try {
 $sealedImageHash=(Get-FileHash -LiteralPath build/candidate/BOOT.BIN -Algorithm SHA256).Hash.ToLower()
 if($sealedImageHash -ne 'eae2d50a02ab3f8aaa2574d2fcd9573cc657461bc64690f1b1f17b84ba013e54'){throw 'Recovery writer is bound to the reviewed image'}
 & D:/xilinx/Vitis/2021.2/gnu/aarch32/nt/gcc-arm-none-eabi/bin/arm-none-eabi-gcc.exe -DIMAGE_BYTES=13299932u -DIMAGE_CRC=0x84cb6227u -DTAIL_CRC=0x15890968u -O2 -g -mcpu=cortex-a9 -marm -mfloat-abi=hard -mfpu=vfpv3 -mno-unaligned-access -ffreestanding -fno-builtin -nostdlib -Wall -Wextra -Werror '-Wl,--build-id=none' -I build/fsbl/zynq_fsbl_bsp/ps7_cortexa9_0/include -T sw/link.ld sw/start.S board/qspi_program.c -L build/fsbl/zynq_fsbl_bsp/ps7_cortexa9_0/lib '-Wl,--start-group' -lxil -lc -lgcc '-Wl,--end-group' -o build/qspi_program.elf
 if($LASTEXITCODE){throw 'Recovery writer build failed'}
 Write-Output 'V19_RECOVERY_WRITER_BUILT'
} finally {Pop-Location}
