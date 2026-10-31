# Independent 400Mbps diagnostic: retain the high-performance HS input settings.
set_property IBUF_LOW_PWR FALSE [get_ports {dphy_clk_hs_p dphy_clk_hs_n dphy_data_hs_p[*] dphy_data_hs_n[*]}]
set_property HIGH_PERFORMANCE_MODE TRUE [get_cells -hier -filter {REF_NAME == IDELAYE2}]
