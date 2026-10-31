source [file join [file dirname [info script]] hmi_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 loadhw -hw [file normalize [file join $tool_root .. .. build candidate capture.xsa]]
 same 0x00ff2000 0x484d4931;hwait 25 1 5000;hwait 24 0 5000
 hstandby
 hemit "VIEW 0";hwait 16 1 5000
 hexposure 1
 hnative "page0.alpha.val=0";hnative "page0.hgain.val=0"
 hemit "ALPHA 0";hwait 17 1 5000
 hstart;hchecked 8 0 raw_view;hchecked 10 1 exposure_readback
 hemit "VIEW 2";hwait 19 4 30000;hwait 16 3 5000;hwait 17 3 5000
 hchecked 8 2 panel_view;hchecked 52 1 panel_visible
 foreach {value bits} {0 0x00000000 12 0x41400000 30 0x41f00000 31 0x41f80000 50 0x42480000} {halpha $value $bits}
 set revision [hword 55];set frames [hword 49]
 foreach view {1 2 1 2} {
  hemit "VIEW $view";hwait 16 3 5000;hchecked 8 $view view_actual
  hchecked 55 $revision no_camera_restart;hchecked 52 [expr {$view==2}] panel_flag
  if {[hword 49]<$frames} {error "Algorithm counter reset during panel-only switch"}
 }
 hemit "EXPOSURE 320";hwait 18 6 5000;hchecked 7 1 busy_exposure_kept
 foreach value {320 898 320} {
  hstandby;hexposure $value;hstart;hchecked 10 $value exposure_applied
  hchecked 56 $value camera_register_readback
 }
 hchecked 36 0 rx_overflow;hchecked 37 0 rx_errors;hchecked 47 0 capture_error;hchecked 48 0 algorithm_error
 foreach {property expected} {page0.vstatus.txt APPLIED page0.astatus.txt APPLIED page0.estatus.txt APPLIED page0.rstatus.txt RUNNING} {
  if {[htext $property] ne $expected} {error "Screen status mismatch: $property"}
 }
 puts HMI_FIVE_COMMANDS_BOARD_READBACK_PASSED_REQUIRES_VISUAL_TOUCH_ACCEPTANCE
 disconnect
} message options]} {puts stderr $message;puts stderr [dict get $options -errorinfo];catch {disconnect};exit 1}
exit 0
