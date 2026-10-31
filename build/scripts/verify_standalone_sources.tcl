# Check before and after synthesis so automatic IP regeneration cannot undo the ECO.
set own [file normalize [get_property DIRECTORY [current_project]]]
foreach name {motion60_shared.v motion60_shared_phase_core_shared.v motion60_shared_phase_core_shared_1.v motion60_shared_phase_core_shared_2.v} {
 set matches [get_files -all -filter "NAME =~ */$name"]
 if {[llength $matches]!=1} {error "Ambiguous alpha gate source $name"}
 set path [file normalize [get_property NAME $matches]]
 if {[string first [string tolower "$own/"] [string tolower $path]]!=0} {error "Alpha gate is outside owned project"}
 set f [open $path rb];set observed [read $f];close $f
 set f [open [file join $root src ip motion60_shared hdl verilog $name] rb];set expected [read $f];close $f
 if {$observed ne $expected} {error "Effective alpha gate does not match independent source: $name"}
 if {[regexp -all {\.din1\(32'd1112014848\)} $observed]!=1 || [regexp {\.din1\(32'd1106247680\)} $observed]} {error "Alpha limit gate wrong in $name"}
}
puts ALPHA50_EFFECTIVE_GATE_SOURCES_VERIFIED
