source [file join [file dirname [info script]] hmi_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 loadhw -hw [file normalize [file join $tool_root .. .. build candidate capture.xsa]]
 hstandby;hexposure 320;hemit "VIEW 2";hstart;halpha 50 0x42480000
 # Exercise the unchanged screen's real timer, without changing its project.
 # This stages WAIT ACK externally; it is not a physical touch timeout test.
 set commands [hword 26]
 hnative {page0.astatus.txt="WAIT ACK"}
 hnative {page0.aack.en=1}
 after 3300
 set observed [htext page0.astatus.txt]
 if {$observed ne "NO ACK"} {error "Expected native 3-second timeout, got $observed"}
 hchecked 26 $commands timeout_does_not_resend
 foreach {property expected} {page0.vstatus.txt APPLIED page0.estatus.txt APPLIED page0.rstatus.txt RUNNING} {
  if {[htext $property] ne $expected} {error "Timeout changed another status group"}
 }
 puts HMI_NATIVE_THREE_SECOND_TIMER_PASSED
 hemit "ALPHA 50";hwait 17 3 5000
 if {[htext page0.astatus.txt] ne "APPLIED"} {error "Alpha status did not recover after new completion"}
 foreach index {36 37 40 47 48} {hchecked $index 0 no_hardware_errors}
 hchecked 8 2 view;hchecked 9 50 alpha;hchecked 10 320 exposure;hchecked 19 4 running
 puts HMI_STANDARD_SOAK_READY
 disconnect
} message options]} {puts stderr $message;puts stderr [dict get $options -errorinfo];catch {disconnect};exit 1}
exit 0
