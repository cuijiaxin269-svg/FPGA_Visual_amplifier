# Generate project-specific Zynq FSBL sources only. No hardware connection.
# Usage: xsct create_fsbl.tcl hardware.xsa fresh-fsbl-directory
if {$argc != 2} {
    puts stderr "Usage: xsct create_fsbl.tcl hardware.xsa fresh-fsbl-directory"
    exit 2
}
set xsa [file normalize [lindex $argv 0]]
set destination [file normalize [lindex $argv 1]]
if {[catch {
    if {![file isfile $xsa]} {error "XSA not found: $xsa"}
    if {[file exists $destination]} {error "FSBL destination must not exist: $destination"}
    if {![file isdirectory [file dirname $destination]]} {error "FSBL parent directory must exist"}
    cd [file dirname $destination]
    hsi::open_hw_design $xsa
    set cpu [hsi::get_cells -hier ps7_cortexa9_0]
    if {[llength $cpu] != 1} {error "Expected exactly one ps7_cortexa9_0 processor"}
    hsi::generate_app -app zynq_fsbl -proc ps7_cortexa9_0 -dir $destination -os standalone
    puts FSBL_SOURCES_GENERATED_REQUIRES_BUILD_AND_VALIDATION
} message options]} {
    puts stderr $message
    if {[dict exists $options -errorinfo]} {puts stderr [dict get $options -errorinfo]}
    exit 1
}
exit 0
