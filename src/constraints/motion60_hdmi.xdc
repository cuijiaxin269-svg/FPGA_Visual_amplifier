# Generated interface prefix can vary; Tcl preflight rejects ambiguity.
set_property PACKAGE_PIN AG17 [get_ports TMDS_*_clk_p]
set_property PACKAGE_PIN AK13 [get_ports -regexp {^TMDS_[0-9]+_data_p\[0\]$}]
set_property PACKAGE_PIN AJ15 [get_ports -regexp {^TMDS_[0-9]+_data_p\[1\]$}]
set_property PACKAGE_PIN AH14 [get_ports -regexp {^TMDS_[0-9]+_data_p\[2\]$}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_*_clk_p TMDS_*_clk_n TMDS_*_data_p[*] TMDS_*_data_n[*]}]
