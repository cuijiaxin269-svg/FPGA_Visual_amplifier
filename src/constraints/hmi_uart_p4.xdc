# OS-ZYNQ7100 Dock Lite: serial HMI on expansion connector P4.
# Prepared offline on 2026-10-28. Not added to any active Vivado project.
# Add only after creating the matching top-level UART ports:
#   output hmi_uart_tx; input hmi_uart_rx;
# Pin constraints alone do not instantiate or connect a UART controller.
#
# Board TX: P4.3 -> B10_L10_N -> AH12 -> HMI RX
# Board RX: P4.4 -> B10_L10_P -> AG12 <- HMI TX
# Ground:   P4.1 -> GND              -> HMI GND (no FPGA port)
# Use the P/N pins as independent single-ended signals, not a differential pair.
#
# Schematic references:
#   OS-ZYNQ7100_Dock_Lite schematic: sheets 7 (P4), 3 (CH340C).
#   OS-ZYNQ7100_REV_A core schematic: sheets 4 (balls), 2/9 (VCCIO_10).
# Bank 10 is supplied by VCC_ADJ1, nominally 3.3 V with the shown resistors.
# LVCMOS33 assumes that the board's Bank 10 supply has not been modified.
# Screen UART signals must be compatible with 3.3 V logic.
# Do not connect 5 V UART outputs or RS-232 signals directly to these pins.
# Screen power is separate from its UART logic level and is not assigned here.
#
# Existing PS UART0 on MIO14/15 is the CH340C path and remains separate.
# AH12/AG12 were not assigned in the inspected v13roi source constraints.
# Controller selection, RX CDC/timing constraints, baud and screen protocol
# are deferred until integration; this file has not been implemented/tested.

set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS33} [get_ports {hmi_uart_tx}]
set_property -dict {PACKAGE_PIN AG12 IOSTANDARD LVCMOS33} [get_ports {hmi_uart_rx}]
