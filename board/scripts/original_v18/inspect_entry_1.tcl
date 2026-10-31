source [file join [file dirname [file normalize [info script]]] load_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 set ddr [rd 0xf8006000];set pl [rd 0xf8000240]
 puts "DDR_CONTROL [format 0x%08x $ddr] PL_RESET [format 0x%08x $pl]"
 if {!($ddr&1) && ($pl&15)==15} {puts ALPHA50_ENTRY_COLD_RESET_HELD} elseif {$ddr&1 && ($pl&15)==0} {
  foreach a {0x00ff0000 0x00ff1000 0x00ff000c 0x00ff1004 0x00ff1014 0x00ff102c} {puts "$a [format 0x%08x [rd $a]]"}
  puts ALPHA50_ENTRY_INITIALIZED
 } else {error "Mixed reset state; refuse automatic transition"}
 disconnect
} message options]} {puts stderr $message;catch {disconnect};exit 1}
exit 0
