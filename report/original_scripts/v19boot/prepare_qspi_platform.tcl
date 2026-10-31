# Export a PS-MIO-only QSPI delta; retain the independently verified v18 PL bit.
set root [file normalize [file join [file dirname [info script]] ..]]
set workspace [file normalize [file join $root .. ..]]
set destination [file join $workspace b19boot]
if {[file exists $destination]} {error "Preserve existing b19boot"}
set_param general.maxThreads 2
open_project [file join $workspace b18hw c.xpr]
save_project_as c $destination
config_ip_cache -disable_cache
open_bd_design [get_files capture.bd]
write_bd_tcl -force [file join $root provenance capture_before_qspi.tcl]
set ps [get_bd_cells ps]
set before [dict create]
foreach p [list_property $ps] {if {[string match CONFIG.* $p]} {dict set before $p [get_property $p $ps]}}
set_property -dict [list CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} CONFIG.PCW_QSPI_GRP_DUAL_SS_ENABLE {0}] $ps
validate_bd_design
save_bd_design
set f [open [file join $root reports ps_config_delta.tsv] w]
foreach p [lsort [dict keys $before]] {
 set now [get_property $p $ps]
 if {$now ne [dict get $before $p]} {puts $f "$p\t[dict get $before $p]\t$now"}
}
close $f
write_bd_tcl -force [file join $root project capture_qspi_bd.tcl]
generate_target all [get_files capture.bd]
write_hw_platform -fixed -force -file [file join $root build candidate capture.xsa]
puts V19_QSPI_PLATFORM_EXPORTED
close_project
exit
