// Camera-independent exercise of the exact full-system raster and overlay.
module hdmi_diagnostic_motion_ui #(
 parameter HA=1920,VA=1080,HT=2200,VT=1125,
 parameter HS0=2008,HS1=2052,VS0=1084,VS1=1089
)(input wire clk,resetn,
 output wire [23:0] rgb,output wire hs,vs,de,
 output wire [31:0] frame_count);
 reg [7:0] init_bin;
 always @(posedge clk) begin
  if(!resetn) init_bin<=0;
  else if(init_bin<130) init_bin<=init_bin+1'b1;
 end
 motion60_video_osd #(.WIDTH(1280),.HEIGHT(800),
  .H_ACTIVE(HA),.V_ACTIVE(VA),.H_FP(HS0-HA),.H_SYNC(HS1-HS0),.H_BP(HT-HS1),
  .V_FP(VS0-VA),.V_SYNC(VS1-VS0),.V_BP(VT-VS1)) video(
  .pixel_clk(clk),.resetn(resetn),.s_axis_tdata(16'b0),
  .s_axis_tvalid(1'b0),.s_axis_tuser(1'b0),.s_axis_tlast(1'b0),.s_axis_tready(),
  .rgb(rgb),.hsync(hs),.vsync(vs),.de(de),.display_frames(frame_count),
  .underflows(),.framing_errors(),.write_valid(init_bin<129),.write_bin(init_bin),
  .write_dx(8'b0),.write_dy(8'b0),.write_ready(),.commit(init_bin==129),
  .overlay_enable(1'b1),.signal_state(2'b10),
  .commit_accepted(),.commit_rejected(),.commit_done());
endmodule
