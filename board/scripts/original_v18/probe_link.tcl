source [file join [file dirname [info script]] hmi_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 same 0x00ff2000 0x484d4931;same 0x00ff6300 0x48514d31
 hwait 25 1 10000;hwait 24 0 15000
 foreach {property expected} {page0.mode.val 2 page0.alpha.val 12 page0.exposure.val 320 page0.runreq.val 0} {
  if {[hnumber $property]!=$expected} {error "Initial screen state mismatch: $property"}
 }
 hchecked 14 0 cold_stopped;hchecked 19 5 run_status_stopped
 hchecked 36 0 rx_overflow;hchecked 37 0 rx_errors
 foreach {property expected} {page0.vstatus.txt QUEUED page0.astatus.txt QUEUED page0.estatus.txt QUEUED page0.rstatus.txt STOPPED} {
  if {[htext $property] ne $expected} {error "Initial screen status mismatch: $property"}
 }
 puts HMI_P4_SCREEN_LINK_READBACK_PASSED
 disconnect
} message options]} {puts stderr $message;catch {disconnect};exit 1}
exit 0
