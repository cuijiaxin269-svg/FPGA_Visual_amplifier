set root [file normalize [file join [file dirname [info script]] ..]]
set workspace [file normalize [file join $root .. ..]]
set destination [file join $workspace b18hw]
if {[file exists $destination]} {error "Preserve existing b18hw; inspect before retry"}
set_param general.maxThreads 2
open_project [file join $workspace b16hw c.xpr]
save_project_as c $destination
config_ip_cache -disable_cache
# The immutable v16 IP repository includes the proven alpha=50 gates.
set_property ip_repo_paths [glob -types d [file join $workspace vision v16alpha50 ip_repo *]] [current_project]
update_ip_catalog
open_bd_design [get_files capture.bd]
set_property -dict [list CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} CONFIG.PCW_UART1_UART1_IO {EMIO} CONFIG.PCW_UART1_GRP_FULL_ENABLE {0}] [get_bd_cells ps]
create_bd_port -dir O hmi_uart_tx
create_bd_port -dir I hmi_uart_rx
connect_bd_net [get_bd_ports hmi_uart_tx] [get_bd_pins ps/UART1_TX]
connect_bd_net [get_bd_ports hmi_uart_rx] [get_bd_pins ps/UART1_RX]
validate_bd_design
save_bd_design
generate_target all [get_files capture.bd]
set previous [get_files -all -quiet *capture_wrapper.v]
if {[llength $previous]!=1} {error "Expected one old wrapper"}
remove_files $previous
set wrapper [make_wrapper -files [get_files capture.bd] -top]
add_files -norecurse $wrapper
set_property top capture_wrapper [current_fileset]
add_files -fileset constrs_1 -norecurse [file join $root constraints hmi_uart_p4.xdc]
set_property IS_ENABLED false [get_files -all *rgb2dvi_clocks.xdc]
set_property USED_IN_SYNTHESIS false [get_files observe_debug_hub.xdc]
set_property PROCESSING_ORDER LATE [get_files observe_debug_hub.xdc]
set_property STEPS.INIT_DESIGN.TCL.POST [file join $root scripts check_button_preopt.tcl] [get_runs impl_1]
set_property INCREMENTAL_CHECKPOINT [file join $workspace b16hw c.runs impl_1 capture_wrapper_routed.dcp] [get_runs impl_1]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.TCL.PRE {} [get_runs impl_1]
update_compile_order -fileset sources_1
write_bd_tcl -force [file join $root project capture_hmi_bd.tcl]
puts HMI_UART1_EMIO_PROJECT_PREPARED
close_project
exit
