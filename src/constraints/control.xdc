# SCCB bring-up on the documented nominal 3.3V BANK13 connection.
# No MIPI or MCLK ports: the Renheng module uses its own oscillator.
set_property -dict {PACKAGE_PIN T30 IOSTANDARD LVCMOS33} [get_ports cam_i2c_scl_io]
set_property -dict {PACKAGE_PIN U30 IOSTANDARD LVCMOS33} [get_ports cam_i2c_sda_io]
