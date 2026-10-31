// Free-running 1600x900@60 timing with a 1280x800 grayscale viewport.
// Stream ownership/CRC approval is upstream. This block never certifies capture.
module motion60_video #(
 parameter WIDTH=1280, HEIGHT=800, H_ACTIVE=1600, V_ACTIVE=900,
 parameter H_FP=24, H_SYNC=80, H_BP=96, V_FP=1, V_SYNC=3, V_BP=96
)(
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 pixel_clk CLK", X_INTERFACE_PARAMETER="ASSOCIATED_BUSIF S_AXIS, ASSOCIATED_RESET resetn" *) input wire pixel_clk,
 (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 resetn RST", X_INTERFACE_PARAMETER="POLARITY ACTIVE_LOW" *) input wire resetn,
 (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TDATA" *) input wire [15:0] s_axis_tdata,
 (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TVALID" *) input wire s_axis_tvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TREADY" *) output wire s_axis_tready,
 (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TUSER" *) input wire s_axis_tuser,
 (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TLAST" *) input wire s_axis_tlast,
 output reg [23:0] rgb, output reg hsync, output reg vsync, output reg de,
 output reg [31:0] display_frames, output reg [31:0] underflows,
 output reg [31:0] framing_errors
);
 localparam H_TOTAL=H_ACTIVE+H_FP+H_SYNC+H_BP;
 localparam V_TOTAL=V_ACTIVE+V_FP+V_SYNC+V_BP;
 reg [11:0] x,y;
 reg seeking;
 wire origin=(x==0 && y==0);
 wire viewport=(x<WIDTH && y<HEIGHT);
 wire start_ok=origin && s_axis_tvalid && s_axis_tuser;
 // Hold a discovered SOF until the next viewport origin. Discard stale tail.
 assign s_axis_tready=seeking ? ((!s_axis_tuser) || origin) : viewport;
 wire active_stream=(!seeking || start_ok) && viewport;
 wire beat_ok=s_axis_tvalid && (s_axis_tlast==(x==WIDTH-1)) &&
              (s_axis_tuser==origin);
 wire [7:0] gray=s_axis_tdata[9:2];
 always @(posedge pixel_clk) begin
  if(!resetn) begin
   x<=0;y<=0;seeking<=1;rgb<=0;hsync<=0;vsync<=0;de<=0;
   display_frames<=0;underflows<=0;framing_errors<=0;
  end else begin
   if(x==H_TOTAL-1) begin
    x<=0;
    if(y==V_TOTAL-1) begin y<=0;display_frames<=display_frames+1;end
    else y<=y+1;
   end else x<=x+1;
   hsync<=(x>=H_ACTIVE+H_FP && x<H_ACTIVE+H_FP+H_SYNC);
   vsync<=(y>=V_ACTIVE+V_FP && y<V_ACTIVE+V_FP+V_SYNC);
   de<=(x<H_ACTIVE && y<V_ACTIVE);
   rgb<=0;
   // Fixed gray border identifies active display timing even in a dark room.
   // It is display decoration, never a camera health indicator.
   if(x==WIDTH && y<HEIGHT) rgb<=24'h404040;
   if(start_ok) seeking<=0;
   if(active_stream) begin
    if(beat_ok) rgb<={gray,gray,gray};
    else begin
     seeking<=1;
     if(!s_axis_tvalid) underflows<=underflows+1;
     else framing_errors<=framing_errors+1;
    end
   end
   if(!seeking && x==WIDTH-1 && y==HEIGHT-1) seeking<=1;
  end
 end
endmodule
