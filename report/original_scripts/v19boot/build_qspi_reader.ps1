$ErrorActionPreference='Stop'
$readerRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
Push-Location $readerRoot
try {
 foreach($mode in @('read','verify')){
  $readerDefines=@();if($mode -eq 'verify'){$readerDefines=@('-DVERIFY_ONLY')}
  & D:/xilinx/Vitis/2021.2/gnu/aarch32/nt/gcc-arm-none-eabi/bin/arm-none-eabi-gcc.exe @readerDefines -O2 -g -mcpu=cortex-a9 -marm -mfloat-abi=hard -mfpu=vfpv3 -mno-unaligned-access -ffreestanding -fno-builtin -nostdlib -Wall -Wextra -Werror '-Wl,--build-id=none' -I build/fsbl/zynq_fsbl_bsp/ps7_cortexa9_0/include -T sw/link.ld sw/start.S board/qspi_read.c -L build/fsbl/zynq_fsbl_bsp/ps7_cortexa9_0/lib '-Wl,--start-group' -lxil -lc -lgcc '-Wl,--end-group' -o "build/qspi_$mode.elf"
  if($LASTEXITCODE){throw "Reader build failed: $mode"}
 }
 Write-Output 'V19_READ_ONLY_FLASH_TOOLS_BUILT'
} finally {Pop-Location}
