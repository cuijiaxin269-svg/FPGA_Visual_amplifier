param([string]$InputFile='')
$ErrorActionPreference='Stop'
$chosenInput=if($InputFile){[IO.Path]::GetFullPath($InputFile)}else{''}
$savedPath=$env:PATH
$env:PATH='C:/msys64/ucrt64/bin;'+$env:PATH
$taskRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
Push-Location $taskRoot
try {
 New-Item -ItemType Directory -Force build/tests,build/ui_sim | Out-Null
 & C:/msys64/ucrt64/bin/g++.exe -std=c++14 -O2 -Wall -Wextra -Werror sim/test_spectrum_ui.cpp -o build/tests/test_spectrum_ui.exe
 if($LASTEXITCODE){throw 'UI test compile failed'}
 if(!$chosenInput){$chosenInput=(Get-ChildItem ../../board_checks/20261029_multitone_01/mix_01/spectrum_*_values.bin|Select-Object -First 1).FullName}
 & ./build/tests/test_spectrum_ui.exe $chosenInput reports/ui_packet.hex | Tee-Object reports/ui_tests.log
 if($LASTEXITCODE){throw 'UI signal test failed'}
 Push-Location build/ui_sim
 try {
  & D:/xilinx/Vivado/2021.2/bin/xvlog.bat --sv ../../rtl/motion60_spectrum_overlay.v ../../sim/reference_spectrum_overlay.v ../../sim/tb_spectrum_ui.sv
  if($LASTEXITCODE){throw 'UI RTL compile failed'}
  & D:/xilinx/Vivado/2021.2/bin/xelab.bat tb_spectrum_ui --timescale 1ns/1ps -s ui_test
  if($LASTEXITCODE){throw 'UI RTL elaboration failed'}
  & D:/xilinx/Vivado/2021.2/bin/xsim.bat ui_test -runall -log ../../reports/ui_rtl.log
  if($LASTEXITCODE){throw 'UI RTL simulation failed'}
 } finally {Pop-Location}
 $log=Get-Content reports/ui_rtl.log -Raw
 if($log -notmatch 'SPECTRA_RTL_PASSED' -or $log -match 'Fatal:'){throw 'Missing success or fatal'}
} finally {Pop-Location;$env:PATH=$savedPath}
