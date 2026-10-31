`timescale 1ns/1ps
module tb_border_alignment;
 reg clk=0;always #5 clk=~clk;
 reg resetn=0;
 localparam HA=1920,VA=1080,HT=2200,VT=1125;
 integer sx=0,sy=0,px=0,py=0,n=0,red_count=0;
 reg previous_valid=0;
 wire [15:0] data={6'b0,sx[4:0],sy[4:0]};
 wire valid=(sx<1280&&sy<800),user=(sx==0&&sy==0),last=(sx==1279);
 wire ready,base_ready,hs,vs,de,bhs,bvs,bde;
 wire [23:0] rgb,brgb;
 wire [31:0] frames,underflows,framing,bframes,bunderflows,bframing;
 reg [23:0] expected;
 reg ehs,evs,ede;
 reg [23:0] expect0=0,expect1=0;
 reg [2:0] sync0=0,sync1=0;
 motion60_video_osd #(.H_ACTIVE(HA),.V_ACTIVE(VA),.H_FP(88),.H_SYNC(44),.H_BP(148),.V_FP(4),.V_SYNC(5),.V_BP(36)) dut(
  .pixel_clk(clk),.resetn(resetn),.s_axis_tdata(data),.s_axis_tvalid(valid),.s_axis_tready(ready),
  .s_axis_tuser(user),.s_axis_tlast(last),.rgb(rgb),.hsync(hs),.vsync(vs),.de(de),
  .display_frames(frames),.underflows(underflows),.framing_errors(framing),
  .write_valid(1'b0),.write_bin(8'b0),.write_dx(8'b0),.write_dy(8'b0),.commit(1'b0),.overlay_enable(1'b0),.signal_state(2'b0));
 motion60_video #(.H_ACTIVE(HA),.V_ACTIVE(VA),.H_FP(88),.H_SYNC(44),.H_BP(148),.V_FP(4),.V_SYNC(5),.V_BP(36)) baseline(
  .pixel_clk(clk),.resetn(resetn),.s_axis_tdata(data),.s_axis_tvalid(valid),.s_axis_tready(base_ready),
  .s_axis_tuser(user),.s_axis_tlast(last),.rgb(brgb),.hsync(bhs),.vsync(bvs),.de(bde),
  .display_frames(bframes),.underflows(bunderflows),.framing_errors(bframing));
 initial begin
  repeat(3)@(negedge clk);resetn=1;
  // Independent raster expectation, including blanking and the full wrapper latency.
  for(n=0;n<HT*VT+4;n=n+1)begin
   @(posedge clk);
   expected=brgb;ehs=bhs;evs=bvs;ede=bde;
   if(previous_valid && bde && px>=510&&px<770&&py>=270&&py<530 &&
      !(px>=512&&px<768&&py>=272&&py<528))begin
    expected=24'hff0000;red_count=red_count+1;
   end
   if(ready!==base_ready)$fatal(1,"stream backpressure changed");
   #1;
   if(rgb!==expect1||{hs,vs,de}!==sync1)
    $fatal(1,"wrapper mismatch x=%0d y=%0d rgb=%h expected=%h",px,py,rgb,expect1);
   expect1=expect0;expect0=expected;sync1=sync0;sync0={ehs,evs,ede};
   if(frames!==bframes||underflows!==bunderflows||framing!==bframing)
    $fatal(1,"video counters changed");
   @(negedge clk);px=sx;py=sy;previous_valid=1;
   if(sx==HT-1)begin sx=0;sy=(sy==VT-1)?0:sy+1;end else sx=sx+1;
  end
  if(red_count!=2064||underflows!=0||framing!=0)$fatal(1,"count/error red=%0d underflows=%0d framing=%0d",red_count,underflows,framing);
  $display("BORDER_WRAPPER_ALIGNMENT_PASSED full_1080p_frame=1 red_pixels=%0d backpressure_unchanged=1 overlay_latency=3",red_count);
  $finish;
 end
endmodule
