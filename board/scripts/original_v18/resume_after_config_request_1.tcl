# One bounded retry from the proved post-PS-init state. No system reset.
source [file join [file dirname [info script]] load_helpers.tcl]
if {[catch {
 if {$argc!=2} {error "Usage: candidate-package fresh-evidence-directory"}
 lassign $argv package out
 set package [file normalize $package];set out [file normalize $out]
 if {[file exists $out]} {error "Fresh recovery evidence directory required"}
 set info [exec $python -I -B [file join $tool_root candidate_gate.py] $package]
 if {[dict get $info marker] ne "HMI_CANDIDATE_PREFLIGHT_PASSED"} {error "Candidate gate failed"}
 set previous [open [file join $tool_root .. load_01 progress.txt] r]
 set previous_text [read $previous];close $previous
 if {![string match "*failed=could not find configuration request.*" $previous_text]} {error "Recovery entry does not match the recorded configuration-request failure"}
 file mkdir $out;set state_file [open [file join $out progress.txt] {WRONLY CREAT EXCL}]
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 if {([rd 0xf8006000]&1)!=1 || ([rd 0xf8000240]&15)!=15} {error "Require DDR initialized and PL resets held"}
 core_halted_proof 1;core_halted_proof 0
 loadhw -hw [dict get $info xsa]
 source [dict get $info ps_init]
 targets -set -filter {name =~ "xc7z100*" && jtag_cable_serial == "210299725543"}
 puts "HMI_FPGA_BEFORE [fpga -state]"
 puts "HMI_CONFIG_STATUS_BEFORE [fpga -config-status]"
 stage retry_fpga_configuration_without_system_reset
 fpga -file [dict get $info bit]
 puts "HMI_FPGA_AFTER [fpga -state]"
 select_core 0;rst -processor;ps7_post_config
 stage download_candidate_elf
 dow [dict get $info elf]
 foreach a [concat $identities {0x00ff1400 0x00ff2000 0x00ff6300}] {mwr $a 0;same $a 0}
 con;after 200
 core_halted_proof 1;apu
 set deadline [expr {[clock milliseconds]+10000}]
 while {1} {
  set ready 1
  foreach a [concat $identities {0x00ff1400 0x00ff000c 0x00ff1004 0x00ff2000 0x00ff6300}] value [concat $expected_ids {0x42544e31 1 1 0x484d4931 0x48514d31}] {
   if {[rd $a]!=$value} {set ready 0}
  }
  if {$ready} {break}
  if {[clock milliseconds]>$deadline} {error "HMI standby did not initialize"}
  after 100
 }
 set new_firmware 1;idle_errors;hls_idle
 dma_halted 0x43000030 0x43000034;dma_halted 0x43100000 0x43100004
 core0_running_proof;apu
 mrd -bin -file [file join $out standby_hmi.bin] 0x00ff2000 64
 puts $state_file "additional_system_reset_count=0\nmanifest_sha256=[dict get $info manifest_sha256]"
 stage recovered_to_standby
 close $state_file;set state_file "";disconnect
 puts HMI_CONFIG_REQUEST_RECOVERY_PASSED
} message options]} {
 puts stderr "HMI_RECOVERY_FAILED phase=$phase: $message"
 if {$state_file ne ""} {puts $state_file "failed=$message";close $state_file}
 catch {disconnect};exit 1
}
exit 0
