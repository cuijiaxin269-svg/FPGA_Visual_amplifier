source [file join [file dirname [info script]] load_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 foreach a {0xf800025c 0xf8000258 0xf800012c 0xf800014c 0xf8000700 0xf8000704 0xf8000708 0xf800070c 0xf8000710 0xf8000714 0xf8000718 0xf8000240 0xf8000900 0xf8006000} {
  puts "BOOT_REGISTER $a [format 0x%08x [rd $a]]"
 }
 puts V19_READ_ONLY_BOOT_STATE_DONE
 disconnect
} message options]} {puts stderr $message;catch {disconnect};exit 1}
exit 0
