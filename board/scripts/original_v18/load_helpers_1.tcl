# Full-design volatile load, derived from reviewed r3 reset/init/download order.
# Unknown/zero-ID entry is refused. No additional system reset or package restore.
# PACKAGE FRESH_EVIDENCE_DIR ?JTAG_HZ?
set tool_root [file dirname [file normalize [info script]]]
set new_firmware 0
set python C:/msys64/ucrt64/bin/python.exe
set cable 210299725543
set frequency 1000000
set identities {0x00ff0000 0x00ff1000 0x00ff107c 0x00ff1200 0x00ff126c 0x00ff1300}
set expected_ids {0x9281ca01 0x4d363001 0x53504c31 0x434c5031 1 0x43414d31}
set state_file ""
set phase argument_validation
proc rd {a} {expr {wide([mrd -value $a])&0xffffffff}}
proc same {a expected} {if {[rd $a]!=$expected} {error "Register mismatch at $a (expected $expected)"}}
proc stage {name} {
 set ::phase $name
 puts "BUTTON_PHASE $name"
 if {$::state_file ne ""} {puts $::state_file "phase=$name";flush $::state_file}
}
proc apu {} {targets -set -filter {name == "APU" && jtag_cable_serial == "210299725543"}}
proc select_core {core} {targets -set -filter "name =~ \"ARM*#$core\" && jtag_cable_serial == \"210299725543\""}
# XSCT 2021.2: filter the full target inventory locally, with bounded empty retries.
proc owned_properties {pattern} {
 for {set attempt 0} {$attempt<3} {incr attempt} {
  set matches {}
  foreach props [targets -target-properties] {
   if {[dict exists $props name] && [dict exists $props jtag_cable_serial] &&
       [dict get $props jtag_cable_serial] eq "210299725543" &&
       [string match $pattern [dict get $props name]]} {lappend matches $props}
  }
  if {[llength $matches]>1} {error "Ambiguous owned target: $pattern"}
  if {[llength $matches]==1} {return $matches}
  if {$attempt<2} {puts "WAIT_OWNED_INVENTORY $pattern $attempt";flush stdout;after 1000}
 }
 error "Owned target absent after bounded discovery: $pattern"
}

proc owned_target {} {
 if {[llength [owned_properties xc7z100*]]!=1} {error "Owned XC7Z100 target must be unique"}
 jtag targets -set -filter {jtag_cable_serial == "210299725543" && name =~ "Digilent*"}
 jtag frequency $::frequency
 if {[jtag frequency]!=$::frequency} {error "JTAG frequency readback mismatch"}
 puts "BUTTON_JTAG_FREQUENCY_VERIFIED $::frequency"
}
proc halt_cores {} {
 foreach core {1 0} {
  select_core $core
  if {[catch {stop} message] && $message ne "Already stopped"} {error $message}
 }
}
proc core_halted_proof {core} {
  set found [owned_properties "ARM*#$core"]
  if {[llength $found]!=1} {error "Owned core#$core not unique"}
  set p [lindex $found 0]
  if {![dict exists $p suspended] || [dict get $p suspended]!=1 || ![dict exists $p state_reason] || [string match -nocase *error* [dict get $p state_reason]]} {error "Cannot prove core#$core halted: $p"}
  select_core $core
  set direct [state]
  puts "BUTTON_CORE core=$core properties={$p} direct_state={$direct}"
  if {![string match Stopped* $direct]} {error "Direct state did not confirm core#$core stopped"}
}
proc core0_running_proof {} {
 set found [owned_properties ARM*#0]
 if {[llength $found]!=1} {error "Owned core#0 not unique"}
 set p [lindex $found 0];select_core 0;set direct [state]
 if {![dict exists $p suspended] || [dict get $p suspended]!=0 || ![dict exists $p state_reason] || [string match -nocase *error* [dict get $p state_reason]] || $direct ne "Running"} {error "Known core0 must directly run the known firmware to consume STOP"}
 puts "BUTTON_CORE core=0 properties={$p} direct_state={$direct}"
}
proc halted_proof {} {
 foreach core {1 0} {core_halted_proof $core}
}
proc software_idle {} {
 if {[rd 0x00ff000c] ni {1 3} || [rd 0x00ff1004] ni {1 3}} {return 0}
 foreach a {0x00ff0004 0x00ff1020 0x00ff120c 0x00ff1248 0x00ff124c} {if {[rd $a]!=0} {return 0}}
 set began [expr {[rd 0x00ff1270]|[rd 0x00ff1274]}]
 set ended [expr {[rd 0x00ff1278]|[rd 0x00ff127c]}]
 return [expr {!$began || $ended!=0}]
}
proc idle_errors {} {
 if {![software_idle]} {error "Software still owns capture/motion/clip work"}
 foreach a {0x00ff0010 0x00ff1014 0x00ff101c 0x00ff1210} {same $a 0}
 if {$::new_firmware} {same 0x00ff1258 0} else {
  # The completed old PLAY error is stale while clip_active is zero. Prove
  # that using symbols bound to the exact old ELF/code, not the mailbox alone.
  foreach a {0x0010d0d4 0x0010d0dc 0x0010d0e4} {same $a 0}
  same 0x00ff1258 163
 }
}
proc hls_idle {} {
 # AP_DONE is clear-on-read; only call after software ownership has ended.
 foreach a {0x43c00000 0x43c10000 0x43c20000 0x43c40000 0x43c50000} {
  if {([rd $a]&0x85)!=4} {error "HLS AP_IDLE/start/auto-restart mismatch at $a"}
 }
}
proc dma_halted {control status} {
 set c [rd $control];set s [rd $status]
 if {($c&5)!=0 || !($s&1) || ($s&0x4ff0)} {error "VDMA not halted/error-free at $control"}
}
proc stop_known_full {} {
 if {([rd 0xf8006000]&1)!=1 || ([rd 0xf8000240]&15)!=0} {error "Known initialized full firmware required; cold/unknown entry refused"}
 foreach a $::identities value $::expected_ids {same $a $value}
 foreach a {0x00ff120c 0x00ff1248 0x00ff124c} {same $a 0}
 if {([rd 0x00ff1270]|[rd 0x00ff1274]) && !([rd 0x00ff1278]|[rd 0x00ff127c])} {error "Offline PROCESS owns memory; cooperative workflow required"}
 # Queued PROCESS has private busy state before it publishes its start time.
 if {[rd 0x00ff1070]==2 && [rd 0x00ff123c]!=1} {error "Unprocessed/queued offline clip entry refused"}
 same 0x00ff0004 0;same 0x00ff1020 0
 if {[rd 0x00ff000c] ni {1 2 3} || [rd 0x00ff1004] ni {1 2 3}} {error "Unsupported capture/motion state"}
 core0_running_proof;apu
 stage normal_stop_drain
 mwr 0x00ff1020 2
 set deadline [expr {[clock milliseconds]+20000}]
 while {![software_idle]} {
  if {[clock milliseconds]>$deadline} {error "Known firmware did not reach normal STOP/idle"}
  after 100
 }
 idle_errors;hls_idle;dma_halted 0x43000030 0x43000034
 stage halt_display_master
 set c [rd 0x43100000];set s [rd 0x43100004]
 if {$c&4 || $s&0x4ff0} {error "Display VDMA reset/error state"}
 if {$c&1} {mwr 0x43100000 [expr {$c&~1}]}
 set deadline [expr {[clock milliseconds]+3000}]
 while {([rd 0x43100000]&1) || !([rd 0x43100004]&1)} {
  if {[clock milliseconds]>$deadline} {error "Display VDMA halt timeout"}
  after 20
 }
 dma_halted 0x43100000 0x43100004
 stage halt_both_cores
 halt_cores;halted_proof;apu
 idle_errors;hls_idle
 dma_halted 0x43000030 0x43000034;dma_halted 0x43100000 0x43100004
}
proc check_reset_hold {phase} {
 set ddr [rd 0xf8006000];set pl [rd 0xf8000240]
 if {($ddr&1)!=0 || ($pl&15)!=15} {error "Reset state mismatch at $phase: DDR=$ddr PL=$pl"}
 puts "RESET_STATE_CONFIRMED phase=$phase DDR_CTRL=$ddr FPGA_RST_CTRL=$pl"
}
proc reconnect_reset_once {} {
 # Identical bounded r3 recovery: reconnect once; never issue another system reset.
 puts BUTTON_BOUNDED_DAP_RECONNECT_BEGIN
 flush stdout
 if {$::state_file ne ""} {puts $::state_file "bounded_dap_reconnect_attempted=true";flush $::state_file}
 catch {disconnect}
 after 1000
 connect -url tcp:127.0.0.1:3121
 owned_target;apu
 loadhw -hw [dict get $::info xsa]
 check_reset_hold reconnected
 halt_cores;halted_proof;apu
 check_reset_hold cores_halted
 select_core 0
 puts BUTTON_BOUNDED_DAP_RECONNECT_PASSED
 flush stdout
 if {$::state_file ne ""} {puts $::state_file "bounded_dap_reconnect_succeeded=true";flush $::state_file}
}