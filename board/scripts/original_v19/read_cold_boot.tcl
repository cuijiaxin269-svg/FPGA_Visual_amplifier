# Read-only after the user physically power-cycles into QSPI.
# No reset, halt, download, parameter command, START or peripheral access.
source [file join [file dirname [info script]] load_helpers.tcl]
set r [file normalize [file join $tool_root .. .. .. vision v19boot]]
if {$argc!=1} {error "Usage: fresh-output-directory"}
set out [file normalize [lindex $argv 0]]
if {[catch {
 if {[file exists $out]} {error "Preserve earlier cold-boot evidence"}
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 set boot [rd 0xf800025c]
 puts "COLD_BOOT_MODE [format 0x%x $boot]"
 if {($boot&15)!=1} {error "QSPI boot mode required; no writes performed"}
 if {([rd 0xf8006000]&1)!=1 || ([rd 0xf8000240]&15)!=0} {error "Boot chain has not initialized DDR/PL"}
 foreach addr {0x00ff0000 0x00ff1000 0x00ff2000 0x00ff2100 0x00ff6300} expected {0x9281ca01 0x4d363001 0x484d4931 0x484d5431 0x48514d31} {same $addr $expected}
 foreach addr {0x00ff0004 0x00ff0010 0x00ff1014 0x00ff1020 0x00ff2038 0x00ff203c 0x00ff20a4 0x00ff20a8 0x00ff20ac 0x00fffffc} {same $addr 0}
 same 0x00ff000c 1;same 0x00ff1004 1
 same 0x00ff2014 2;same 0x00ff2018 12;same 0x00ff201c 320;same 0x00ff204c 5
 set first [rd 0x00ff200c];after 1000;set last [rd 0x00ff200c]
 if {$last<=$first} {error "Application is not advancing"}
 same 0xf8f02100 0;same 0xe000101c 0;same 0xe0001020 1
 file mkdir $out
 mrd -bin -file [file join $out hmi.bin] 0x00ff2000 64
 mrd -bin -file [file join $out application_text.bin] 0x00100000 17469
 set f [open [file join $out boot_registers.txt] w]
 foreach a {0xf800025c 0xf8000258 0xf8006000 0xf8000240 0xf8000900 0xf800014c 0xf8f02100 0xe000101c 0xe0001020} {puts $f "$a [format 0x%08x [rd $a]]"}
 puts $f "uptime_first=$first\nuptime_last=$last"
 puts $f "target_properties=[targets -target-properties]"
 close $f
 puts V19_QSPI_COLD_BOOT_READ_ONLY_STANDBY_PASSED
 disconnect
} message options]} {puts stderr $message;puts stderr [dict get $options -errorinfo];catch {disconnect};exit 1}
exit 0
