# JP1 has 15 signal contacts; 16/17 are mechanical solder tabs.
# BANK13 nominal 3.3V and module SCCB compatibility inferred from schematics/ELF2.
# This module uses its own oscillator: leave MCLK high impedance in software.
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVDS} [get_ports dphy_clk_hs_p]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVDS} [get_ports dphy_clk_hs_n]
create_clock -name mipi_hs_clk -period 2.500 [get_ports dphy_clk_hs_p]
# Candidate D-PHY data eye: UI=1.25ns, setup/hold=0.15UI. Board skew not yet measured.
set_input_delay -clock mipi_hs_clk -min 0.1875 [get_ports {dphy_data_hs_p[*] dphy_data_hs_n[*]}]
set_input_delay -clock mipi_hs_clk -max 1.0625 [get_ports {dphy_data_hs_p[*] dphy_data_hs_n[*]}]
set_input_delay -clock mipi_hs_clk -clock_fall -min -add_delay 0.1875 [get_ports {dphy_data_hs_p[*] dphy_data_hs_n[*]}]
set_input_delay -clock mipi_hs_clk -clock_fall -max -add_delay 1.0625 [get_ports {dphy_data_hs_p[*] dphy_data_hs_n[*]}]
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
set_property -dict {PACKAGE_PIN T30 IOSTANDARD LVCMOS33} [get_ports cam_i2c_scl_io]
set_property -dict {PACKAGE_PIN U30 IOSTANDARD LVCMOS33} [get_ports cam_i2c_sda_io]
set_property -dict {PACKAGE_PIN R30 IOSTANDARD LVCMOS33} [get_ports cam_mclk]
# Do not import vendor hierarchy-based false paths. Review CDC after implementation.
# This is the first stage of our explicit two-flop XVCLK-enable synchronizer.
set_false_path -to [get_pins -hier -filter {NAME =~ */clock_gate/inst/en_reg[0]/D}]
