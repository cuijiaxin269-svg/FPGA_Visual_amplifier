$ErrorActionPreference='Stop'
$bootRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$bootPython='C:/msys64/ucrt64/bin/python.exe'
$env:PYTHONUTF8='1'
& $bootPython -I -B (Join-Path $PSScriptRoot 'audit_platform.py')
if($LASTEXITCODE){throw 'Platform compatibility failed'}
$bsp=Join-Path $bootRoot 'build/fsbl/zynq_fsbl_bsp/ps7_cortexa9_0'
$parameters=Get-Content (Join-Path $bsp 'include/xparameters.h') -Raw
if($parameters -notmatch '#define STDOUT_BASEADDRESS 0xE0000000' -or $parameters -notmatch '#define XPAR_PS7_QSPI_LINEAR_0_S_AXI_BASEADDR') {throw 'FSBL requires UART0 stdout and QSPI'}
$bootPath=$env:PATH
$env:PATH='D:/xilinx/Vitis/2021.2/gnu/aarch32/nt/gcc-arm-none-eabi/bin;D:/xilinx/Vitis/2021.2/gnuwin/bin;'+$env:PATH
Push-Location (Join-Path $bootRoot 'build/fsbl')
try {
 & make -B 'CFLAGS=-DFSBL_DEBUG_INFO -mno-unaligned-access'
 if($LASTEXITCODE){throw 'FSBL build failed'}
} finally {Pop-Location;$env:PATH=$bootPath}
Copy-Item -LiteralPath (Join-Path $bootRoot 'build/fsbl/executable.elf') -Destination (Join-Path $bootRoot 'build/candidate/fsbl.elf')
Copy-Item -LiteralPath (Join-Path $bootRoot 'build/firmware/motion60.elf') -Destination (Join-Path $bootRoot 'build/candidate/motion60.elf')
Push-Location (Join-Path $bootRoot 'build/candidate')
try {
 @'
the_ROM_image:
{
  [bootloader] fsbl.elf
  capture.bit
  motion60.elf
}
'@ | Set-Content -LiteralPath boot.bif -Encoding ascii
 & D:/xilinx/Vitis/2021.2/bin/bootgen.bat -arch zynq -image boot.bif -o BOOT.BIN -w on
 if($LASTEXITCODE){throw 'Bootgen failed'}
 if((Get-Item BOOT.BIN).Length -gt 0x01000000){throw 'Boot image exceeds physical 16 MiB flash'}
 & D:/xilinx/Vitis/2021.2/bin/bootgen.bat -arch zynq -read BOOT.BIN *> (Join-Path $bootRoot 'reports/bootgen_read.txt')
 if($LASTEXITCODE){throw 'Bootgen readback failed'}
 Write-Output 'V19_BOOT_IMAGE_BUILT'
} finally {Pop-Location}
