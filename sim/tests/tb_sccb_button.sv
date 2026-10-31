`timescale 1ns/1ps
module tb_sccb_button;
 reg clk=0,key0_n=1;
 always #5 clk=~clk;
 reg ps_scl_o=0,ps_scl_t=1,ps_sda_o=0,ps_sda_t=1;
 reg cam_scl_i=1,cam_sda_i=1;
 reg [3:0] bb_data=0,bb_tri=15;
 wire ps_scl_i,ps_sda_i,cam_scl_o,cam_scl_t,cam_sda_o,cam_sda_t;
 wire [3:0] levels;
 sccb_bridge dut(.button_clk(clk),.key0_n(key0_n),
  .ps_scl_i(ps_scl_i),.ps_scl_o(ps_scl_o),.ps_scl_t(ps_scl_t),
  .ps_sda_i(ps_sda_i),.ps_sda_o(ps_sda_o),.ps_sda_t(ps_sda_t),
  .cam_scl_i(cam_scl_i),.cam_scl_o(cam_scl_o),.cam_scl_t(cam_scl_t),
  .cam_sda_i(cam_sda_i),.cam_sda_o(cam_sda_o),.cam_sda_t(cam_sda_t),
  .bb_data(bb_data),.bb_tri(bb_tri),.levels(levels));
 integer i;
 initial begin
  #1;if(levels!==4'b1011)$fatal(1,"initial released level");
  #1;key0_n=0;
  @(posedge clk);#1;if(levels[3]!==1)$fatal(1,"first flop leaked through");
  @(posedge clk);#1;if(levels[3]!==0)$fatal(1,"two-flop press not visible");
  #1;key0_n=1;
  @(posedge clk);#1;if(levels[3]!==0)$fatal(1,"release bypassed second flop");
  @(posedge clk);#1;if(levels[3]!==1)$fatal(1,"release not visible");
  // Exhaust existing SCCB data/tri-state/readback combinations. Bit 3 outputs
  // are deliberately varied: they must never drive the key or affect SCCB.
  for(i=0;i<1024;i=i+1)begin
   {bb_data[3:2],bb_tri[3],bb_tri[1:0],ps_scl_o,ps_scl_t,ps_sda_o,ps_sda_t,cam_scl_i}=i;
   cam_sda_i=~cam_scl_i;
   #1;
   if(ps_scl_i!==cam_scl_i||ps_sda_i!==cam_sda_i)$fatal(1,"SCCB readback changed");
   if(levels[2:0]!=={1'b0,cam_scl_i,cam_sda_i})$fatal(1,"old GPIO bits changed");
   if(cam_scl_o!==(bb_data[2]?1'b0:ps_scl_o)||cam_sda_o!==(bb_data[2]?1'b0:ps_sda_o))$fatal(1,"SCCB data changed");
   if(cam_scl_t!==(bb_data[2]?bb_tri[1]:ps_scl_t)||cam_sda_t!==(bb_data[2]?bb_tri[0]:ps_sda_t))$fatal(1,"SCCB tri-state changed");
  end
  $display("PASS KEY0 two-stage synchronization and 1024 SCCB compatibility combinations");
  $finish;
 end
 initial begin #100000;$fatal(1,"test timeout");end
endmodule
