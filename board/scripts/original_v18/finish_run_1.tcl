# Cooperative end-of-run validation; leaves STOPPED with selected parameters.
source [file join [file dirname [info script]] hmi_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 loadhw -hw [file normalize [file join $tool_root .. .. build candidate capture.xsa]]
 hstandby
 set new_firmware 1;idle_errors;hls_idle
 hchecked 14 0 stopped;hchecked 19 5 stopped_confirmation
 hchecked 36 0 no_rx_overflow;hchecked 37 0 no_uart_errors
 hchecked 47 0 no_end_capture_error;hchecked 48 0 no_end_algorithm_error
 if {[htext page0.rstatus.txt] ne "STOPPED"} {error "Screen STOPPED readback mismatch"}
 puts HMI_FINAL_STOP_DRAIN_READBACK_PASSED
 disconnect
} message options]} {puts stderr $message;puts stderr [dict get $options -errorinfo];catch {disconnect};exit 1}
exit 0
