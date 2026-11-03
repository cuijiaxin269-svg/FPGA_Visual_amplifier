# Read-only V19 observation. Never read clear-on-read HLS AP_CTRL registers.
# Usage: observe.tcl FRESH_DIRECTORY SAMPLE_COUNT INTERVAL_MS
proc rd {a} {expr {wide([mrd -value $a]) & 0xffffffff}}
proc same {a v} {if {[rd $a] != $v} {error "Identity mismatch at $a"}}
if {[catch {
 if {$argc != 3} {error "Expected fresh output, sample count, interval ms"}
 lassign $argv out count interval
 if {![string is integer -strict $count] || $count<2 || $count>10000 || ![string is integer -strict $interval] || $interval<1000} {error "Invalid sampling limits"}
 set out [file normalize $out]
 if {[file exists $out]} {error "Preserve existing evidence"}
 connect -url tcp:127.0.0.1:3121
 set matches {}
 for {set attempt 0} {$attempt<3} {incr attempt} {
  set matches {}
  foreach p [targets -target-properties] {
   if {[dict exists $p name] && [dict exists $p jtag_cable_serial] && [dict get $p name] eq "APU" && [dict get $p jtag_cable_serial] eq "210299725543"} {lappend matches $p}
  }
  if {[llength $matches] != 0} {break}
  if {$attempt<2} {after 1000}
 }
 if {[llength $matches] != 1} {puts "TARGET_INVENTORY [targets -target-properties]";error "Expected exactly one APU on cable 210299725543"}
 jtag targets -set -filter {jtag_cable_serial == "210299725543" && name =~ "Digilent*"}
 jtag frequency 1000000
 if {[jtag frequency] != 1000000} {error "JTAG frequency mismatch"}
 targets -set -filter {name == "APU" && jtag_cable_serial == "210299725543"}
 same 0x00ff0000 0x9281ca01; same 0x00ff1000 0x4d363001
 same 0x00ff2000 0x484d4931; same 0x00ff2004 1
 file mkdir $out
 mrd -bin -file [file join $out application_text.bin] 0x100000 17469
 set f [open [file join $out registers.txt] w]
 foreach a {0xf800025c 0xf8006000 0xf8000240 0xf8000100 0xf8000120 0xf80001c4} {puts $f "$a [format 0x%08x [rd $a]]"}
 close $f
 set log [open [file join $out samples.csv] w]
 puts $log "sample,host_before_ms,host_after_ms,sequence,stable"
 for {set i 0} {$i < $count} {incr i} {
  set before_ms [clock milliseconds];set stable 0;set s1 -1
  set name [format "hmi_%05d.bin" $i]
  for {set attempt 0} {$attempt<10} {incr attempt} {
   set s0 [rd 0x00ff2008]
   if {$s0 & 1} {after 5;continue}
   mrd -bin -file [file join $out $name] 0x00ff2000 64
   set s1 [rd 0x00ff2008]
   if {$s0 == $s1 && !($s1 & 1)} {set stable 1;break}
  }
  puts $log "$i,$before_ms,[clock milliseconds],$s1,$stable";flush $log
  puts "V19_SAMPLE $i stable=$stable";flush stdout
  if {!$stable} {error "No coherent HMI snapshot; preserve failed sample"}
  foreach block {capture motion spectrum camera button} a {0x00ff0000 0x00ff1000 0x00ff1100 0x00ff1300 0x00ff1400} words {133 32 32 15 16} {
   mrd -bin -file [file join $out [format "%s_%05d.bin" $block $i]] $a $words
  }
  if {$i+1 < $count} {after $interval}
 }
 close $log
 # These final blocks are diagnostic only: no cross-block atomicity is claimed.
 foreach name {capture motion spectrum camera button} a {0x00ff0000 0x00ff1000 0x00ff1100 0x00ff1300 0x00ff1400} words {133 32 32 15 16} {
  mrd -bin -file [file join $out ${name}.bin] $a $words
 }
 disconnect
 puts V19_READ_ONLY_OBSERVATION_COMPLETE
} message options]} {puts stderr $message;puts stderr [dict get $options -errorinfo];catch {close $log};catch {disconnect};exit 1}
exit 0
