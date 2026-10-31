source [file join [file dirname [info script]] hmi_helpers.tcl]
if {[catch {
 connect -url tcp:127.0.0.1:3121;owned_target;apu
 same 0x00ff2000 0x484d4931;hchecked 14 0 stopped_for_uart_diagnosis
 if {[rd 0x00ff000c] ni {1 3}} {error "Require stopped acquisition"}
 set control [rd 0xe0001000]
 puts "HMI_UART_CONTROL_BEFORE [format 0x%08x $control]"
 puts "HMI_UART_TIMEOUT [rd 0xe000101c] IRQ_MASK [rd 0xe0001010]"
 puts "HMI_UART_RX_TRIGGER [rd 0xe0001020]"
 # Match AMD XUartPs_SetRecvTimeout: arm TORST without resetting RX/TX.
 mwr 0xe0001020 16
 mwr 0xe000101c 8
 mwr 0xe0001000 [expr {$control|0x40}]
 puts "HMI_UART_TIMEOUT_AFTER [rd 0xe000101c] RX_TRIGGER_AFTER [rd 0xe0001020]"
 hwait 25 1 3000;hwait 24 0 3000
 if {[hnumber page0.mode.val]!=2} {error "Mode readback mismatch"}
 if {[hnumber page0.alpha.val]!=12} {error "Alpha readback mismatch"}
 set reconnects [hword 33]
 after 2000
 hchecked 25 1 connected;hchecked 33 $reconnects no_false_reconnect
 puts HMI_RX_TIMEOUT_HARDWARE_FIX_VERIFIED
 disconnect
} message options]} {puts stderr $message;catch {disconnect};exit 1}
exit 0
