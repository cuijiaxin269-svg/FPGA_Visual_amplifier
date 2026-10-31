$ErrorActionPreference='Stop'
$taskRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$taskSavedPath=$env:PATH
$env:PATH='C:/msys64/ucrt64/bin;'+$env:PATH
Push-Location $taskRoot
try {
 New-Item -ItemType Directory -Force build/tests | Out-Null
 foreach($test in @('test_spectrum_ui','test_stability')) {
  & C:/msys64/ucrt64/bin/g++.exe -std=c++14 -O2 -Wall -Wextra -Werror "sim/$test.cpp" -o "build/tests/$test.exe"
  if($LASTEXITCODE){throw "Compile failed: $test"}
  $report=if($test -eq 'test_stability'){'stability_tests.log'}else{'spectrum_tests.log'}
  & "./build/tests/$test.exe" | Tee-Object "reports/$report"
  if($LASTEXITCODE){throw "Test failed: $test"}
 }
} finally {Pop-Location;$env:PATH=$taskSavedPath}
