# External MIPI byte clock and PS FCLK0 have no deterministic phase relation.
# This single-bit /256 toggle enters a two-stage ASYNC_REG synchronizer.
# Exempt only the first stage D pin. Stage0 Q -> stage1 D remains timed.
set_false_path -to [get_pins {capture_i/core/inst/toggle_sync_reg[0]/D}]
