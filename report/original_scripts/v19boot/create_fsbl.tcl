set root [file normalize [file join [file dirname [info script]] ..]]
if {[catch {
 hsi::open_hw_design [file join $root build candidate capture.xsa]
 hsi::generate_app -app zynq_fsbl -proc ps7_cortexa9_0 -dir [file join $root build fsbl] -os standalone
 puts V19_FSBL_SOURCES_GENERATED
} message options]} {puts stderr $message;puts stderr [dict get $options -errorinfo];exit 1}
exit 0
