// Single MMCM: avoid cascading fractional pixel-clock and serializer MMCMs.
module hdmi_1080_clock #(parameter SERIAL_DIVIDE=1)(input wire clk_in, resetn,
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 pixel CLK", X_INTERFACE_PARAMETER="FREQ_HZ 74250000" *) output wire pixel,
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 serial CLK", X_INTERFACE_PARAMETER="FREQ_HZ 371250000" *) output wire serial,
 output wire locked);
 wire fast, fb_out, fb_in;
 MMCME2_BASE #(.BANDWIDTH("OPTIMIZED"), .CLKIN1_PERIOD(10.0),
   .DIVCLK_DIVIDE(5), .CLKFBOUT_MULT_F(37.125),
   .CLKOUT0_DIVIDE_F(1.0*SERIAL_DIVIDE)) mmcm (
   .CLKIN1(clk_in), .RST(!resetn), .PWRDWN(1'b0),
   .CLKFBIN(fb_in), .CLKFBOUT(fb_out), .CLKOUT0(fast), .LOCKED(locked));
 BUFIO serial_buffer(.I(fast), .O(serial));
 BUFR #(.BUFR_DIVIDE("5"), .SIM_DEVICE("7SERIES")) pixel_buffer
   (.I(fast), .O(pixel), .CE(1'b1), .CLR(!locked));
 BUFR #(.BUFR_DIVIDE("1"), .SIM_DEVICE("7SERIES")) feedback_buffer
   (.I(fb_out), .O(fb_in), .CE(1'b1), .CLR(1'b0));
endmodule
