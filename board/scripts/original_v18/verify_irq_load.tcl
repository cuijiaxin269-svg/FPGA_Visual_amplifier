source [file join [file dirname [info script]] hmi_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 same 0x00ff2000 0x484d4931;same 0xe0001020 1
 set before [hword 39];after 2000;set delta [expr {[hword 39]-$before}]
 puts "HMI_IRQ_TWO_SECONDS_BEFORE $delta"
 # RX trigger=1 already handles every short packet. Mask only idle timeout.
 mwr 0xe000100c 0x100
 same 0xe0001010 0xe5
 set before [hword 39];after 2000;set delta [expr {[hword 39]-$before}]
 puts "HMI_IRQ_TWO_SECONDS_AFTER $delta"
 if {$delta>200} {error "Unexpected interrupt load persists"}
 if {[hnumber page0.alpha.val]!=50} {error "Numeric reply failed with timeout IRQ masked"}
 hchecked 25 1 online;hchecked 36 0 overflow;hchecked 37 0 uart_error
 puts HMI_IRQ_LOAD_FIX_VERIFIED
 disconnect
} message options]} {puts stderr $message;catch {disconnect};exit 1}
exit 0
