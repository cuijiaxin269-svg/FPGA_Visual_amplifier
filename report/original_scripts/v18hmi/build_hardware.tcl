set root [file normalize [file join [file dirname [info script]] ..]]
set workspace [file normalize [file join $root .. ..]]
set baseline [file join $workspace vision v11resetfix]
set project [file join $workspace b18hw c.xpr]
set_param general.maxThreads 2
open_project $project
# save_project_as retains this user-disable property under the old absolute
# path. Rebind it to the actual copied IP, as in the original v14 build.
set obsolete [get_files -all -quiet *rgb2dvi_clocks.xdc]
if {[llength $obsolete]!=1} {error "Expected one obsolete internal HDMI clock constraint"}
set_property IS_ENABLED false $obsolete
# These debug connections apply after debug insertion, as in the source build.
set_property USED_IN_SYNTHESIS false [get_files observe_debug_hub.xdc]
set_property PROCESSING_ORDER LATE [get_files observe_debug_hub.xdc]
create_ip_run [get_files capture.bd]
source [file join $root scripts verify_gate_sources.tcl]
# Creating nested CSI IP runs can invalidate the copied completed runs only at
# this point. Rebuild those runs explicitly before launching the top level.
set stale {}
foreach run [get_runs -filter {IS_SYNTHESIS == 1}] {
 if {[get_property NEEDS_REFRESH $run]} {lappend stale $run}
}
if {[llength $stale]} {puts "ALPHA50_REFRESH_SYNTHESIS_RUNS $stale";reset_runs $stale}
if {$argc && [lindex $argv 0] eq "restart-unstarted"} {
 # Used only after the owned stalled scheduler has been terminated. No OOC
 # checkpoint existed in this attempt; reset the queued run states normally.
 reset_runs [get_runs -filter {IS_SYNTHESIS == 1}]
}
if {!$argc || [lindex $argv 0] ne "restart-impl"} {
 launch_runs synth_1 -jobs 2
 wait_on_run synth_1
}
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {error "Button synthesis failed"}
foreach run [get_runs -filter {IS_SYNTHESIS == 1}] {
 if {[get_property PROGRESS $run] ne "100%" || [get_property NEEDS_REFRESH $run]} {error "Synthesis is not current: $run"}
}
source [file join $root scripts verify_gate_sources.tcl]
open_run synth_1
set watchdog [get_cells -hier -filter {NAME =~ */stale_frames_reg* && REF_NAME =~ FD*}]
if {[llength $watchdog]<6 || [llength $watchdog]>8} {error "Valid-display watchdog missing: [llength $watchdog]"}
puts "ALPHA50_SYNTH_WATCHDOG_BITS [llength $watchdog]"
report_utilization -file [file join $root reports synthesis_utilization.txt]
report_drc -file [file join $root reports synthesis_drc.txt]
close_design
if {$argc && [lindex $argv 0] eq "restart-impl"} {reset_runs impl_1}
set_property INCREMENTAL_CHECKPOINT [file join $workspace b16hw c.runs impl_1 capture_wrapper_routed.dcp] [get_runs impl_1]
set_property AUTO_INCREMENTAL_CHECKPOINT 0 [get_runs impl_1]
set_property STEPS.INIT_DESIGN.TCL.POST [file join $root scripts check_button_preopt.tcl] [get_runs impl_1]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE AggressiveExplore [get_runs impl_1]
launch_runs impl_1 -to_step {phys_opt_design (Post-Route)} -jobs 2
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {error "Button implementation failed"}
open_run impl_1
report_timing_summary -report_unconstrained -file [file join $root reports routed_timing.txt]
report_drc -file [file join $root reports routed_drc.txt]
report_cdc -details -file [file join $root reports routed_cdc.txt]
report_bus_skew -file [file join $root reports routed_bus_skew.txt]
report_io -file [file join $root reports routed_io.txt]
report_utilization -file [file join $root reports routed_utilization.txt]
if {[llength [get_drc_violations -quiet -filter {SEVERITY == Error || SEVERITY == {Critical Warning}}]]} {error "Unresolved DRC"}
set f [open [file join $root reports routed_timing.txt]];set timing [read $f];close $f
if {![string match "*All user specified timing constraints are met.*" $timing] || ![regexp {checking no_clock \(0\)} $timing]} {error "Timing/no-clock gate failed"}
foreach check {generated_clocks unconstrained_internal_endpoints} {
 if {![string match "*checking $check (0)*" $timing]} {error "Timing gate failed: $check"}
}
set f [open [file join $root reports routed_cdc.txt]];set cdc [read $f];close $f
if {[regexp {CDC-[0-9]+[ \t|]+Critical} $cdc]} {error "Critical CDC"}
set f [open [file join $root reports routed_bus_skew.txt]];set skew [read $f];close $f
if {[string match "*VIOLATED*" $skew]} {error "Bus skew failed"}
set variant hmi2021
source [file join $baseline scripts check_motion60_single_clock.tcl]
foreach {name pin direction} {hmi_uart_tx AH12 OUT hmi_uart_rx AG12 IN} {
 set port [get_ports $name]
 if {[llength $port]!=1 || [get_property PACKAGE_PIN $port] ne $pin || [get_property IOSTANDARD $port] ne "LVCMOS33" || [get_property DIRECTION $port] ne $direction} {error "HMI UART pin binding: $name"}
}
puts HMI_P4_IO_BINDING_VERIFIED
set key [get_ports key0_n]
if {[llength $key]!=1 || [get_property PACKAGE_PIN $key] ne "Y22" || [get_property IOSTANDARD $key] ne "LVCMOS33" || [get_property DIRECTION $key] ne "IN"} {error "KEY0 pin binding"}
set stages [get_cells -hier -filter {NAME =~ */sccb/inst/key_meta_reg || NAME =~ */sccb/inst/key_sync_reg}]
if {[llength $stages]!=2} {error "KEY0 synchronizer missing"}
foreach cell $stages {if {![get_property ASYNC_REG $cell]} {error "KEY0 ASYNC_REG missing"}}
set guards [get_cells -hier -filter {REF_NAME == FDCE && NAME =~ *pixel_reset_guard*/release_pipeline_reg*}]
if {[llength $guards]!=16} {error "Original 16-stage pixel reset guard missing"}
set all_hs [get_ports {dphy_clk_hs_p dphy_clk_hs_n dphy_data_hs_p[*] dphy_data_hs_n[*]}]
if {[llength $all_hs]!=6} {error "Camera HS ports missing"}
foreach port $all_hs {if {[get_property DIFF_TERM $port]} {error "Camera has external termination"}}
close_design
launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {error "Bitstream failed"}
open_run impl_1
set output [file join $root build candidate]
file mkdir $output
file copy [file join [get_property DIRECTORY [get_runs impl_1]] capture_wrapper.bit] [file join $output capture.bit]
write_hw_platform -fixed -include_bit -file [file join $output capture.xsa]
write_debug_probes -force [file join $output capture.ltx]
puts HMI_2021_BIT_BUILT_REQUIRES_RUNTIME_VALIDATION
close_project
exit
