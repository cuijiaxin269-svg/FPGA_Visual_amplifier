// Temporary 720p60 link isolation image; not the 1280x800 processing mode.
module hdmi_diagnostic_pattern #(
 parameter HA=1280,VA=720,HT=1650,VT=750,HS0=1390,HS1=1430,VS0=725,VS1=730
)(
 input wire clk, input wire resetn,
 output reg [23:0] rgb, output reg hs,vs,de,
 output reg [31:0] frame_count=0
);
 reg [11:0] x=0,y=0;
 reg [7:0] frame=0;
 always @(posedge clk) begin
  if(!resetn)begin x<=0;y<=0;frame<=0;frame_count<=0;rgb<=0;hs<=0;vs<=0;de<=0;end
  else begin
   if(x==HT-1)begin x<=0;if(y==VT-1)begin y<=0;frame<=frame+1;frame_count<=frame_count+1;end else y<=y+1;end
   else x<=x+1;
   hs<=(x>=HS0&&x<HS1);vs<=(y>=VS0&&y<VS1);de<=(x<HA&&y<VA);
   rgb<=0;
   if(x<HA&&y<VA)begin
    // White perimeter and eight bars give unmistakable spatial evidence.
    if(x<8||x>=HA-8||y<8||y>=VA-8)rgb<=24'hffffff;
    else if(y<VA-80)case(x/(HA/8))
     0:rgb<=24'hffffff;1:rgb<=24'hffff00;2:rgb<=24'h00ffff;3:rgb<=24'h00ff00;
     4:rgb<=24'hff00ff;5:rgb<=24'hff0000;6:rgb<=24'h0000ff;default:rgb<=0;
    endcase
    else rgb<=24'h404040; // Fixed gray strip; frame counter remains live.
   end
  end
 end
endmodule
