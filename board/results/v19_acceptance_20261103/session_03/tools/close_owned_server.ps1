$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$receipt=Join-Path $root 'server_cleanup.json'
if(Test-Path -LiteralPath $receipt){throw 'Preserve existing cleanup receipt'}
$owner=Get-Content -LiteralPath (Join-Path $root 'server_ownership.json') -Raw|ConvertFrom-Json
$running=Get-CimInstance Win32_Process -Filter "ProcessId = $($owner.pid)"
$record=[ordered]@{time=(Get-Date).ToString('o');pid=$owner.pid;board_commands=0;reset_commands=0;stopped=$false;was_running=[bool]$running}
if($running){
 if($running.Name -ne 'hw_server.exe' -or [IO.Path]::GetFullPath($running.ExecutablePath) -ne [IO.Path]::GetFullPath($owner.executable)){throw 'Server PID identity changed'}
 $expectedStart=[DateTimeOffset]::Parse($owner.started_at).UtcDateTime
 if([Math]::Abs(($running.CreationDate.ToUniversalTime()-$expectedStart).TotalSeconds) -gt 1){throw 'Server PID has been reused'}
 $controllers=@(Get-CimInstance Win32_Process|Where-Object {$_.Name -in @('xsdb.exe','rdi_xsdb.exe','rdi_xsct.exe') -or ($_.Name -eq 'tclsh85t.exe' -and $_.CommandLine -match 'xsct|xsdb')})
 if($controllers.Count){throw 'Hardware client still active; do not close service'}
 $record.termination_output=(& taskkill.exe /PID $owner.pid /T /F) -join "`n"
 if($LASTEXITCODE -ne 0){throw 'Owned server termination failed'}
}
if(Get-Process -Id $owner.pid -ErrorAction SilentlyContinue){throw 'Server still present'}
$record.stopped=$true
$record|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $receipt -Encoding UTF8
Write-Output 'HMI_OWNED_SERVER_CLOSED_NO_BOARD_COMMANDS'
