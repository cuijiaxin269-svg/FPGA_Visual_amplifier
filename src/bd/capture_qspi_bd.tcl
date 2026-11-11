# Adapted from the v19 Vivado 2021.2 export for Vivado 2025.2.
# CSI RX subsystem is recreated as v6.0; board runtime validation remains required.

################################################################
# This is a generated script based on design: capture
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source capture_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# capture_csi_core, full_hdmi_health, full_hdmi_observe, motion60_overlay_control, hdmi_1080_clock, pixel_reset_guard, sccb_bridge, motion60_video_osd

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z100ffg900-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name capture

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:hls:clip_copy_checked:1.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:mipi_csi2_rx_subsystem:6.0\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:hls:clip_temporal_full:1.0\
digilentinc.com:ip:rgb2dvi:1.3\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:hls:motion60_shared:1.0\
xilinx.com:ip:vio:3.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axi_clock_converter:2.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:hls:roi256:1.0\
xilinx.com:hls:spectrum256_pl:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
capture_csi_core\
full_hdmi_health\
full_hdmi_observe\
motion60_overlay_control\
motion60_roi_compose\
hdmi_1080_clock\
pixel_reset_guard\
sccb_bridge\
motion60_video_osd\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR_0 ]

  set FIXED_IO_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO_0 ]

  set TMDS_0 [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS_0 ]

  set cam_i2c [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 cam_i2c ]


  # Create ports
  set dphy_clk_hs_n [ create_bd_port -dir I dphy_clk_hs_n ]
  set dphy_clk_hs_p [ create_bd_port -dir I dphy_clk_hs_p ]
  set dphy_clk_lp_n [ create_bd_port -dir I dphy_clk_lp_n ]
  set dphy_clk_lp_p [ create_bd_port -dir I dphy_clk_lp_p ]
  set dphy_data_hs_n [ create_bd_port -dir I -from 1 -to 0 dphy_data_hs_n ]
  set dphy_data_hs_p [ create_bd_port -dir I -from 1 -to 0 dphy_data_hs_p ]
  set dphy_data_lp_n [ create_bd_port -dir I -from 1 -to 0 dphy_data_lp_n ]
  set dphy_data_lp_p [ create_bd_port -dir I -from 1 -to 0 dphy_data_lp_p ]
  set hmi_uart_rx [ create_bd_port -dir I hmi_uart_rx ]
  set hmi_uart_tx [ create_bd_port -dir O hmi_uart_tx ]
  set key0_n [ create_bd_port -dir I key0_n ]

  # Create instance: clip_dma, and set properties
  set clip_dma [ create_bd_cell -type ip -vlnv xilinx.com:hls:clip_copy_checked:1.0 clip_dma ]

  # Create instance: controls, and set properties
  set controls [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 controls ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $controls

  # Create instance: core, and set properties
  set block_name capture_csi_core
  set block_cell_name core
  if { [catch {set core [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $core eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.FIXED_PHY {1} \
 ] $core

  # Create instance: csi, and set properties
  set csi [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:6.0 csi ]
  set_property -dict [ list \
   CONFIG.CMN_INC_VFB {true} \
   CONFIG.CMN_NUM_LANES {2} \
   CONFIG.CMN_NUM_PIXELS {4} \
   CONFIG.CMN_PXL_FORMAT {RAW10} \
   CONFIG.CSI_BUF_DEPTH {4096} \
   CONFIG.CSI_CONTROLLER_REG_IF {true} \
   CONFIG.C_CAL_MODE {FIXED} \
   CONFIG.C_CSI_EN_CRC {true} \
   CONFIG.C_IDLY_TAP {1} \
   CONFIG.C_OOC_VID_CLK {10.000} \
   CONFIG.C_SHARE_IDLYCTRL {true} \
   CONFIG.DPY_EN_REG_IF {true} \
   CONFIG.DPY_LINE_RATE {400} \
   CONFIG.VFB_TU_WIDTH {96} \
 ] $csi

  # Create instance: ctrl_intercon, and set properties
  set ctrl_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ctrl_intercon ]
  set_property -dict [ list \
   CONFIG.NUM_MI {11} \
   CONFIG.NUM_SI {1} \
 ] $ctrl_intercon

  # Create instance: display_cdc, and set properties
  set display_cdc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 display_cdc ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {4096} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.TDATA_NUM_BYTES {2} \
   CONFIG.TUSER_WIDTH {1} \
 ] $display_cdc

  # Create instance: display_dma, and set properties
  set display_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 display_dma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {1} \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_mm2s_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_mm2s_linebuffer_depth {4096} \
   CONFIG.c_mm2s_max_burst_length {64} \
   CONFIG.c_num_fstores {3} \
   CONFIG.c_use_fsync {1} \
 ] $display_dma

  # Create instance: display_mem, and set properties
  set display_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 display_mem ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.S00_HAS_DATA_FIFO {2} \
   CONFIG.S01_HAS_DATA_FIFO {2} \
 ] $display_mem

  # Create instance: f, and set properties
  set f [ create_bd_cell -type ip -vlnv xilinx.com:hls:clip_temporal_full:1.0 f ]

  # Create instance: hdmi, and set properties
  set hdmi [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.3 hdmi ]
  set_property -dict [ list \
   CONFIG.kClkRange {2} \
   CONFIG.kGenerateSerialClk {false} \
   CONFIG.kRstActiveHigh {false} \
 ] $hdmi

  # Create instance: hdmi_health, and set properties
  set block_name full_hdmi_health
  set block_cell_name hdmi_health
  if { [catch {set hdmi_health [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $hdmi_health eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: hdmi_observe, and set properties
  set block_name full_hdmi_observe
  set block_cell_name hdmi_observe
  if { [catch {set hdmi_observe [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $hdmi_observe eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: lp_concat, and set properties
  set lp_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 lp_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {6} \
 ] $lp_concat

  # Create instance: lp_n_0, and set properties
  set lp_n_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 lp_n_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $lp_n_0

  # Create instance: lp_n_1, and set properties
  set lp_n_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 lp_n_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $lp_n_1

  # Create instance: lp_p_0, and set properties
  set lp_p_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 lp_p_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $lp_p_0

  # Create instance: lp_p_1, and set properties
  set lp_p_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 lp_p_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $lp_p_1

  # Create instance: mem, and set properties
  set mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 mem ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {10} \
   CONFIG.S01_HAS_DATA_FIFO {2} \
   CONFIG.S02_HAS_DATA_FIFO {2} \
   CONFIG.S03_HAS_DATA_FIFO {2} \
   CONFIG.S04_HAS_DATA_FIFO {2} \
   CONFIG.S05_HAS_DATA_FIFO {2} \
   CONFIG.S06_HAS_DATA_FIFO {2} \
   CONFIG.S07_HAS_DATA_FIFO {2} \
   CONFIG.S08_HAS_DATA_FIFO {2} \
 ] $mem

  # Create instance: motion, and set properties
  set motion [ create_bd_cell -type ip -vlnv xilinx.com:hls:motion60_shared:1.0 motion ]

  # Compose a square motion ROI in a held DDR output frame. The sealed motion
  # accelerator and the existing single-stream HDMI path remain unchanged.
  set roi_compose [create_bd_cell -type module -reference motion60_roi_compose roi_compose]

  # Create instance: observe_health_vio, and set properties
  set observe_health_vio [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 observe_health_vio ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_IN {4} \
   CONFIG.C_NUM_PROBE_OUT {0} \
 ] $observe_health_vio

  # Create instance: observe_pixel_vio, and set properties
  set observe_pixel_vio [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 observe_pixel_vio ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_IN {16} \
   CONFIG.C_NUM_PROBE_OUT {1} \
   CONFIG.C_PROBE_OUT0_INIT_VAL {0x0} \
   CONFIG.C_PROBE_OUT0_WIDTH {1} \
 ] $observe_pixel_vio

  # Create instance: one, and set properties
  set one [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 one ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $one

  # Create instance: overlay_cdc, and set properties
  set overlay_cdc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 overlay_cdc ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.PROTOCOL {AXI4LITE} \
 ] $overlay_cdc

  # Create instance: overlay_control, and set properties
  set block_name motion60_overlay_control
  set block_cell_name overlay_control
  if { [catch {set overlay_control [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $overlay_control eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pixel_clock, and set properties
  set block_name hdmi_1080_clock
  set block_cell_name pixel_clock
  if { [catch {set pixel_clock [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pixel_clock eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.SERIAL_DIVIDE {2} \
 ] $pixel_clock

  # Create instance: pixel_reset, and set properties
  set pixel_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 pixel_reset ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $pixel_reset

  # Create instance: pixel_reset_guard, and set properties
  set block_name pixel_reset_guard
  set block_cell_name pixel_reset_guard
  if { [catch {set pixel_reset_guard [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pixel_reset_guard eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pixels_cdc, and set properties
  set pixels_cdc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 pixels_cdc ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {4096} \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
   CONFIG.SYNCHRONIZATION_STAGES {3} \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.TUSER_WIDTH {1} \
 ] $pixels_cdc

  # Create instance: ps, and set properties
  set ps [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {800.000000} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {150.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {800} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {48} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {150000000} \
   CONFIG.PCW_CLK2_FREQ {200000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {800} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1600.000} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
   CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
   CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {1} \
   CONFIG.PCW_EN_EMIO_GPIO {1} \
   CONFIG.PCW_EN_EMIO_I2C0 {1} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {1} \
   CONFIG.PCW_EN_I2C0 {1} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {6} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {3} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {3} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {3} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {3} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {TRUE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {4} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {4} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {1} \
   CONFIG.PCW_I2C0_GRP_INT_IO {EMIO} \
   CONFIG.PCW_I2C0_I2C0_IO {EMIO} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {133.333328} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {54} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1800.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {out} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {\
unassigned#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI\
Flash#Quad SPI\
Flash#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#UART\
0#UART\
0#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned} \
   CONFIG.PCW_MIO_TREE_SIGNALS {\
unassigned#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#rx#tx#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.089} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.075} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.085} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.092} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.025} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.014} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {9} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {9} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {EMIO} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {18} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {105.056} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {66.904} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {89.1715} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {113.63} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {98.503} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {68.5855} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {90.295} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {103.977} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP1 {1} \
   CONFIG.PCW_USE_S_AXI_HP2 {1} \
   CONFIG.PCW_USE_S_AXI_HP3 {1} \
 ] $ps

  # Create instance: r100, and set properties
  set r100 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 r100 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $r100

  # Create instance: r150, and set properties
  set r150 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 r150 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $r150

  # Create instance: r200, and set properties
  set r200 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 r200 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $r200

  # Create instance: roi, and set properties
  set roi [ create_bd_cell -type ip -vlnv xilinx.com:hls:roi256:1.0 roi ]

  # Create instance: sccb, and set properties
  set block_name sccb_bridge
  set block_cell_name sccb
  if { [catch {set sccb [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sccb eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: spec_fft, and set properties
  set spec_fft [ create_bd_cell -type ip -vlnv xilinx.com:hls:spectrum256_pl:1.0 spec_fft ]

  # Create instance: state_large, and set properties
  set state_large [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 state_large ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
   CONFIG.S00_HAS_DATA_FIFO {2} \
 ] $state_large

  # Create instance: state_small, and set properties
  set state_small [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 state_small ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
   CONFIG.S00_HAS_DATA_FIFO {2} \
 ] $state_small

  # Create instance: vdma, and set properties
  set vdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 vdma ]
  set_property -dict [ list \
   CONFIG.c_flush_on_fsync {1} \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_s2mm_data_width {64} \
   CONFIG.c_num_fstores {3} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {4096} \
   CONFIG.c_s2mm_max_burst_length {64} \
   CONFIG.c_use_fsync {1} \
 ] $vdma

  # Create instance: video, and set properties
  set block_name motion60_video_osd
  set block_cell_name video
  if { [catch {set video [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $video eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.H_ACTIVE {1920} \
   CONFIG.H_BP {148} \
   CONFIG.H_FP {88} \
   CONFIG.H_SYNC {44} \
   CONFIG.V_ACTIVE {1080} \
   CONFIG.V_BP {36} \
   CONFIG.V_FP {4} \
   CONFIG.V_SYNC {5} \
 ] $video

  # Create instance: zero, and set properties
  set zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $zero

  # Create interface connections
  connect_bd_intf_net -intf_net clip_dma_m_axi_input_mem [get_bd_intf_pins clip_dma/m_axi_input_mem] [get_bd_intf_pins mem/S06_AXI]
  connect_bd_intf_net -intf_net clip_dma_m_axi_output_mem [get_bd_intf_pins clip_dma/m_axi_output_mem] [get_bd_intf_pins mem/S07_AXI]
  connect_bd_intf_net -intf_net core_m_axis [get_bd_intf_pins core/m_axis] [get_bd_intf_pins pixels_cdc/S_AXIS]
  connect_bd_intf_net -intf_net csi_video_out [get_bd_intf_pins core/s_axis] [get_bd_intf_pins csi/video_out]
  connect_bd_intf_net -intf_net ctrl_intercon_M00_AXI [get_bd_intf_pins ctrl_intercon/M00_AXI] [get_bd_intf_pins vdma/S_AXI_LITE]
  connect_bd_intf_net -intf_net ctrl_intercon_M01_AXI [get_bd_intf_pins controls/S_AXI] [get_bd_intf_pins ctrl_intercon/M01_AXI]
  connect_bd_intf_net -intf_net ctrl_intercon_M02_AXI [get_bd_intf_pins csi/csirxss_s_axi] [get_bd_intf_pins ctrl_intercon/M02_AXI]
  connect_bd_intf_net -intf_net ctrl_intercon_M03_AXI [get_bd_intf_pins ctrl_intercon/M03_AXI] [get_bd_intf_pins display_dma/S_AXI_LITE]
  connect_bd_intf_net -intf_net ctrl_intercon_M04_AXI [get_bd_intf_pins ctrl_intercon/M04_AXI] [get_bd_intf_pins motion/s_axi_control]
  connect_bd_intf_net -intf_net ctrl_intercon_M05_AXI [get_bd_intf_pins ctrl_intercon/M05_AXI] [get_bd_intf_pins roi/s_axi_control]
  connect_bd_intf_net -intf_net ctrl_intercon_M06_AXI [get_bd_intf_pins ctrl_intercon/M06_AXI] [get_bd_intf_pins spec_fft/s_axi_control]
  connect_bd_intf_net -intf_net ctrl_intercon_M07_AXI [get_bd_intf_pins ctrl_intercon/M07_AXI] [get_bd_intf_pins overlay_cdc/S_AXI]
  connect_bd_intf_net -intf_net ctrl_intercon_M08_AXI [get_bd_intf_pins clip_dma/s_axi_control] [get_bd_intf_pins ctrl_intercon/M08_AXI]
  connect_bd_intf_net -intf_net ctrl_intercon_M09_AXI [get_bd_intf_pins ctrl_intercon/M09_AXI] [get_bd_intf_pins f/s_axi_control]
  connect_bd_intf_net -intf_net ctrl_intercon_M10_AXI [get_bd_intf_pins ctrl_intercon/M10_AXI] [get_bd_intf_pins roi_compose/S_AXI]
  connect_bd_intf_net -intf_net roi_compose_M_AXI [get_bd_intf_pins roi_compose/M_AXI] [get_bd_intf_pins mem/S09_AXI]
  connect_bd_intf_net -intf_net display_cdc_M_AXIS [get_bd_intf_pins display_cdc/M_AXIS] [get_bd_intf_pins video/S_AXIS]
  connect_bd_intf_net -intf_net display_dma_M_AXIS_MM2S [get_bd_intf_pins display_cdc/S_AXIS] [get_bd_intf_pins display_dma/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net display_dma_M_AXI_MM2S [get_bd_intf_pins display_dma/M_AXI_MM2S] [get_bd_intf_pins display_mem/S00_AXI]
  connect_bd_intf_net -intf_net display_mem_M00_AXI [get_bd_intf_pins display_mem/M00_AXI] [get_bd_intf_pins ps/S_AXI_HP1]
  connect_bd_intf_net -intf_net f_m_axi_phase_mem [get_bd_intf_pins f/m_axi_phase_mem] [get_bd_intf_pins mem/S08_AXI]
  connect_bd_intf_net -intf_net hdmi_TMDS [get_bd_intf_ports TMDS_0] [get_bd_intf_pins hdmi/TMDS]
  connect_bd_intf_net -intf_net mem_M00_AXI [get_bd_intf_pins mem/M00_AXI] [get_bd_intf_pins ps/S_AXI_HP0]
  connect_bd_intf_net -intf_net motion_m_axi_images [get_bd_intf_pins display_mem/S01_AXI] [get_bd_intf_pins motion/m_axi_images]
  connect_bd_intf_net -intf_net motion_m_axi_state0 [get_bd_intf_pins motion/m_axi_state0] [get_bd_intf_pins state_large/S00_AXI]
  connect_bd_intf_net -intf_net motion_m_axi_state1 [get_bd_intf_pins motion/m_axi_state1] [get_bd_intf_pins state_small/S00_AXI]
  connect_bd_intf_net -intf_net motion_m_axi_state2 [get_bd_intf_pins mem/S01_AXI] [get_bd_intf_pins motion/m_axi_state2]
  connect_bd_intf_net -intf_net overlay_cdc_M_AXI [get_bd_intf_pins overlay_cdc/M_AXI] [get_bd_intf_pins overlay_control/S_AXI]
  connect_bd_intf_net -intf_net pixels_cdc_M_AXIS [get_bd_intf_pins pixels_cdc/M_AXIS] [get_bd_intf_pins vdma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net ps_DDR [get_bd_intf_ports DDR_0] [get_bd_intf_pins ps/DDR]
  connect_bd_intf_net -intf_net ps_FIXED_IO [get_bd_intf_ports FIXED_IO_0] [get_bd_intf_pins ps/FIXED_IO]
  connect_bd_intf_net -intf_net ps_IIC_0 [get_bd_intf_pins ps/IIC_0] [get_bd_intf_pins sccb/PS]
  connect_bd_intf_net -intf_net ps_M_AXI_GP0 [get_bd_intf_pins ctrl_intercon/S00_AXI] [get_bd_intf_pins ps/M_AXI_GP0]
  connect_bd_intf_net -intf_net roi_m_axi_image_r [get_bd_intf_pins mem/S02_AXI] [get_bd_intf_pins roi/m_axi_image_r]
  connect_bd_intf_net -intf_net roi_m_axi_result [get_bd_intf_pins mem/S03_AXI] [get_bd_intf_pins roi/m_axi_result]
  connect_bd_intf_net -intf_net sccb_CAM [get_bd_intf_ports cam_i2c] [get_bd_intf_pins sccb/CAM]
  connect_bd_intf_net -intf_net spec_fft_m_axi_input_mem [get_bd_intf_pins mem/S04_AXI] [get_bd_intf_pins spec_fft/m_axi_input_mem]
  connect_bd_intf_net -intf_net spec_fft_m_axi_output_mem [get_bd_intf_pins mem/S05_AXI] [get_bd_intf_pins spec_fft/m_axi_output_mem]
  connect_bd_intf_net -intf_net state_large_M00_AXI [get_bd_intf_pins ps/S_AXI_HP2] [get_bd_intf_pins state_large/M00_AXI]
  connect_bd_intf_net -intf_net state_small_M00_AXI [get_bd_intf_pins ps/S_AXI_HP3] [get_bd_intf_pins state_small/M00_AXI]
  connect_bd_intf_net -intf_net vdma_M_AXI_S2MM [get_bd_intf_pins mem/S00_AXI] [get_bd_intf_pins vdma/M_AXI_S2MM]

  # Create port connections
  connect_bd_net -net controls_gpio_io_o [get_bd_pins controls/gpio_io_o] [get_bd_pins core/control]
  connect_bd_net -net core_status [get_bd_pins controls/gpio2_io_i] [get_bd_pins core/status]
  connect_bd_net -net csi_dlyctrl_rdy_out [get_bd_pins core/phy_ready_async] [get_bd_pins csi/dlyctrl_rdy_out]
  connect_bd_net -net csi_rxbyteclkhs [get_bd_pins core/phy_byteclk] [get_bd_pins csi/rxbyteclkhs]
  connect_bd_net -net hdmi_observe_frame_toggle [get_bd_pins hdmi_health/frame_toggle] [get_bd_pins hdmi_observe/frame_toggle]
  connect_bd_net -net hdmi_observe_selected_bars [get_bd_pins hdmi_health/selected_bars] [get_bd_pins hdmi_observe/selected_bars]
  connect_bd_net -net hdmi_observe_snapshot_valid [get_bd_pins hdmi_health/snapshot_valid] [get_bd_pins hdmi_observe/snapshot_valid]
  connect_bd_net -net hmi_uart_rx_1 [get_bd_ports hmi_uart_rx] [get_bd_pins ps/UART1_RX]
  connect_bd_net -net key0_n_1 [get_bd_ports key0_n] [get_bd_pins sccb/key0_n]
  connect_bd_net -net lp_concat_dout [get_bd_pins core/phy_lp_async] [get_bd_pins lp_concat/dout]
  connect_bd_net -net lp_n_0_Dout [get_bd_pins lp_concat/In2] [get_bd_pins lp_n_0/Dout]
  connect_bd_net -net lp_n_1_Dout [get_bd_pins lp_concat/In4] [get_bd_pins lp_n_1/Dout]
  connect_bd_net -net lp_p_0_Dout [get_bd_pins lp_concat/In3] [get_bd_pins lp_p_0/Dout]
  connect_bd_net -net lp_p_1_Dout [get_bd_pins lp_concat/In5] [get_bd_pins lp_p_1/Dout]
  connect_bd_net -net mipi_phy_if_clk_hs_n_0_1 [get_bd_ports dphy_clk_hs_n] [get_bd_pins csi/mipi_phy_if_clk_hs_n]
  connect_bd_net -net mipi_phy_if_clk_hs_p_0_1 [get_bd_ports dphy_clk_hs_p] [get_bd_pins csi/mipi_phy_if_clk_hs_p]
  connect_bd_net -net mipi_phy_if_clk_lp_n_0_1 [get_bd_ports dphy_clk_lp_n] [get_bd_pins csi/mipi_phy_if_clk_lp_n] [get_bd_pins lp_concat/In0]
  connect_bd_net -net mipi_phy_if_clk_lp_p_0_1 [get_bd_ports dphy_clk_lp_p] [get_bd_pins csi/mipi_phy_if_clk_lp_p] [get_bd_pins lp_concat/In1]
  connect_bd_net -net mipi_phy_if_data_hs_n_0_1 [get_bd_ports dphy_data_hs_n] [get_bd_pins csi/mipi_phy_if_data_hs_n]
  connect_bd_net -net mipi_phy_if_data_hs_p_0_1 [get_bd_ports dphy_data_hs_p] [get_bd_pins csi/mipi_phy_if_data_hs_p]
  connect_bd_net -net mipi_phy_if_data_lp_n_0_1 [get_bd_ports dphy_data_lp_n] [get_bd_pins csi/mipi_phy_if_data_lp_n] [get_bd_pins lp_n_0/Din] [get_bd_pins lp_n_1/Din]
  connect_bd_net -net mipi_phy_if_data_lp_p_0_1 [get_bd_ports dphy_data_lp_p] [get_bd_pins csi/mipi_phy_if_data_lp_p] [get_bd_pins lp_p_0/Din] [get_bd_pins lp_p_1/Din]
  connect_bd_net -net observe_de_lines [get_bd_pins hdmi_observe/de_lines] [get_bd_pins observe_pixel_vio/probe_in11]
  connect_bd_net -net observe_de_pixels [get_bd_pins hdmi_observe/de_pixels] [get_bd_pins observe_pixel_vio/probe_in6]
  connect_bd_net -net observe_de_widths [get_bd_pins hdmi_observe/de_widths] [get_bd_pins observe_pixel_vio/probe_in12]
  connect_bd_net -net observe_frame_id [get_bd_pins hdmi_observe/frame_id] [get_bd_pins observe_pixel_vio/probe_in2]
  connect_bd_net -net observe_frame_id_inverse [get_bd_pins hdmi_observe/frame_id_inverse] [get_bd_pins observe_pixel_vio/probe_in15]
  connect_bd_net -net observe_geometry [get_bd_pins hdmi_observe/geometry] [get_bd_pins observe_pixel_vio/probe_in14]
  connect_bd_net -net observe_health_fclk_count [get_bd_pins hdmi_health/fclk_count] [get_bd_pins observe_health_vio/probe_in3]
  connect_bd_net -net observe_health_health [get_bd_pins hdmi_health/health] [get_bd_pins observe_health_vio/probe_in1]
  connect_bd_net -net observe_health_heartbeat_age [get_bd_pins hdmi_health/heartbeat_age] [get_bd_pins observe_health_vio/probe_in2]
  connect_bd_net -net observe_health_probe_id [get_bd_pins hdmi_health/probe_id] [get_bd_pins observe_health_vio/probe_in0]
  connect_bd_net -net observe_hs_high [get_bd_pins hdmi_observe/hs_high] [get_bd_pins observe_pixel_vio/probe_in4]
  connect_bd_net -net observe_hs_rises [get_bd_pins hdmi_observe/hs_rises] [get_bd_pins observe_pixel_vio/probe_in9]
  connect_bd_net -net observe_nonzero_pixels [get_bd_pins hdmi_observe/nonzero_pixels] [get_bd_pins observe_pixel_vio/probe_in7]
  connect_bd_net -net observe_output_de [get_bd_pins hdmi/vid_pVDE] [get_bd_pins hdmi_observe/de]
  connect_bd_net -net observe_output_hs [get_bd_pins hdmi/vid_pHSync] [get_bd_pins hdmi_observe/hs]
  connect_bd_net -net observe_output_nonzero [get_bd_pins hdmi_observe/output_nonzero] [get_bd_pins observe_pixel_vio/probe_in13]
  connect_bd_net -net observe_output_rgb [get_bd_pins hdmi/vid_pData] [get_bd_pins hdmi_observe/rgb]
  connect_bd_net -net observe_output_vs [get_bd_pins hdmi/vid_pVSync] [get_bd_pins hdmi_observe/vs]
  connect_bd_net -net observe_period [get_bd_pins hdmi_observe/period] [get_bd_pins observe_pixel_vio/probe_in3]
  connect_bd_net -net observe_probe_id [get_bd_pins hdmi_observe/probe_id] [get_bd_pins observe_pixel_vio/probe_in0]
  connect_bd_net -net observe_request_bars [get_bd_pins hdmi_observe/request_bars] [get_bd_pins observe_pixel_vio/probe_out0]
  connect_bd_net -net observe_rgb_sum [get_bd_pins hdmi_observe/rgb_sum] [get_bd_pins observe_pixel_vio/probe_in8]
  connect_bd_net -net observe_status [get_bd_pins hdmi_observe/status] [get_bd_pins observe_pixel_vio/probe_in1]
  connect_bd_net -net observe_vs_high [get_bd_pins hdmi_observe/vs_high] [get_bd_pins observe_pixel_vio/probe_in5]
  connect_bd_net -net observe_vs_rises [get_bd_pins hdmi_observe/vs_rises] [get_bd_pins observe_pixel_vio/probe_in10]
  connect_bd_net -net one_dout [get_bd_pins one/dout] [get_bd_pins r100/dcm_locked] [get_bd_pins r150/dcm_locked] [get_bd_pins r200/dcm_locked]
  connect_bd_net -net overlay_control_commit [get_bd_pins overlay_control/commit] [get_bd_pins video/commit]
  connect_bd_net -net overlay_control_overlay_enable [get_bd_pins overlay_control/overlay_enable] [get_bd_pins video/overlay_enable]
  connect_bd_net -net overlay_control_signal_state [get_bd_pins overlay_control/signal_state] [get_bd_pins video/signal_state]
  connect_bd_net -net overlay_control_write_bin [get_bd_pins overlay_control/write_bin] [get_bd_pins video/write_bin]
  connect_bd_net -net overlay_control_write_dx [get_bd_pins overlay_control/write_dx] [get_bd_pins video/write_dx]
  connect_bd_net -net overlay_control_write_dy [get_bd_pins overlay_control/write_dy] [get_bd_pins video/write_dy]
  connect_bd_net -net overlay_control_write_valid [get_bd_pins overlay_control/write_valid] [get_bd_pins video/write_valid]
  connect_bd_net -net pixel_clock_clk_out1 [get_bd_pins display_cdc/m_axis_aclk] [get_bd_pins hdmi/PixelClk] [get_bd_pins hdmi_health/pixel_clk] [get_bd_pins hdmi_observe/pixel_clk] [get_bd_pins observe_pixel_vio/clk] [get_bd_pins overlay_cdc/m_axi_aclk] [get_bd_pins overlay_control/aclk] [get_bd_pins pixel_clock/pixel] [get_bd_pins pixel_reset/slowest_sync_clk] [get_bd_pins pixel_reset_guard/pixel_clk] [get_bd_pins video/pixel_clk]
  connect_bd_net -net pixel_clock_locked [get_bd_pins hdmi_health/locked] [get_bd_pins pixel_clock/locked] [get_bd_pins pixel_reset/dcm_locked] [get_bd_pins pixel_reset_guard/locked]
  connect_bd_net -net pixel_clock_serial [get_bd_pins hdmi/SerialClk] [get_bd_pins pixel_clock/serial]
  connect_bd_net -net pixel_guard_resetn [get_bd_pins hdmi/aRst_n] [get_bd_pins hdmi_health/pixel_resetn] [get_bd_pins hdmi_observe/resetn] [get_bd_pins overlay_cdc/m_axi_aresetn] [get_bd_pins overlay_control/aresetn] [get_bd_pins pixel_reset_guard/resetn] [get_bd_pins video/resetn]
  connect_bd_net -net pixel_reset_peripheral_aresetn [get_bd_pins pixel_reset/peripheral_aresetn] [get_bd_pins pixel_reset_guard/legacy_resetn]
  connect_bd_net -net ps_FCLK_CLK0 [get_bd_pins controls/s_axi_aclk] [get_bd_pins core/clk] [get_bd_pins csi/lite_aclk] [get_bd_pins csi/video_aclk] [get_bd_pins ctrl_intercon/ACLK] [get_bd_pins ctrl_intercon/M00_ACLK] [get_bd_pins ctrl_intercon/M01_ACLK] [get_bd_pins ctrl_intercon/M02_ACLK] [get_bd_pins ctrl_intercon/M03_ACLK] [get_bd_pins ctrl_intercon/M07_ACLK] [get_bd_pins ctrl_intercon/S00_ACLK] [get_bd_pins display_dma/s_axi_lite_aclk] [get_bd_pins hdmi_health/clk] [get_bd_pins observe_health_vio/clk] [get_bd_pins overlay_cdc/s_axi_aclk] [get_bd_pins pixel_clock/clk_in] [get_bd_pins pixels_cdc/s_axis_aclk] [get_bd_pins ps/FCLK_CLK0] [get_bd_pins ps/M_AXI_GP0_ACLK] [get_bd_pins r100/slowest_sync_clk] [get_bd_pins sccb/button_clk] [get_bd_pins vdma/s_axi_lite_aclk]
  connect_bd_net -net ps_FCLK_CLK1 [get_bd_pins clip_dma/ap_clk] [get_bd_pins ctrl_intercon/M04_ACLK] [get_bd_pins ctrl_intercon/M05_ACLK] [get_bd_pins ctrl_intercon/M06_ACLK] [get_bd_pins ctrl_intercon/M08_ACLK] [get_bd_pins ctrl_intercon/M09_ACLK] [get_bd_pins display_cdc/s_axis_aclk] [get_bd_pins display_dma/m_axi_mm2s_aclk] [get_bd_pins display_dma/m_axis_mm2s_aclk] [get_bd_pins display_mem/ACLK] [get_bd_pins display_mem/M00_ACLK] [get_bd_pins display_mem/S00_ACLK] [get_bd_pins display_mem/S01_ACLK] [get_bd_pins f/ap_clk] [get_bd_pins mem/ACLK] [get_bd_pins mem/M00_ACLK] [get_bd_pins mem/S00_ACLK] [get_bd_pins mem/S01_ACLK] [get_bd_pins mem/S02_ACLK] [get_bd_pins mem/S03_ACLK] [get_bd_pins mem/S04_ACLK] [get_bd_pins mem/S05_ACLK] [get_bd_pins mem/S06_ACLK] [get_bd_pins mem/S07_ACLK] [get_bd_pins mem/S08_ACLK] [get_bd_pins motion/ap_clk] [get_bd_pins pixels_cdc/m_axis_aclk] [get_bd_pins ps/FCLK_CLK1] [get_bd_pins ps/S_AXI_HP0_ACLK] [get_bd_pins ps/S_AXI_HP1_ACLK] [get_bd_pins ps/S_AXI_HP2_ACLK] [get_bd_pins ps/S_AXI_HP3_ACLK] [get_bd_pins r150/slowest_sync_clk] [get_bd_pins roi/ap_clk] [get_bd_pins spec_fft/ap_clk] [get_bd_pins state_large/ACLK] [get_bd_pins state_large/M00_ACLK] [get_bd_pins state_large/S00_ACLK] [get_bd_pins state_small/ACLK] [get_bd_pins state_small/M00_ACLK] [get_bd_pins state_small/S00_ACLK] [get_bd_pins vdma/m_axi_s2mm_aclk] [get_bd_pins vdma/s_axis_s2mm_aclk]
  connect_bd_net -net ps_FCLK_CLK2 [get_bd_pins csi/dphy_clk_200M] [get_bd_pins ps/FCLK_CLK2] [get_bd_pins r200/slowest_sync_clk]
  connect_bd_net -net ps_FCLK_RESET0_N [get_bd_pins pixel_reset/ext_reset_in] [get_bd_pins pixel_reset_guard/reset0_n] [get_bd_pins ps/FCLK_RESET0_N] [get_bd_pins r100/ext_reset_in] [get_bd_pins r150/ext_reset_in] [get_bd_pins r200/ext_reset_in]
  connect_bd_net -net ps_GPIO_O [get_bd_pins ps/GPIO_O] [get_bd_pins sccb/bb_data]
  connect_bd_net -net ps_GPIO_T [get_bd_pins ps/GPIO_T] [get_bd_pins sccb/bb_tri]
  connect_bd_net -net ps_UART1_TX [get_bd_ports hmi_uart_tx] [get_bd_pins ps/UART1_TX]
  connect_bd_net -net r100_interconnect_aresetn [get_bd_pins ctrl_intercon/ARESETN] [get_bd_pins r100/interconnect_aresetn]
  connect_bd_net -net r100_peripheral_aresetn [get_bd_pins controls/s_axi_aresetn] [get_bd_pins core/resetn] [get_bd_pins csi/lite_aresetn] [get_bd_pins csi/video_aresetn] [get_bd_pins ctrl_intercon/M00_ARESETN] [get_bd_pins ctrl_intercon/M01_ARESETN] [get_bd_pins ctrl_intercon/M02_ARESETN] [get_bd_pins ctrl_intercon/M03_ARESETN] [get_bd_pins ctrl_intercon/M07_ARESETN] [get_bd_pins ctrl_intercon/S00_ARESETN] [get_bd_pins display_dma/axi_resetn] [get_bd_pins hdmi_health/resetn] [get_bd_pins overlay_cdc/s_axi_aresetn] [get_bd_pins pixel_clock/resetn] [get_bd_pins pixels_cdc/s_axis_aresetn] [get_bd_pins r100/peripheral_aresetn] [get_bd_pins vdma/axi_resetn]
  connect_bd_net -net r150_interconnect_aresetn [get_bd_pins display_mem/ARESETN] [get_bd_pins mem/ARESETN] [get_bd_pins r150/interconnect_aresetn] [get_bd_pins state_large/ARESETN] [get_bd_pins state_small/ARESETN]
  connect_bd_net -net r150_peripheral_aresetn [get_bd_pins clip_dma/ap_rst_n] [get_bd_pins ctrl_intercon/M04_ARESETN] [get_bd_pins ctrl_intercon/M05_ARESETN] [get_bd_pins ctrl_intercon/M06_ARESETN] [get_bd_pins ctrl_intercon/M08_ARESETN] [get_bd_pins ctrl_intercon/M09_ARESETN] [get_bd_pins display_cdc/s_axis_aresetn] [get_bd_pins display_mem/M00_ARESETN] [get_bd_pins display_mem/S00_ARESETN] [get_bd_pins display_mem/S01_ARESETN] [get_bd_pins f/ap_rst_n] [get_bd_pins mem/M00_ARESETN] [get_bd_pins mem/S00_ARESETN] [get_bd_pins mem/S01_ARESETN] [get_bd_pins mem/S02_ARESETN] [get_bd_pins mem/S03_ARESETN] [get_bd_pins mem/S04_ARESETN] [get_bd_pins mem/S05_ARESETN] [get_bd_pins mem/S06_ARESETN] [get_bd_pins mem/S07_ARESETN] [get_bd_pins mem/S08_ARESETN] [get_bd_pins motion/ap_rst_n] [get_bd_pins r150/peripheral_aresetn] [get_bd_pins roi/ap_rst_n] [get_bd_pins spec_fft/ap_rst_n] [get_bd_pins state_large/M00_ARESETN] [get_bd_pins state_large/S00_ARESETN] [get_bd_pins state_small/M00_ARESETN] [get_bd_pins state_small/S00_ARESETN]
  connect_bd_net -net sccb_levels [get_bd_pins ps/GPIO_I] [get_bd_pins sccb/levels]
  connect_bd_net -net vdma_s2mm_introut [get_bd_pins ps/IRQ_F2P] [get_bd_pins vdma/s2mm_introut]
  connect_bd_net -net video_commit_accepted [get_bd_pins overlay_control/commit_accepted] [get_bd_pins video/commit_accepted]
  connect_bd_net -net video_commit_done [get_bd_pins overlay_control/commit_done] [get_bd_pins video/commit_done]
  connect_bd_net -net video_commit_rejected [get_bd_pins overlay_control/commit_rejected] [get_bd_pins video/commit_rejected]
  connect_bd_net -net video_de [get_bd_pins hdmi_observe/prod_de] [get_bd_pins video/de]
  connect_bd_net -net video_display_frames [get_bd_pins overlay_control/display_frames] [get_bd_pins video/display_frames]
  connect_bd_net -net video_framing_errors [get_bd_pins overlay_control/framing_errors] [get_bd_pins video/framing_errors]
  connect_bd_net -net video_hsync [get_bd_pins hdmi_observe/prod_hs] [get_bd_pins video/hsync]
  connect_bd_net -net video_rgb [get_bd_pins hdmi_observe/prod_rgb] [get_bd_pins video/rgb]
  connect_bd_net -net video_underflows [get_bd_pins overlay_control/underflows] [get_bd_pins video/underflows]
  connect_bd_net -net video_vsync [get_bd_pins hdmi_observe/prod_vs] [get_bd_pins video/vsync]
  connect_bd_net -net video_write_ready [get_bd_pins overlay_control/write_ready] [get_bd_pins video/write_ready]
  connect_bd_net -net zero_dout [get_bd_pins pixel_reset/aux_reset_in] [get_bd_pins pixel_reset/mb_debug_sys_rst] [get_bd_pins r100/aux_reset_in] [get_bd_pins r100/mb_debug_sys_rst] [get_bd_pins r150/aux_reset_in] [get_bd_pins r150/mb_debug_sys_rst] [get_bd_pins r200/aux_reset_in] [get_bd_pins r200/mb_debug_sys_rst] [get_bd_pins zero/dout]

  # The new control endpoint and DDR master share FCLK1 (150 MHz). The control
  # interconnect supplies the existing GP0-to-FCLK1 clock conversion.
  connect_bd_net [get_bd_pins ps/FCLK_CLK1] [get_bd_pins ctrl_intercon/M10_ACLK] [get_bd_pins mem/S09_ACLK] [get_bd_pins roi_compose/aclk]
  connect_bd_net [get_bd_pins r150/peripheral_aresetn] [get_bd_pins ctrl_intercon/M10_ARESETN] [get_bd_pins mem/S09_ARESETN] [get_bd_pins roi_compose/aresetn]

  # Create address segments. 0x43c50000 belongs to the offline temporal IP.
  assign_bd_address -offset 0x43C60000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs roi_compose/S_AXI/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces roi_compose/M_AXI] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces clip_dma/Data_m_axi_input_mem] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces clip_dma/Data_m_axi_output_mem] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces display_dma/Data_MM2S] [get_bd_addr_segs ps/S_AXI_HP1/HP1_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces f/Data_m_axi_phase_mem] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces motion/Data_m_axi_state2] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces motion/Data_m_axi_images] [get_bd_addr_segs ps/S_AXI_HP1/HP1_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces motion/Data_m_axi_state0] [get_bd_addr_segs ps/S_AXI_HP2/HP2_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces motion/Data_m_axi_state1] [get_bd_addr_segs ps/S_AXI_HP3/HP3_DDR_LOWOCM] -force
  assign_bd_address -offset 0x43C40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs clip_dma/s_axi_control/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs controls/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs csi/csirxss_s_axi/Reg] -force
  assign_bd_address -offset 0x43100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs display_dma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x43C50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs f/s_axi_control/Reg] -force
  assign_bd_address -offset 0x43C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs motion/s_axi_control/Reg] -force
  assign_bd_address -offset 0x43C30000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs overlay_control/S_AXI/reg0] -force
  assign_bd_address -offset 0x43C10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs roi/s_axi_control/Reg] -force
  assign_bd_address -offset 0x43C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs spec_fft/s_axi_control/Reg] -force
  assign_bd_address -offset 0x43000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps/Data] [get_bd_addr_segs vdma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces roi/Data_m_axi_image_r] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces roi/Data_m_axi_result] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces spec_fft/Data_m_axi_input_mem] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces spec_fft/Data_m_axi_output_mem] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces vdma/Data_S2MM] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


