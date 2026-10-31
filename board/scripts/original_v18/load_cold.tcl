# Reload requested by user. Require actual cold reset before touching DDR/PL.
source [file join [file dirname [info script]] load_helpers.tcl]
if {[catch {
 if {$argc!=2} {error "Usage: candidate-package fresh-evidence-directory"}
 lassign $argv package out
 set out [file normalize $out]
 if {[file exists $out]} {error "Fresh evidence directory required"}
 set info [exec $python -I -B [file join $tool_root candidate_gate.py] $package]
 if {[dict get $info marker] ne "HMI_CANDIDATE_PREFLIGHT_PASSED"} {error "Candidate host/electrical gate failed"}
 file mkdir $out
 set state_file [open [file join $out progress.txt] {WRONLY CREAT EXCL}]
 stage identify_cold_board
 connect -url tcp:127.0.0.1:3121
 owned_target;apu
 check_reset_hold before_any_halt_or_write
 loadhw -hw [dict get $info xsa]
 check_reset_hold after_loadhw
 halt_cores;halted_proof;apu
 check_reset_hold cores_halted
 stage system_reset_once
 select_core 0
 if {[catch {rst -system -stop} message reset_options]} {
  if {$message ne "Cannot reset APU. Timeout waiting DAP to reconnect after reset"} {return -options $reset_options $message}
  reconnect_reset_once
 } else {after 1000;halt_cores;halted_proof;apu;check_reset_hold after_system_reset;select_core 0}
 stage ps_init_before_pl
 source [dict get $info ps_init]
 ps7_init
 after 100
 apu
 if {([rd 0xf8006000]&1)!=1} {error "PS initialization did not release DDR reset"}
 targets -set -filter {name =~ "xc7z100*" && jtag_cable_serial == "210299725543"}
 stage download_candidate_bit
 fpga -file [dict get $info bit]
 select_core 0;rst -processor;ps7_post_config
 stage download_candidate_elf
 dow [dict get $info elf]
 foreach a [concat $identities {0x00ff1400}] {mwr $a 0;same $a 0}
 con;after 200
 select_core 1
 if {[catch {stop} message] && $message ne "Already stopped"} {error $message}
 core_halted_proof 1;apu
 set new_firmware 1
 set deadline [expr {[clock milliseconds]+10000}]
 while {1} {
  set ready 1
  foreach a [concat $identities {0x00ff1400 0x00ff000c 0x00ff1004 0x00ff0004 0x00ff1020 0x00ff0010 0x00ff1014}] value [concat $expected_ids {0x42544e31 1 1 0 0 0 0}] {
   if {[rd $a]!=$value} {set ready 0}
  }
  if {$ready} {break}
  if {[clock milliseconds]>$deadline} {error "Candidate firmware standby failed"}
  after 100
 }
 idle_errors;hls_idle
 same 0x43c30000 0x4f534432
 dma_halted 0x43000030 0x43000034;dma_halted 0x43100000 0x43100004
 core0_running_proof;core_halted_proof 1;apu
 foreach name {capture motion spectrum button} address {0x00ff0000 0x00ff1000 0x00ff1100 0x00ff1400} words {32 32 32 16} {
  mrd -bin -file [file join $out standby_${name}.bin] $address $words
 }
 puts $state_file "manifest_sha256=[dict get $info manifest_sha256]\nsystem_reset_count=1\nvolatile_only=true\nphysical_display_verified=false"
 same 0x00ff2000 0x484d4931
 stage clean_standby
 close $state_file;set state_file ""
 disconnect
 puts HMI_COLD_VOLATILE_LOAD_PASSED
} message options]} {
 puts stderr "ALPHA50_COLD_LOAD_FAILED phase=$phase: $message"
 puts stderr [dict get $options -errorinfo]
 if {$state_file ne ""} {puts $state_file "failed=$message";close $state_file}
 catch {disconnect};exit 1
}
exit 0

