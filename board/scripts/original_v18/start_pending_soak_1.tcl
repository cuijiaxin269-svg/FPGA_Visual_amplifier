source [file join [file dirname [info script]] hmi_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 hchecked 5 2 target_view;hchecked 6 50 target_alpha
 hstandby;hexposure 320
 hstart;hwait 17 3 5000
 hchecked 8 2 actual_view;hchecked 9 50 actual_alpha;hchecked 10 320 actual_exposure
 puts HMI_STANDARD_SOAK_READY
 disconnect
} message options]} {puts stderr $message;catch {disconnect};exit 1}
exit 0
