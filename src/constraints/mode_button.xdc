# Dock schematic p7: KEY0/SW5 -> B11_L21_P; core schematic p4: Y22.
set_property -dict {PACKAGE_PIN Y22 IOSTANDARD LVCMOS33} [get_ports key0_n]
# Only the asynchronous pad-to-first-flop path is excluded. The second stage
# and the path into PS GPIO remain timed. Unique-cell checks are performed in
# the implementation Tcl hook; XDC deliberately contains only supported commands.
set button_meta [get_cells -hier -filter {NAME =~ */sccb/inst/key_meta_reg}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {NAME =~ */sccb/inst/key_meta_reg || NAME =~ */sccb/inst/key_sync_reg}]
set_false_path -from [get_ports key0_n] -to [get_pins -of_objects $button_meta -filter {REF_PIN_NAME == D}]
