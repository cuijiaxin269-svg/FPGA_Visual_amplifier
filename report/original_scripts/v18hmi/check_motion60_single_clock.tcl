# Invoked on final routed v11 design; no timing exceptions are added.
set gate_path [file join $root reports clock_source_gate_${variant}.txt]
if {[file exists $gate_path]} {file delete $gate_path}
foreach {kind count} {BUFIO 1 BUFR 2 MMCME2_ADV 0 MMCME2_BASE 1} {
 set cells [get_cells -hier -quiet -filter "REF_NAME == $kind && NAME =~ *pixel_clock*"]
 # Synthesis may map MMCME2_BASE to MMCME2_ADV; count MMCMs collectively below.
 if {$kind in {BUFIO BUFR} && [llength $cells]!=$count} {error "Invalid single clock buffer topology"}
}
set mmcms [get_cells -hier -quiet -filter {REF_NAME =~ MMCME2* && NAME =~ *pixel_clock*}]
if {[llength $mmcms]!=1 || [llength [get_cells -hier -quiet -filter {REF_NAME =~ MMCME2* && NAME =~ *hdmi*}]]} {error "Expected one display MMCM"}
set pp [get_pins -hier -quiet -filter {NAME =~ *pixel_clock*pixel_buffer/O}]
set sp [get_pins -hier -quiet -filter {NAME =~ *pixel_clock*serial_buffer/O}]
if {[llength $pp]!=1 || [llength $sp]!=1} {error "Missing clock buffer outputs"}
set pixel [get_clocks -of_objects $pp]
set serial [get_clocks -of_objects $sp]
set upstream [get_clocks clk_fpga_0]
foreach {clk period} [list $pixel [expr {1000.0/74.25}] $serial [expr {1000.0/371.25}] $upstream 10.0] {
 if {[llength $clk]!=1 || abs([get_property PERIOD $clk]-$period)>0.001} {error "Display clock frequency mismatch"}
}
foreach clk [list $pixel $serial] {
 set chain $clk
 for {set i 0} {$i<8 && [get_property NAME $chain] ne "clk_fpga_0"} {incr i} {
  if {![get_property IS_GENERATED $chain]} {error "Display clock has wrong root"}
  set chain [get_clocks [get_property MASTER_CLOCK $chain]]
  if {[llength $chain]!=1} {error "Ambiguous display clock ancestry"}
 }
 if {[get_property NAME $chain] ne "clk_fpga_0"} {error "Display clock does not derive from FCLK0"}
}
report_methodology -file [file join $root reports methodology_${variant}.txt]
if {[llength [get_methodology_violations -quiet -filter {SEVERITY == {Critical Warning}}]]} {error "Critical methodology finding"}
set f [open $gate_path w]
puts $f MOTION60_CLOCK_SOURCE_GATE_PASSED
puts $f "single_mmcm=1 pixel_period=[get_property PERIOD $pixel] serial_period=[get_property PERIOD $serial]"
close $f
