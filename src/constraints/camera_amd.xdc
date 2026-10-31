# Board pins for the official runtime-calibrated PHY. Its generated constraints
# cover core clocks/calibration; serial sampling needs runtime calibration evidence.
# The failed fixed-tap Digilent input timing model is retained in camera.xdc.
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVDS} [get_ports dphy_clk_hs_p]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVDS} [get_ports dphy_clk_hs_n]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVDS} [get_ports {dphy_data_hs_p[0]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVDS} [get_ports {dphy_data_hs_n[0]}]
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVDS} [get_ports {dphy_data_hs_p[1]}]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVDS} [get_ports {dphy_data_hs_n[1]}]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD HSUL_12} [get_ports dphy_clk_lp_p]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD HSUL_12} [get_ports dphy_clk_lp_n]
set_property -dict {PACKAGE_PIN D16 IOSTANDARD HSUL_12} [get_ports {dphy_data_lp_p[0]}]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD HSUL_12} [get_ports {dphy_data_lp_n[0]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD HSUL_12} [get_ports {dphy_data_lp_p[1]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD HSUL_12} [get_ports {dphy_data_lp_n[1]}]
set_property INTERNAL_VREF 0.6 [get_iobanks 35]
# Board has fixed 150-ohm cross-pair termination (R20/R21/R22). Do not add the
# official AUTO default 100-ohm parallel load: LP transitions must remain visible.
# Read LATE so this board adaptation overrides the generated IP's DIFF_TERM TRUE.
set_property DIFF_TERM FALSE [get_ports {dphy_clk_hs_p dphy_clk_hs_n dphy_data_hs_p[*] dphy_data_hs_n[*]}]
set_property -dict {PACKAGE_PIN T30 IOSTANDARD LVCMOS33} [get_ports cam_i2c_scl_io]
set_property -dict {PACKAGE_PIN U30 IOSTANDARD LVCMOS33} [get_ports cam_i2c_sda_io]
