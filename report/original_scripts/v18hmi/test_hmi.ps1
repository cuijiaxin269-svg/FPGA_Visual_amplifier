$ErrorActionPreference='Stop'
$hmiTestRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$hmiOldPath=$env:PATH
$env:PATH='C:/msys64/ucrt64/bin;'+$env:PATH
Push-Location $hmiTestRoot
try {
 New-Item -ItemType Directory -Force build/tests | Out-Null
 $common=@('sw/hmi_protocol.c','sw/hmi_link.c')
 $scheduler=@('sw/motion60_clip_record.c','sw/motion60_clip_driver.c','sw/motion60_clip_pl.c','sw/motion60_clip_playback.c','sw/motion60_spectrum_pl_driver.c')
 foreach($test in @('test_hmi_protocol','test_hmi_device','test_hmi_uart')) {
  $sources=@("sim/$test.cpp")+$common
  if($test -eq 'test_hmi_device'){$sources+=$scheduler}
  & C:/msys64/ucrt64/bin/g++.exe -std=c++14 -O2 -Wall -Wextra -Werror -D_Static_assert=static_assert -DMOTION60_PL_SPECTRUM @sources -o "build/tests/$test.exe"
  if($LASTEXITCODE){throw "Compile failed: $test"}
  & "./build/tests/$test.exe" | Tee-Object "reports/$test.log"
  if($LASTEXITCODE){throw "Failed: $test"}
 }
 & C:/msys64/ucrt64/bin/python.exe -I -B scripts/input_receipt.py host
 if($LASTEXITCODE){throw 'Host input receipt failed'}
 Write-Output 'HMI_HOST_TESTS_PASSED'
} finally {Pop-Location;$env:PATH=$hmiOldPath}
