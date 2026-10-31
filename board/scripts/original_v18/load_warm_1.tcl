# Volatile replacement of the specifically recorded live v16alpha50 session.
# Arguments: candidate package, fresh evidence folder. No flash writes.
source [file join [file dirname [info script]] load_helpers.tcl]
if {[catch {
 if {$argc!=2} {error "Usage: candidate-package fresh-evidence-directory"}
 lassign $argv package out
 set package [file normalize $package];set out [file normalize $out]
 if {[file exists $out]} {error "Fresh evidence directory required"}
 set info [exec $python [file join $tool_root candidate_gate.py] $package]
 if {[dict get $info marker] ne "HMI_CANDIDATE_PREFLIGHT_PASSED"} {error "Candidate host/electrical gate failed"}
 file mkdir $out
 set state_file [open [file join $out progress.txt] {WRONLY CREAT EXCL}]
 stage connect_known_live_source
 set new_firmware 1
 connect -url tcp:127.0.0.1:3121
 owned_target;apu
 loadhw -hw [dict get $info old_xsa]
 core_halted_proof 1;apu
 foreach a $identities value $expected_ids {same $a $value}
 foreach a {0x00ff000c 0x00ff1004} {if {[rd $a] ni {1 2 3}} {error "Unsupported source state"}}
 foreach a {0x00ff0010 0x00ff1014} {same $a 0}
 if {[rd 0x00ff1070] ni {0 1}} {error "Source must be healthy live raw/amplified v16alpha50"}
 same 0x00ff1400 0x42544e31;same 0x00ff1170 0x53544231;same 0x43c30000 0x4f534432
 # Executable text is immutable. This read does not touch clear-on-read HLS.
 mrd -bin -file [file join $out old_text.bin] 0x00100000 [dict get $info old_text_words]
 set a [open [file join $tool_root expected_old_text.bin] rb];set expected [read $a];close $a
 set a [open [file join $out old_text.bin] rb];set observed [read $a];close $a
 if {$expected ne [string range $observed 0 [expr {[string length $expected]-1}]]} {error "Running source ELF text differs; refuse replacement"}
 foreach name {capture motion camera clip} address {0x00ff0000 0x00ff1000 0x00ff1300 0x00ff1200} words {133 32 15 32} {
  mrd -bin -file [file join $out source_${name}.bin] $address $words
 }
 stop_known_full
 stage system_reset_once
 select_core 0
 if {[catch {rst -system -stop} message reset_options]} {
  if {$message ne "Cannot reset APU. Timeout waiting DAP to reconnect after reset"} {return -options $reset_options $message}
  reconnect_reset_once
 } else {after 1000;halt_cores;halted_proof;select_core 0}
 stage ps_init_before_pl
 source [dict get $info ps_init]
 ps7_init
 after 100
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
 loadhw -hw [dict get $info xsa]
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
 mrd -bin -file [file join $out button_ready.bin] 0x00ff1400 16
 # Download/standby evidence only: these reads do not issue START or acquire frames.
 foreach name {capture motion spectrum} address {0x00ff0000 0x00ff1000 0x00ff1100} {
  mrd -bin -file [file join $out standby_${name}.bin] $address 32
 }
 mrd -bin -file [file join $out osd_identity.bin] 0x43c30000 1
 puts $state_file "new_bit=[dict get $info bit]\nnew_elf=[dict get $info elf]\nphysical_roi_verified=false"
 same 0x00ff2000 0x484d4931
 stage ready_for_runtime_checks
 close $state_file;set state_file ""
 disconnect
 puts HMI_VOLATILE_LOAD_PASSED
} message options]} {
 puts stderr "ALPHA50_LOAD_FAILED phase=$phase: $message"
 puts stderr [dict get $options -errorinfo]
 if {$state_file ne ""} {puts $state_file "failed=$message";close $state_file}
 catch {disconnect};exit 1
}
exit 0

