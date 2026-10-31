# Optional HLS regeneration entry point, relocated from the archived scripts.
# This does not replace the sealed IP used by the main Vivado build.
set root [file normalize [file join [file dirname [info script]] .. .. ..]]
set sources [file join $root src hls]
set target motion60_shared
set mode csim
if {[info exists ::env(FPGA_HLS_TARGET)]} {set target $::env(FPGA_HLS_TARGET)}
if {[info exists ::env(FPGA_HLS_MODE)]} {set mode $::env(FPGA_HLS_MODE)}
if {$target ni {motion60_shared clip_copy_checked motion60_full_temporal_v2 roi256 spectrum256_pl}} {
    error "Unknown FPGA_HLS_TARGET: $target"
}
if {$mode ni {csim synth}} {error "FPGA_HLS_MODE must be csim or synth"}
set output [file join $root _build hls ${target}_${mode}]
if {[info exists ::env(FPGA_HLS_OUTPUT_DIR)]} {set output [file normalize $::env(FPGA_HLS_OUTPUT_DIR)]}
if {[file exists $output]} {error "Use a fresh FPGA_HLS_OUTPUT_DIR: $output"}
set vectors {}
if {$target eq "roi256"} {
    set vectors [file join $root _build hls roi256_vectors]
    if {[info exists ::env(FPGA_HLS_VECTOR_DIR)]} {set vectors [file normalize $::env(FPGA_HLS_VECTOR_DIR)]}
    foreach name {input0.bin input1.bin input2.bin input3.bin expected.bin} {
        if {![file isfile [file join $vectors $name]]} {
            error "Missing ROI vector $name; first run generate_roi_vectors.py"
        }
    }
}
if {$target eq "motion60_shared" && $mode eq "synth" && ![info exists ::env(FPGA_PYTHON)]} {
    error "Set FPGA_PYTHON to Python 3 for the required FIFO post-export check"
}
file mkdir [file dirname $output]
open_component $output -flow_target vivado
cd $output
set flags "-std=c++14 -I\"[file join $sources motion60_shared]\""
switch -- $target {
    motion60_shared {
        set_top motion60_shared
        if {$mode eq "csim"} {
            append flags " -DMOTION_WIDTH=128 -DMOTION_HEIGHT=96"
        } else {
            append flags " -DMOTION_WIDTH=1280 -DMOTION_HEIGHT=800"
        }
        foreach name {pipeline.cpp phase_core.cpp} {
            add_files [file join $sources motion60_shared $name] -cflags $flags
        }
        if {$mode eq "csim"} {
            add_files -tb [file join $sources tests alpha50 baseline_phase.cpp] -cflags "$flags -Dphase_core_shared=baseline_phase_core_shared"
            add_files -tb [file join $sources tests alpha50 test_alpha50.cpp] -cflags $flags
        }
    }
    clip_copy_checked {
        set_top clip_copy_checked
        add_files [file join $sources motion60_shared clip_copy_checked.cpp] -cflags $flags
        add_files -tb [file join $sources motion60_shared test_copy_checked.cpp] -cflags $flags
    }
    motion60_full_temporal_v2 {
        set_top clip_temporal_full
        add_files [file join $sources motion60_shared clip_temporal_v2.cpp] -cflags $flags
        add_files -tb [file join $sources motion60_shared test_temporal_v2.cpp] -cflags $flags
    }
    roi256 {
        set_top roi256
        add_files [file join $sources roi256 roi256.cpp] -cflags $flags
        add_files -tb [file join $sources roi256 test_roi256.cpp] -cflags $flags
    }
    spectrum256_pl {
        set_top spectrum256_pl
        add_files [file join $sources spectrum256_pl spectrum256_pl.cpp] -cflags $flags
        add_files -tb [file join $sources spectrum256 spectrum256.cpp] -cflags $flags
        add_files -tb [file join $sources spectrum256_pl test_spectrum256_pl.cpp] -cflags $flags
    }
}
set_part xc7z100ffg900-2
create_clock -period 6.666667 -name default
# The alpha50 test is a 128x96 C simulation, not a 1280x800 co-simulation.
if {$target eq "roi256"} {
    csim_design -argv $vectors
} elseif {$target ne "motion60_shared" || $mode eq "csim"} {
    csim_design
}
if {$mode eq "synth"} {
    csynth_design
    export_design -format ip_catalog
    if {$target eq "motion60_shared"} {
        set fifo [glob -nocomplain [file join $output hls impl ip hdl verilog *_fifo_w32_d131072_A.v]]
        if {[llength $fifo] != 1} {error "Expected exactly one reviewed 128K startup FIFO; review new HLS output"}
        puts [exec $::env(FPGA_PYTHON) [file join $root build scripts hls preserve_motion60_fifo_address.py] [lindex $fifo 0]]
    }
}
puts "HLS_LOCAL_RUN_COMPLETED target=$target mode=$mode output=$output"
exit
