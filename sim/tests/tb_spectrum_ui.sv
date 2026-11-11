`timescale 1ns/1ps
module tb_spectrum_ui;
 reg clk=0;always #5 clk=~clk;
 reg resetn=0;reg [11:0] x=0,y=0;reg [23:0] rgb=24'h123456;
 reg hs=0,vs=0,de=1,wv=0,commit=0,en=1;reg [1:0] state=1;
 reg [7:0] index=0,dx=0,dy=0;
 wire ready,accepted,rejected,done,ho,vo,deo;wire [23:0] out;
 reg [15:0] words[0:255],legacy_words[0:255];integer i,xx,yy,fileout;
 reg [7:0] legacy_dx=0,legacy_dy=0;
 wire legacy_ready,legacy_accepted,legacy_rejected,legacy_done,legacy_hs,legacy_vs,legacy_de;
 wire [23:0] legacy_out;
 reg [23:0] delay_rgb0=0,delay_rgb1=0;
 reg [2:0] delay_sync0=0,delay_sync1=0;
 reg [287:0] footer="PEAKS 00  PAGE 0/0  REL BIN %       ";
 motion60_spectrum_overlay dut(clk,resetn,x,y,rgb,hs,vs,de,wv,index,dx,dy,ready,commit,en,state,accepted,rejected,done,out,ho,vo,deo);
 reference_spectrum_overlay reference_dut(clk,resetn,x,y,rgb,hs,vs,de,wv,index,legacy_dx,legacy_dy,legacy_ready,commit,en,state,legacy_accepted,legacy_rejected,legacy_done,legacy_out,legacy_hs,legacy_vs,legacy_de);
 // The independent original renderer receives its original packet format.
 // Compare every output pixel, including transitions, after aligning latency.
 always @(posedge clk)begin
  if(!resetn)begin delay_rgb0<=0;delay_rgb1<=0;delay_sync0<=0;delay_sync1<=0;end
  else begin
   delay_rgb0<=legacy_out;delay_rgb1<=delay_rgb0;
   delay_sync0<={legacy_hs,legacy_vs,legacy_de};delay_sync1<=delay_sync0;
   #1;
   if(out!==delay_rgb1||{ho,vo,deo}!==delay_sync1)$fatal(1,"pixel equivalence mismatch x=%0d y=%0d new=%h ref=%h",x,y,out,delay_rgb1);
   if({ready,accepted,rejected,done}!=={legacy_ready,legacy_accepted,legacy_rejected,legacy_done})$fatal(1,"packet handshake changed");
  end
 end
 task sendword(input integer k);
 begin @(negedge clk);wv=1;index=k;dx=words[k][7:0];dy=words[k][15:8];legacy_dx=legacy_words[k][7:0];legacy_dy=legacy_words[k][15:8];end
 endtask
 task settle;begin repeat(3)begin @(posedge clk);#1;end end endtask
 task publish;
 begin
  @(negedge clk);wv=0;commit=1;
  @(posedge clk);#1;if(!accepted||rejected)$fatal(1,"complete packet rejected");
  @(negedge clk);commit=0;vs=1;
  @(posedge clk);#1;if(!done)$fatal(1,"frame swap missing");
  @(negedge clk);vs=0;
 end
 endtask
 initial begin
  $readmemh("ui_packet.hex",words);
  for(i=0;i<256;i++)legacy_words[i]=words[i];
  for(i=0;i<36;i++)legacy_words[237+i/2][(i%2)*8 +:8]=footer[287-i*8 -:8];
  legacy_words[240]=words[252];
  legacy_words[244][15:8]=words[253][15:8];legacy_words[245][15:8]=words[254][15:8];
  repeat(2)@(negedge clk);resetn=1;
  for(i=0;i<129;i++)sendword(i);
  @(negedge clk);wv=0;commit=1;
  @(posedge clk);#1;if(!rejected||accepted)$fatal(1,"partial packet accepted");
  @(negedge clk);commit=0;
  for(i=129;i<256;i++)sendword(i);
  publish;
  fileout=$fopen("sidebar.ppm","w");$fwrite(fileout,"P3\n608 928\n255\n");
  for(yy=32;yy<960;yy++)for(xx=1296;xx<1904;xx++)begin
   @(negedge clk);x=xx;y=yy;
   settle;$fwrite(fileout,"%0d %0d %0d\n",out[23:16],out[15:8],out[7:0]);
  end
  $fclose(fileout);
  for(i=0;i<60;i++)begin
   @(negedge clk);vs=1;@(negedge clk);vs=0;
  end
  @(posedge clk);#1;if(dut.state_active!==3)$fatal(1,"stalled firmware left old peaks valid");
  @(negedge clk);x=510;y=270;
  settle;if(out!==24'hff0000)$fatal(1,"ROI outline missing");
  @(negedge clk);x=512;y=272;
  settle;if(out!==rgb)$fatal(1,"measured ROI altered");
  for(i=0;i<256;i++)sendword(i);
  state=2;publish;
  @(negedge clk);x=1396;y=334;
  settle;if(out===24'h6ef0b0)$fatal(1,"stale peak in low texture");
  @(negedge clk);de=0;x=510;y=270;hs=1;
  settle;if(out!==rgb||deo||!ho)$fatal(1,"blanking/sync alignment changed");
  // A pending panel-off request must not remove its box before the swap.
  @(negedge clk);de=1;hs=0;en=0;
  settle;if(out!==24'hff0000)$fatal(1,"uncommitted panel disable removed ROI");
  for(i=0;i<256;i++)sendword(i);
  publish;settle;if(out!==rgb)$fatal(1,"disabled spectrum left a fixed ROI box");
  @(negedge clk);x=1396;y=334;
  settle;if(out!==rgb)$fatal(1,"disabled spectrum altered panel pixels");
  $display("SPECTRA_RTL_PASSED packet_integrity=1 roi=1 invalid_clear=1 watchdog=1 sync=1 pixel_equivalence=1 panel_gates_roi=1 latency=3");$finish;
 end
endmodule
