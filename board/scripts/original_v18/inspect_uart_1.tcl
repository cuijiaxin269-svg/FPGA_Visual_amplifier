source [file join [file dirname [info script]] load_helpers.tcl]
connect -url tcp:127.0.0.1:3121;owned_target;apu
foreach pass {1 2 3} {
 foreach address {0xe0001000 0xe0001004 0xe0001010 0xe0001014 0xe0001018 0xe000101c 0xe0001020 0xe000102c 0xe0001034 0x00ff2060 0x00ff2064 0x00ff2084 0x00ff2088 0x00ff209c 0x00ff20e4 0x00ff20e8} {puts "$pass $address [format 0x%08x [rd $address]]"}
 after 500
}
disconnect
exit 0
