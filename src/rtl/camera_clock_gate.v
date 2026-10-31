// Keep the connector high impedance until software explicitly enables XVCLK.
module camera_clock_gate(input wire clk24, resetn, enable, output wire cam_mclk);
 (* ASYNC_REG="TRUE" *) reg [1:0] en;
 always @(posedge clk24 or negedge resetn)
  if(!resetn) en<=0; else en<={en[0],enable};
 OBUFT outbuf(.I(clk24),.T(!en[1]),.O(cam_mclk));
endmodule
