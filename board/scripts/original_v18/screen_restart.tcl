source [file join [file dirname [info script]] hmi_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 same 0x00ff2000 0x484d4931;hstandby
 set commands [hword 26];set reconnects [hword 33]
 # TJC native soft restart: no project/Flash update and no board restart.
 hnative rest
 after 5000;hwait 25 1 15000;hwait 24 0 15000
 if {[hword 33]<=$reconnects} {error "No screen reconnect observed"}
 hchecked 26 $commands no_implicit_business_command
 hchecked 14 0 no_implicit_start;hchecked 19 5 stopped
 foreach {property expected} {page0.mode.val 2 page0.alpha.val 50 page0.exposure.val 320 page0.runreq.val 0} {
  if {[hnumber $property]!=$expected} {error "Screen restart resync mismatch: $property"}
 }
 puts HMI_SCREEN_SOFT_RESTART_RESYNC_PASSED
 disconnect
} message options]} {puts stderr $message;puts stderr [dict get $options -errorinfo];catch {disconnect};exit 1}
exit 0
