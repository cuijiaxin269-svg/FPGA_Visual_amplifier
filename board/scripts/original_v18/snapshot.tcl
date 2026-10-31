# Read-only diagnostics. No AP_CTRL reads, STOP, register writes or core halt.
source [file join [file dirname [info script]] load_helpers.tcl]
if {[catch {
 if {$argc!=1} {error "Usage: fresh-evidence-directory"}
 set out [file normalize [lindex $argv 0]]
 if {[file exists $out]} {error "Fresh evidence directory required"}
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 same 0x00ff2000 0x484d4931;same 0x00ff2004 1;same 0x00ff2100 0x484d5431
 file mkdir $out
 set stable 0
 for {set attempt 0} {$attempt<5} {incr attempt} {
  set before [rd 0x00ff2008]
  if {$before&1} {after 5;continue}
  mrd -bin -file [file join $out hmi.bin] 0x00ff2000 64
  set after [rd 0x00ff2008]
  if {$before==$after && !($after&1)} {set stable 1;break}
 }
 if {!$stable} {error "HMI snapshot changed during all bounded reads"}
 set rx_before [rd 0x00ff2108];set tx_before [rd 0x00ff210c]
 mrd -bin -file [file join $out trace.bin] 0x00ff2100 4100
 set rx_after [rd 0x00ff2108];set tx_after [rd 0x00ff210c]
 set f [open [file join $out trace_window.txt] w]
 puts $f "rx_before=$rx_before\nrx_after=$rx_after\ntx_before=$tx_before\ntx_after=$tx_after\nhmi_sequence=$after"
 close $f
 foreach name {capture motion camera button} address {0x00ff0000 0x00ff1000 0x00ff1300 0x00ff1400} words {133 32 15 16} {
  mrd -bin -file [file join $out ${name}.bin] $address $words
 }
 disconnect
 puts HMI_READONLY_SNAPSHOT_CAPTURED
} message options]} {puts stderr $message;catch {disconnect};exit 1}
exit 0
