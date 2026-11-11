# Source after validate_bd_design with capture.bd open. This is structural
# validation only; timing closure, bandwidth and board operation need a build.
proc roi_expect_property {object property expected} {
    set observed [get_property $property $object]
    if {$observed ne $expected} {
        error "ROI integration: $object $property is $observed, expected $expected"
    }
}
proc roi_expect_pin_net {first second} {
    set a [get_bd_nets -of_objects [get_bd_pins $first]]
    set b [get_bd_nets -of_objects [get_bd_pins $second]]
    if {[llength $a] != 1 || $a ne $b} {
        error "ROI integration: $first and $second must share one net"
    }
}
proc roi_expect_interface_net {first second} {
    set a [get_bd_intf_nets -of_objects [get_bd_intf_pins $first]]
    set b [get_bd_intf_nets -of_objects [get_bd_intf_pins $second]]
    if {[llength $a] != 1 || $a ne $b} {
        error "ROI integration: $first and $second must share one interface net"
    }
}
proc roi_address_bytes {value} {
    if {[regexp -nocase {^([0-9]+)([KMG])$} $value -> count unit]} {
        set scale [dict get {K 1024 M 1048576 G 1073741824} [string toupper $unit]]
        return [expr {$count * $scale}]
    }
    return [expr {$value + 0}]
}
if {[llength [get_bd_cells -quiet roi_compose]] != 1} {
    error "ROI integration: compositor module is missing"
}
roi_expect_property [get_bd_cells roi_compose] VLNV xilinx.com:module_ref:motion60_roi_compose:1.0
roi_expect_property [get_bd_cells ctrl_intercon] CONFIG.NUM_MI 11
roi_expect_property [get_bd_cells mem] CONFIG.NUM_SI 10
roi_expect_property [get_bd_intf_pins roi_compose/S_AXI] CONFIG.PROTOCOL AXI4LITE
roi_expect_property [get_bd_intf_pins roi_compose/M_AXI] CONFIG.PROTOCOL AXI4
roi_expect_property [get_bd_intf_pins roi_compose/M_AXI] CONFIG.DATA_WIDTH 64
foreach pin {roi_compose/aclk ctrl_intercon/M10_ACLK mem/S09_ACLK} {
    roi_expect_pin_net $pin ps/FCLK_CLK1
}
foreach pin {roi_compose/aresetn ctrl_intercon/M10_ARESETN mem/S09_ARESETN} {
    roi_expect_pin_net $pin r150/peripheral_aresetn
}
roi_expect_interface_net roi_compose/S_AXI ctrl_intercon/M10_AXI
roi_expect_interface_net roi_compose/M_AXI mem/S09_AXI
roi_expect_interface_net mem/M00_AXI ps/S_AXI_HP0
# The camera viewport and HDMI scan timing are independent of the new ROI.
foreach {property expected} {
    WIDTH 1280 HEIGHT 800 H_ACTIVE 1920 V_ACTIVE 1080
    H_FP 88 H_SYNC 44 H_BP 148 V_FP 4 V_SYNC 5 V_BP 36
} {
    roi_expect_property [get_bd_cells video] CONFIG.$property $expected
}
roi_expect_interface_net display_dma/M_AXIS_MM2S display_cdc/S_AXIS
roi_expect_interface_net display_cdc/M_AXIS video/S_AXIS
set roi_control_segments [get_bd_addr_segs -quiet ps/Data/SEG_roi_compose_reg0]
if {[llength $roi_control_segments] != 1} {
    error "ROI integration: expected one PS control mapping"
}
if {[roi_address_bytes [get_property OFFSET $roi_control_segments]] != 0x43c60000 ||
    [roi_address_bytes [get_property RANGE $roi_control_segments]] != 0x1000} {
    error "ROI integration: expected control range 0x43c60000..0x43c60fff"
}
set roi_memory_segments [get_bd_addr_segs -of_objects [get_bd_addr_spaces roi_compose/M_AXI]]
if {[llength $roi_memory_segments] != 1 ||
    [roi_address_bytes [get_property OFFSET $roi_memory_segments]] != 0 ||
    [roi_address_bytes [get_property RANGE $roi_memory_segments]] != 0x40000000} {
    error "ROI integration: expected one 1 GiB DDR address mapping"
}
puts ROI_BD_INTEGRATION_PASSED
