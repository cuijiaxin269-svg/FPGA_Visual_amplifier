$ErrorActionPreference='Stop'
$taskRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$taskSavedPath=$env:PATH
$env:PATH='C:/msys64/ucrt64/bin;'+$env:PATH
Push-Location $taskRoot
try {
 New-Item -ItemType Directory -Force build/tests | Out-Null
 $sources=@('sim/test_alpha50_controls.cpp','sw/motion60_clip_record.c','sw/motion60_clip_driver.c','sw/motion60_clip_pl.c','sw/motion60_clip_playback.c','sw/motion60_spectrum_pl_driver.c')
 & C:/msys64/ucrt64/bin/g++.exe -std=c++14 -O2 -Wall -Wextra -Werror -D_Static_assert=static_assert -DMOTION60_PL_SPECTRUM @sources -o build/tests/test_alpha50_controls.exe
 if($LASTEXITCODE){throw 'Alpha50 controls compile failed'}
 & ./build/tests/test_alpha50_controls.exe
 if($LASTEXITCODE){throw 'Alpha50 controls test failed'}
} finally {Pop-Location;$env:PATH=$taskSavedPath}
