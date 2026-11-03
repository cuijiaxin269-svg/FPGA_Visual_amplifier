param([switch]$FullResolution)
$ErrorActionPreference='Stop'
$taskRoot=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../..'))
$artifactRoot=Split-Path -Parent $PSScriptRoot
$hlsRoot='D:/xilinx/Vitis_HLS/2021.2'
$buildRoot=Join-Path $artifactRoot 'offline'
$oracleWidth=64;$oracleHeight=64;$name='source_oracle'
if($FullResolution){$oracleWidth=1280;$oracleHeight=800;$name='source_oracle_full'}
$output=Join-Path $buildRoot ($name+'.exe')
if(Test-Path -LiteralPath $output){throw 'Preserve existing oracle binary; use a new acceptance directory for rebuilding'}
$savedPath=$env:PATH
$env:PATH='C:/msys64/ucrt64/bin;'+$env:PATH
Push-Location $taskRoot
try {
 $oracleArguments=@('-std=c++14','-O2','-Wno-unknown-pragmas','-D_Static_assert=static_assert',
   "-DMOTION_WIDTH=$oracleWidth","-DMOTION_HEIGHT=$oracleHeight","-I$hlsRoot/include",
   (Join-Path $PSScriptRoot 'source_oracle.cpp'),(Join-Path $PSScriptRoot 'config_oracle.cpp'),
   'vision/v16alpha50/hls/motion60_shared/phase_core.cpp','vision/v16alpha50/hls/motion60_shared/pipeline.cpp',
   "$hlsRoot/win64/lib/csim/libhlsmc++-GCC62-x64.dll","$hlsRoot/win64/lib/csim/libhlsm-GCC62-x64.dll",'-o',$output)
 $oracleArguments|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $buildRoot ($name+'_arguments.json')) -Encoding UTF8
 & C:/msys64/ucrt64/bin/g++.exe @oracleArguments 2>&1|Tee-Object -FilePath (Join-Path $buildRoot ($name+'_build.log'))
 if($LASTEXITCODE){throw 'Host C simulation build failed'}
} finally {Pop-Location;$env:PATH=$savedPath}
