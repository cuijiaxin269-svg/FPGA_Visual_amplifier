// Timing-aligned composition wrapper. The proven base video module is unchanged.
// Both raster counters share clock/reset/parameters; registered coordinates align
// with base RGB. Overlay delays RGB and every sync signal by the same three clocks.
module motion60_video_osd #(
 parameter WIDTH=1280,HEIGHT=800,H_ACTIVE=1600,V_ACTIVE=900,
 parameter H_FP=24,H_SYNC=80,H_BP=96,V_FP=1,V_SYNC=3,V_BP=96
)(
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 pixel_clk CLK", X_INTERFACE_PARAMETER="ASSOCIATED_BUSIF S_AXIS, ASSOCIATED_RESET resetn" *) input wire pixel_clk,
 (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 resetn RST", X_INTERFACE_PARAMETER="POLARITY ACTIVE_LOW" *) input wire resetn,
 (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TDATA" *) input wire [15:0] s_axis_tdata,
 (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TVALID" *) input wire s_axis_tvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TREADY" *) output wire s_axis_tready,
 (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TUSER" *) input wire s_axis_tuser,
 (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TLAST" *) input wire s_axis_tlast,
 output wire [23:0] rgb,output wire hsync,vsync,de,
 output wire [31:0] display_frames,underflows,framing_errors,
 input wire write_valid,input wire [7:0] write_bin,write_dx,write_dy,
 output wire write_ready,input wire commit,overlay_enable,
 input wire [1:0] signal_state,
 output wire commit_accepted,commit_rejected,commit_done
);
 localparam H_TOTAL=H_ACTIVE+H_FP+H_SYNC+H_BP;
 localparam V_TOTAL=V_ACTIVE+V_FP+V_SYNC+V_BP;
 wire [23:0] base_rgb;wire base_hs,base_vs,base_de;
 reg [11:0] scan_x,scan_y,aligned_x,aligned_y;
 always @(posedge pixel_clk)begin
  if(!resetn)begin scan_x<=0;scan_y<=0;aligned_x<=0;aligned_y<=0;end
  else begin
   aligned_x<=scan_x;aligned_y<=scan_y;
   if(scan_x==H_TOTAL-1)begin
    scan_x<=0;scan_y<=scan_y==V_TOTAL-1?0:scan_y+1;
   end else scan_x<=scan_x+1;
  end
 end
 motion60_video #(.WIDTH(WIDTH),.HEIGHT(HEIGHT),.H_ACTIVE(H_ACTIVE),.V_ACTIVE(V_ACTIVE),
  .H_FP(H_FP),.H_SYNC(H_SYNC),.H_BP(H_BP),.V_FP(V_FP),.V_SYNC(V_SYNC),.V_BP(V_BP)) base(
  .pixel_clk(pixel_clk),.resetn(resetn),.s_axis_tdata(s_axis_tdata),
  .s_axis_tvalid(s_axis_tvalid),.s_axis_tready(s_axis_tready),
  .s_axis_tuser(s_axis_tuser),.s_axis_tlast(s_axis_tlast),
  .rgb(base_rgb),.hsync(base_hs),.vsync(base_vs),.de(base_de),
  .display_frames(display_frames),.underflows(underflows),.framing_errors(framing_errors));
 motion60_spectrum_overlay overlay(
  .pixel_clk(pixel_clk),.resetn(resetn),.x(aligned_x),.y(aligned_y),
  .rgb_in(base_rgb),.hsync_in(base_hs),.vsync_in(base_vs),.de_in(base_de),
  .write_valid(write_valid),.write_bin(write_bin),.write_dx(write_dx),.write_dy(write_dy),
  .write_ready(write_ready),.commit(commit),.overlay_enable(overlay_enable),
  .signal_state(signal_state),.commit_accepted(commit_accepted),
  .commit_rejected(commit_rejected),.commit_done(commit_done),
  .rgb_out(rgb),.hsync_out(hsync),.vsync_out(vsync),.de_out(de));
endmodule
