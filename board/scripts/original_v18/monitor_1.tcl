# Bounded read-only interaction/continuous-run observation. Does not issue START.
source [file join [file dirname [info script]] hmi_helpers.tcl]
set monitor_reconnects 0
proc monitor_mrd {args} {
 if {![catch {mrd {*}$args} value options]} {return $value}
 if {![string match {*Invalid context*} $value] || $::monitor_reconnects>=3} {return -options $options $value}
 incr ::monitor_reconnects
 if {[info exists ::f]} {
  puts $::f [format {{"event":"jtag_reconnect","attempt":%d,"reason":"Invalid context"}} $::monitor_reconnects]
  flush $::f
 }
 puts "HMI_MONITOR_JTAG_RECONNECT $::monitor_reconnects";flush stdout
 catch {disconnect};after 500
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 if {[expr {wide([mrd -value 0x00ff2000])&0xffffffff}]!=0x484d4931} {error "Firmware identity changed after JTAG reconnect"}
 # No reset/halt/download. Normal counter/state checks still apply.
 return [mrd {*}$args]
}
proc rd {a} {expr {wide([monitor_mrd -value $a])&0xffffffff}}
if {[catch {
 if {$argc!=3} {error "Usage: interaction|soak seconds fresh-log-path"}
 lassign $argv mode seconds output
 if {$mode ni {interaction soak} || ![string is integer -strict $seconds] || $seconds<1 || $seconds>7200} {error "Invalid monitor parameters"}
 if {[file exists $output]} {error "Preserve existing observation log"}
 connect -url tcp:127.0.0.1:3121;owned_target;apu;same 0x00ff2000 0x484d4931
 set f [open $output {WRONLY CREAT EXCL}]
 set start [clock milliseconds];set next $start;set count 0
 set commands [hword 26];set previous_frames -1;set previous_display -1;set first_elapsed -1
 set initial_parameters [list [hword 8] [hword 9] [hword 10]]
 while {1} {
  set elapsed [expr {[clock milliseconds]-$start}]
  if {$first_elapsed<0} {set first_elapsed $elapsed}
  set run [hword 19];set view [hword 8];set alpha [hword 9];set exposure [hword 10]
  set rx [hword 34];set tx [hword 35];set overflow [hword 36];set rxerrors [hword 37]
  set capture_error [hword 47];set algorithm_error [hword 48];set frames [hword 49];set display [hword 50]
  set processed_commands [hword 26];set native_errors [hword 32]
  set discontinuities [rd 0x00ff101c];set sequence_gaps [rd 0x00ff0074];set sensor_gaps [rd 0x00ff00bc]
  # capture_control offsets verified against the compiled C structure.
  # In mode=2 the sensor deliberately repeats ID zero; raw 'gaps' count
  # repeated IDs and are expected to equal SOFs-1 (main.c end-of-run gate).
  # Read one mailbox burst so the related copied fields belong together.
  set metadata_stable 0
  for {set retry 0} {$retry<5} {incr retry} {
   set meta [monitor_mrd -value 0x00ff00b8 4]
   if {$meta eq [monitor_mrd -value 0x00ff00b8 4]} {set metadata_stable 1;break}
  }
  if {!$metadata_stable} {error "Cannot obtain stable sensor metadata"}
  lassign $meta sensor_last sensor_gaps sensor_changes sensor_sofs
  foreach key {sensor_last sensor_gaps sensor_changes sensor_sofs} {set $key [expr {wide([set $key])&0xffffffff}]}
  set sensor_mode [rd 0x00ff0108]
  set counter_control [expr {[rd 0x00ff0118]&7}]
  set sensor_continuity_ok [expr {$sensor_mode==2 ? ($counter_control==1 && $sensor_last==0 && $sensor_changes==0 && $sensor_gaps+1==$sensor_sofs) : ($counter_control==0 && $sensor_gaps==0 && $sensor_changes+1==$sensor_sofs)}]
  puts $f [format {{"elapsed_ms":%d,"run":%d,"view":%d,"alpha":%d,"exposure":%d,"commands":%d,"rx_bytes":%d,"tx_bytes":%d,"rx_overflow":%d,"rx_errors":%d,"native_errors":%d,"capture_error":%d,"algorithm_error":%d,"processed_frames":%d,"display_frames":%d,"discontinuities":%d,"sequence_gaps":%d,"sensor_raw_repeated_or_gap_count":%d,"sensor_counter_mode":%d,"sensor_sofs":%d,"sensor_continuity_ok":%d}} $elapsed $run $view $alpha $exposure $processed_commands $rx $tx $overflow $rxerrors $native_errors $capture_error $algorithm_error $frames $display $discontinuities $sequence_gaps $sensor_gaps $sensor_mode $sensor_sofs $sensor_continuity_ok]
  flush $f;incr count
  if {$overflow || $rxerrors || $capture_error || $algorithm_error} {error "Communication/capture/algorithm error during observation"}
  if {$mode eq "soak"} {
   if {$run!=4 || $processed_commands!=$commands} {error "Continuous run was interrupted or received a new command"}
   if {[list $view $alpha $exposure] ne $initial_parameters} {error "Parameters changed during continuous observation"}
   if {$discontinuities || $sequence_gaps || !$sensor_continuity_ok} {error "Frame discontinuity during continuous observation"}
   if {$previous_frames>=0 && ($frames<=$previous_frames || $display<=$previous_display)} {error "Frame/display counters stopped advancing"}
   set previous_frames $frames;set previous_display $display
  }
  if {$count%6==1} {puts "HMI_MONITOR mode=$mode elapsed_ms=$elapsed frames=$frames display=$display rx_errors=$rxerrors capture_error=$capture_error";flush stdout}
  if {$elapsed-$first_elapsed>=$seconds*1000} {break}
  incr next 10000
  set remaining [expr {$next-[clock milliseconds]}]
  if {$remaining>0} {after $remaining}
 }
 close $f;unset f;disconnect
 puts "HMI_MONITOR_PASSED mode=$mode seconds=$seconds samples=$count"
} message options]} {
 puts stderr $message
 if {[info exists f]} {puts $f [format {{"failed":"%s"}} $message];close $f}
 catch {disconnect};exit 1
}
exit 0
