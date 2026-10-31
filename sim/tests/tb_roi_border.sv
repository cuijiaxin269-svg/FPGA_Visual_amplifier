`timescale 1ns/1ps
module tb_roi_border;
 reg clk=0;always #5 clk=~clk;
 reg resetn=0;
 reg [11:0] x=0,y=0;
 reg [23:0] rgb=0;
 reg hs=0,vs=0,de=0,write_valid=0,commit=0,enable=0;
 reg [7:0] bin=0,dx=0,dy=0;
 wire ready,accepted,rejected,done,hs_o,vs_o,de_o;
 wire [23:0] out;
 motion60_spectrum_overlay dut(clk,resetn,x,y,rgb,hs,vs,de,
 write_valid,bin,dx,dy,ready,commit,enable,2'd1,
 accepted,rejected,done,out,hs_o,vs_o,de_o);
 integer xx,yy,phase,red_count=0,checked=0;
 reg [23:0] expected;
 task pixel(input integer px,py,input bit active);
 begin
  @(negedge clk);x=px;y=py;de=active;
  rgb={px[7:0],py[7:0],8'h35};hs=px[0];vs=0;
  expected=rgb;
  if(active && px>=510 && px<770 && py>=270 && py<530 &&
     !(px>=512 && px<768 && py>=272 && py<528))begin
   expected=24'hff0000;red_count=red_count+1;
  end
  @(posedge clk);#1;
  if(out!==expected || hs_o!==hs || vs_o!==vs || de_o!==de)
   $fatal(1,"pixel/sync mismatch x=%0d y=%0d de=%0d out=%h expected=%h",px,py,active,out,expected);
  checked=checked+1;
 end
 endtask
 initial begin
  repeat(2)@(posedge clk);#1;
  if(out!==0||hs_o!==0||vs_o!==0||de_o!==0)$fatal(1,"reset");
  @(negedge clk);resetn=1;
  // Scan complete viewport with spectrum off, then on after atomic commit.
  for(phase=0;phase<2;phase=phase+1)begin
   if(phase==1)begin
    for(xx=0;xx<129;xx=xx+1)begin
     @(negedge clk);write_valid=1;bin=xx;dx=5;dy=7;
    end
    @(negedge clk);write_valid=0;enable=1;commit=1;
    @(posedge clk);#1;if(!accepted||rejected)$fatal(1,"commit");
    @(negedge clk);commit=0;vs=1;
    @(posedge clk);#1;if(!done)$fatal(1,"frame commit");
   end
   for(yy=0;yy<800;yy=yy+1)
    for(xx=0;xx<1280;xx=xx+1)pixel(xx,yy,1);
   pixel(510,270,0);pixel(769,529,0);
  end
  if(red_count!=4128)$fatal(1,"border pixel count %0d",red_count);
  @(negedge clk);x=1301;y=319;rgb=0;de=1;
  @(posedge clk);#1;if(out!==24'h00d8ff)$fatal(1,"DX chart preserved");
  @(negedge clk);y=655;
  @(posedge clk);#1;if(out!==24'hffb040)$fatal(1,"DY chart preserved");
  $display("ROI_BORDER_RTL_PASSED checked=%0d red=%0d sync_aligned=1 chart_preserved=1",checked,red_count);
  $finish;
 end
endmodule
