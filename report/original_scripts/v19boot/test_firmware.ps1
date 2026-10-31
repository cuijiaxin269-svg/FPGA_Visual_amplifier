param([string]$GccRoot='C:/msys64/ucrt64/bin')
$ErrorActionPreference='Stop'
$candidateRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$savedPath=$env:PATH
$env:PATH=$GccRoot+';'+$env:PATH
Push-Location $candidateRoot
try {
 New-Item -ItemType Directory -Force 'build/tests' | Out-Null
 $sources=@('sim/test_mode_button.cpp','sw/motion60_clip_record.c','sw/motion60_clip_driver.c','sw/motion60_clip_pl.c','sw/motion60_clip_playback.c','sw/motion60_spectrum_pl_driver.c')
 & (Join-Path $GccRoot 'g++.exe') -std=c++14 -O2 -Wall -Wextra -Werror -D_Static_assert=static_assert -DMOTION60_PL_SPECTRUM @sources -o build/tests/test_mode_button.exe
 if($LASTEXITCODE -ne 0){throw 'Button host test compilation failed'}
 & './build/tests/test_mode_button.exe'
 if($LASTEXITCODE -ne 0){throw 'Button host test failed'}
} finally {Pop-Location;$env:PATH=$savedPath}
