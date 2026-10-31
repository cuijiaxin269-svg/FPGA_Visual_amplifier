# Automated screen-interpreter/P4 interactions, not a physical-touch claim.
source [file join [file dirname [info script]] hmi_helpers.tcl]
proc hburst {commands} {
 set text "[join $commands \r\n]\r\n";set hex {}
 foreach char [split $text {}] {scan $char %c byte;lappend hex [format %02X $byte]}
 set before [hword 26];hnative "printh [join $hex { }]"
 hwait 26 [expr {$before+[llength $commands]}] 10000
 puts "HMI_BURST $commands"
}
if {[catch {
 if {$argc!=1 || [file exists [lindex $argv 0]]} {error "Usage: fresh-log-path"}
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 loadhw -hw [file normalize [file join $tool_root .. .. build candidate capture.xsa]]
 same 0x00ff2000 0x484d4931;same 0xe0001010 0xe5
 hwait 24 0 5000;hwait 25 1 5000
 set f [open [lindex $argv 0] {WRONLY CREAT EXCL}]
 set began [clock milliseconds];set round 0;set next $began
 set reconnects [hword 33];set native_errors [hword 32]
 while {[clock milliseconds]-$began<600000} {
  hstandby
  set exposure [lindex {1 320 898} [expr {$round%3}]]
  hexposure $exposure
  hburst {{START} {ALPHA 31} {STOP}}
  hwait 19 5 20000;hchecked 15 0 final_stop_cancels_start
  hburst {{VIEW 0} {VIEW 2} {VIEW 1}}
  hwait 16 1 5000;hchecked 5 1 final_queued_view
  hstart;hchecked 10 $exposure exposure_applied
  hburst {{ALPHA 0} {ALPHA 50}};hwait 17 3 10000;hchecked 9 50 latest_alpha
  same 0x43c0006c 0x42480000
  set rejected [hword 27];hnative "printh 41 4C 50 48 41 20 35 31 0D 0A"
  hwait 27 [expr {$rejected+1}] 5000;hwait 17 7 5000;hchecked 6 50 invalid_keeps_target
  hemit "ALPHA 50";hwait 17 3 5000
  set revision [hword 55]
  hemit "VIEW 2";hwait 16 3 5000;hchecked 52 1 panel_visible
  hchecked 55 $revision panel_switch_no_restart
  foreach index {36 37 40 47 48} {hchecked $index 0 no_transport_or_execution_error}
  hchecked 32 $native_errors no_native_error;hchecked 33 $reconnects no_false_reconnect
  set elapsed [expr {[clock milliseconds]-$began}]
  puts $f [format {{"elapsed_ms":%d,"round":%d,"commands":%d,"rejected":%d,"rx_bytes":%d,"interrupts":%d,"exposure":%d,"frames":%d,"display_frames":%d,"rx_errors":%d,"rx_overflow":%d,"capture_error":%d,"algorithm_error":%d}} $elapsed $round [hword 26] [hword 27] [hword 34] [hword 39] $exposure [hword 49] [hword 50] [hword 37] [hword 36] [hword 47] [hword 48]]
  flush $f;incr round
  puts "HMI_SMOKE_PROGRESS elapsed_ms=$elapsed rounds=$round";flush stdout
  incr next 20000
  set delay [expr {$next-[clock milliseconds]}];if {$delay>0} {after $delay}
 }
 hstandby;hexposure 320;hemit "VIEW 2";hstart;halpha 50 0x42480000
 foreach {property expected} {page0.vstatus.txt APPLIED page0.astatus.txt APPLIED page0.estatus.txt APPLIED page0.rstatus.txt RUNNING} {
  if {[htext $property] ne $expected} {error "Screen status mismatch: $property"}
 }
 puts $f [format {{"passed":true,"elapsed_ms":%d,"rounds":%d,"physical_touch_test":false}} [expr {[clock milliseconds]-$began}] $round]
 close $f;unset f;disconnect
 puts HMI_TEN_MINUTE_AUTOMATED_INTERACTION_PASSED
} message options]} {
 puts stderr $message;puts stderr [dict get $options -errorinfo]
 if {[info exists f]} {puts $f [format {{"failed":"%s"}} $message];close $f}
 catch {disconnect};exit 1
}
exit 0
