# Only the asynchronous assertion pins of this exact synchronizer are excepted.
# New exceptions do not cover Q->D release paths; existing vendor exceptions remain unchanged.
# Exact sixteen-cell/CLR checks are enforced by audit_resetguard_design.tcl before implementation and at routed signoff.
set reset_guard_ffs [get_cells -hier -filter {REF_NAME == FDCE && NAME =~ *pixel_reset_guard*/release_pipeline_reg*}]
set reset_guard_clrs [get_pins -of_objects $reset_guard_ffs -filter {REF_PIN_NAME == CLR}]
set_false_path -to $reset_guard_clrs
