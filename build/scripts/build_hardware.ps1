param(
    [Parameter(Mandatory=$true)][string]$BuildDirectory,
    [string]$Vivado = 'vivado.bat'
)
$ErrorActionPreference = 'Stop'
$buildPath = [IO.Path]::GetFullPath($BuildDirectory)
if (Test-Path -LiteralPath $buildPath) { throw 'Use a fresh build directory; existing results are preserved.' }
$parentPath = Split-Path -Parent $buildPath
New-Item -ItemType Directory -Force -Path $parentPath | Out-Null
$oldTaskTemp = $env:TEMP
$oldTaskTmp = $env:TMP
$taskTempPath = Join-Path $parentPath "tmp"
New-Item -ItemType Directory -Force -Path $taskTempPath | Out-Null
$env:TEMP = $taskTempPath
$env:TMP = $taskTempPath
Push-Location $parentPath
try {
    & $Vivado -mode batch -source (Join-Path $PSScriptRoot 'create_project.tcl') -log "$buildPath.create.log" -journal "$buildPath.create.jou" -tclargs $buildPath
    if ($LASTEXITCODE -ne 0) { throw 'Vivado project creation failed; see create log.' }
    & $Vivado -mode batch -source (Join-Path $PSScriptRoot 'build_hardware.tcl') -log "$buildPath.build.log" -journal "$buildPath.build.jou" -tclargs (Join-Path $buildPath 'c.xpr')
    if ($LASTEXITCODE -ne 0) { throw 'Vivado synthesis/implementation failed; see build log and reports.' }
    foreach ($name in @('capture.bit','capture.xsa')) {
        if (-not (Test-Path -LiteralPath (Join-Path $buildPath "artifacts/$name"))) { throw "Expected output missing: $name" }
    }
    Write-Output "Build complete: $buildPath/artifacts. Board runtime validation is a separate step."
} finally { Pop-Location; $env:TEMP = $oldTaskTemp; $env:TMP = $oldTaskTmp }
