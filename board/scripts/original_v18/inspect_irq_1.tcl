source [file join [file dirname [info script]] load_helpers.tcl]
connect -url tcp:127.0.0.1:3121
owned_target
puts [targets]
select_core 0
stop
puts [rrd pc]
puts [rrd cpsr]
puts [rrd sp]
puts [rrd lr]
puts [rrd spsr]
foreach address {0xf8f01000 0xf8f01108 0xf8f01208 0xf8f01308 0xf8f01450 0xf8f01850 0xf8f01c14 0xf8f00100 0xf8f00104 0xf8f00108 0xf8f00114 0xf8f00118 0x00ff2008 0x00ff200c} {puts "$address [format 0x%08x [rd $address]]"}
con
apu
after 1000
puts "DIAG_SEQUENCE [rd 0x00ff2008] TIME [rd 0x00ff200c]"
disconnect
exit 0
