# Physical implementation only. The host has 8 logical CPUs and sufficient
# free memory; synthesis jobs remain capped independently by the build driver.
set_param general.maxThreads 4
if {[llength [get_clocks -quiet capture_i/hdmi/U0/SerialClk]]} {
 error "Obsolete internal HDMI clock must stay disabled; external MMCM drives both pixel and serial clocks"
}
set meta [get_cells -hier -filter {NAME =~ */sccb/inst/key_meta_reg}]
set sync [get_cells -hier -filter {NAME =~ */sccb/inst/key_sync_reg}]
if {[llength $meta]!=1 || [llength $sync]!=1} {error "KEY0 synchronizer must contain exactly two named stages"}
foreach cell [concat $meta $sync] {
 if {![get_property ASYNC_REG $cell]} {error "KEY0 synchronizer attribute missing"}
}
set key [get_ports key0_n]
if {[llength $key]!=1 || [get_property PACKAGE_PIN $key] ne "Y22" || [get_property IOSTANDARD $key] ne "LVCMOS33"} {error "KEY0 pin/voltage binding failed"}
puts BUTTON_PREOPT_PIN_AND_SYNCHRONIZER_PASSED
