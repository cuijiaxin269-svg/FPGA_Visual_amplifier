$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$receipt=Join-Path $root 'server_ownership.json'
if(Test-Path -LiteralPath $receipt){throw 'Preserve existing server ownership receipt'}
$processes=@(Get-CimInstance Win32_Process)
$controllers=@($processes|Where-Object {$_.Name -in @('hw_server.exe','cs_server.exe','xsdb.exe') -or ($_.Name -eq 'tclsh85t.exe' -and $_.CommandLine -match 'xsct|xsdb')})
if($controllers.Count){$controllers|Select-Object ProcessId,Name,CommandLine;throw 'Another hardware controller is active'}
$listeners=@(Get-NetTCPConnection -State Listen -LocalPort 3121 -ErrorAction SilentlyContinue)
if($listeners.Count){throw 'Port 3121 is already owned'}
$exe='D:/xilinx/Vivado/2021.2/bin/unwrapped/win64.o/hw_server.exe'
$server=Start-Process -FilePath $exe -ArgumentList @('-s','tcp:127.0.0.1:3121') -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $root 'hw_server.stdout.log') -RedirectStandardError (Join-Path $root 'hw_server.stderr.log')
$record=[ordered]@{pid=$server.Id;executable=$exe;started_at=$server.StartTime.ToString('o');cable='210299725543';jtag_hz=1000000;prior_controllers=@();ready=$false}
$record|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $receipt -Encoding UTF8
for($n=0;$n -lt 15;$n++){
 $server.Refresh()
 if($server.HasExited){throw 'Owned hardware server exited'}
 $listening=@(Get-NetTCPConnection -State Listen -LocalPort 3121 -ErrorAction SilentlyContinue|Where-Object {$_.OwningProcess -eq $server.Id})
 if($listening.Count){$record.ready=$true;break}
 Start-Sleep -Milliseconds 1000
}
$record|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $receipt -Encoding UTF8
if(!$record.ready){throw 'Owned server did not listen before deadline'}
Write-Output "BUTTON_OWNED_SERVER_READY pid=$($server.Id)"
