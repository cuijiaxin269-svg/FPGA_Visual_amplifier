# Generated from the actual b18hw file list; custom inputs verified byte-for-byte.
set root [file normalize [file join [file dirname [info script]] ..]]
if {$argc!=1} {error "Usage: fresh-project-directory"}
set destination [file normalize [lindex $argv 0]]
if {[file exists $destination]} {error "Preserve existing destination"}
create_project c $destination -part xc7z100ffg900-2
set_property target_language Verilog [current_project]
set_property ip_repo_paths [glob -types d [file join $root ip_repo *]] [current_project]
update_ip_catalog
set f [file join $root {rtl/sccb_bridge.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/capture_test_source.sv}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/raw10_axis_guard.sv}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/capture_csi_core.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/motion60_overlay_control.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/hdmi_1080_clock.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/hdmi_diagnostic_pattern.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/full_hdmi_observe.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/full_hdmi_health.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/pixel_reset_guard.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/motion60_spectrum_overlay.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/motion60_video.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/motion60_video_osd.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/camera_clock_gate.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/capture_core.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/hdmi_diagnostic_motion_ui.v}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/capture_core.sv}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {rtl/csi2_raw10_rx.sv}]
add_files -fileset sources_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property USED_IN_SIMULATION true [get_files $f]
set f [file join $root {constraints/camera_amd.xdc}]
add_files -fileset constrs_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property PROCESSING_ORDER LATE [get_files $f]
set f [file join $root {constraints/camera_performance.xdc}]
add_files -fileset constrs_1 -norecurse $f
set_property USED_IN_SYNTHESIS false [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property PROCESSING_ORDER LATE [get_files $f]
set f [file join $root {constraints/camera_counter_cdc.xdc}]
add_files -fileset constrs_1 -norecurse $f
set_property USED_IN_SYNTHESIS false [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property PROCESSING_ORDER LATE [get_files $f]
set f [file join $root {constraints/common.xdc}]
add_files -fileset constrs_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set f [file join $root {constraints/motion60_hdmi.xdc}]
add_files -fileset constrs_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set f [file join $root {constraints/observe_debug_hub.xdc}]
add_files -fileset constrs_1 -norecurse $f
set_property USED_IN_SYNTHESIS false [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property PROCESSING_ORDER LATE [get_files $f]
set f [file join $root {constraints/pixel_reset_guard_async.xdc}]
add_files -fileset constrs_1 -norecurse $f
set_property USED_IN_SYNTHESIS false [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property PROCESSING_ORDER LATE [get_files $f]
set f [file join $root {constraints/mode_button.xdc}]
add_files -fileset constrs_1 -norecurse $f
set_property USED_IN_SYNTHESIS false [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
set_property PROCESSING_ORDER LATE [get_files $f]
set f [file join $root {constraints/hmi_uart_p4.xdc}]
add_files -fileset constrs_1 -norecurse $f
set_property USED_IN_SYNTHESIS true [get_files $f]
set_property USED_IN_IMPLEMENTATION true [get_files $f]
source [file join $root project capture_qspi_bd.tcl]
validate_bd_design
save_bd_design
generate_target all [get_files capture.bd]
add_files -norecurse [make_wrapper -files [get_files capture.bd] -top]
set_property top capture_wrapper [current_fileset]
set_property IS_ENABLED false [get_files -all *rgb2dvi_clocks.xdc]
update_compile_order -fileset sources_1
puts V19_QSPI_STANDALONE_PROJECT_CREATED
close_project
exit

