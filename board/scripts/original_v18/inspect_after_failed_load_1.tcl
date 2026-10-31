source [file join [file dirname [info script]] load_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target
 puts [targets]
 apu
 foreach address {0xf8006000 0xf8000240 0xf8000258 0xf800025c} {puts "PS_STATE $address [format 0x%08x [rd $address]]"}
 core_halted_proof 1;core_halted_proof 0
 puts [help fpga]
 disconnect
} message options]} {puts stderr $message;catch {disconnect};exit 1}
exit 0
