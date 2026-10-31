# Runs after smoke; leaves stopped for human touch checks. Real screen TX path.
source [file join [file dirname [info script]] hmi_helpers.tcl]
proc hraw {value} {
 set hex {};foreach char [split $value {}] {scan $char %c byte;lappend hex [format %02X $byte]}
 hnative "printh [join $hex { }]"
}
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 same 0x00ff2000 0x484d4931;hstandby
 # Exercise 0xff inside the four-byte number payload and protect an unsubmitted draft.
 hnative "page0.exposure.val=255"
 after 2200
 if {[hnumber page0.exposure.val]!=255} {error "Normal polling overwrote exposure draft"}
 hchecked 7 320 draft_did_not_change_device_target
 hnative "page0.exposure.val=320"
 puts HMI_BINARY_FF_AND_UNSUBMITTED_DRAFT_PASSED
 foreach command {{ALPHA -1} {ALPHA 51} {VIEW 3} {EXPOSURE 0} {EXPOSURE 899} {START 1}} {
  set before [hword 27];hraw "$command\r\n";hwait 27 [expr {$before+1}] 3000
 }
 hchecked 5 2 invalid_view_kept;hchecked 6 50 invalid_alpha_kept;hchecked 7 320 invalid_exposure_kept
 hemit "VIEW 2";hemit "ALPHA 50";hexposure 320;hstandby
 # A complete command split over two native instructions. The short gap is
 # intentional; any intervening binary response must not execute a fragment.
 set before [hword 26]
 hraw "ALPHA ";hraw "31\r\n"
 hwait 26 [expr {$before+1}] 3000;hchecked 6 31 fragmented_command
 hemit "ALPHA 50"
 # Large raw strings cross the 96-byte parser line boundary. Retry only if a
 # scheduled native reply interrupts the deliberately incomplete text line.
 set overlong [hword 30]
 for {set attempt 0} {$attempt<3 && [hword 30]==$overlong} {incr attempt} {
  hnative "prints \"[string repeat A 80]\",0"
  hnative "prints \"[string repeat B 80]\",0"
  hraw "\r\n";after 200
 }
 if {[hword 30]<=$overlong} {error "Did not exercise line overflow"}
 hemit "ALPHA 50";hchecked 6 50 recovered_after_overlong
 # Lone LF is invalid; discard through a real CRLF before a valid command.
 set corrupt [hword 29];set before [hword 26]
 hraw "ALPHA 12\n\r\n"
 hwait 29 [expr {$corrupt+1}] 3000;hchecked 26 $before no_lone_lf_command
 hemit "ALPHA 50";hchecked 6 50 recovered_after_bad_ending
 foreach index {36 37 40 47 48} {hchecked $index 0 hardware_errors}
 puts HMI_PROTOCOL_EDGES_BOARD_PASSED
 disconnect
} message options]} {puts stderr $message;puts stderr [dict get $options -errorinfo];catch {disconnect};exit 1}
exit 0
