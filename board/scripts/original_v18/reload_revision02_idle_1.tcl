# Replace only the recorded revision-02 ELF after cooperative drain.
source [file join [file dirname [info script]] hmi_helpers.tcl]
if {[catch {
 if {$argc!=2} {error "Usage: candidate-package fresh-evidence-directory"}
 lassign $argv package out
 set package [file normalize $package];set out [file normalize $out]
 if {[file exists $out]} {error "Fresh evidence directory required"}
 set info [exec $python -I -B [file join $tool_root candidate_gate.py] $package]
 if {[dict get $info marker] ne "HMI_CANDIDATE_PREFLIGHT_PASSED"} {error "Candidate gate failed"}
 file mkdir $out;set state_file [open [file join $out progress.txt] {WRONLY CREAT EXCL}]
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 loadhw -hw [dict get $info xsa]
 core0_running_proof;core_halted_proof 1;apu
 set f [open [file join $tool_root .. .. provenance revision_02 text.bin] rb];set expected [read $f];close $f
 mrd -bin -file [file join $out old_text.bin] 0x00100000 [expr {([string length $expected]+3)/4}]
 set f [open [file join $out old_text.bin] rb];set observed [read $f];close $f
 if {$expected ne [string range $observed 0 [expr {[string length $expected]-1}]]} {error "Old executable differs"}
 set new_firmware 1
 hstandby
 # Quiesce only HMI UART before the ordinary full drain/CPU halt sequence.
 mwr 0xe000100c 0x3fff;after 100
 stop_known_full
 select_core 0
 if {[rd 0xf8f01308]&0x40000} {error "UART IRQ still active; refuse CPU-only recovery"}
 mwr 0xf8f01188 0x40000;mwr 0xf8f01288 0x40000
 stage replace_elf_without_bit_or_system_reset
 rst -processor;dow [dict get $info elf]
 foreach a [concat $identities {0x00ff1400 0x00ff2000 0x00ff6300}] {mwr $a 0;same $a 0}
 con;after 200;apu
 set deadline [expr {[clock milliseconds]+10000}]
 while {[rd 0x00ff2000]!=0x484d4931 || [rd 0x00ff6300]!=0x48514d31} {
  if {[clock milliseconds]>$deadline} {error "New HMI initialization timed out"};after 100
 }
 idle_errors;hls_idle;hchecked 14 0 stopped_after_reload
 same 0xe000101c 0;same 0xe0001020 1;same 0xe0001010 0xe5
 core0_running_proof;core_halted_proof 1;apu
 puts $state_file "manifest_sha256=[dict get $info manifest_sha256]\nsystem_reset_count=0\nbit_replaced=false"
 stage ready_for_runtime_checks
 close $state_file;set state_file "";disconnect
 puts HMI_IDLE_FIRMWARE_RELOAD_PASSED
} message options]} {
 puts stderr "HMI_IDLE_RELOAD_FAILED phase=$phase: $message";puts stderr [dict get $options -errorinfo]
 if {$state_file ne ""} {puts $state_file "failed=$message";close $state_file}
 catch {disconnect};exit 1
}
exit 0
