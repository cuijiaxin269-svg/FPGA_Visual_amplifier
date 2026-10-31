// Full-system HDMI probe: production path keeps its existing two-cycle latency.
// Source selection changes only at the proven reference raster's VS edge.
module full_hdmi_observe(
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 pixel_clk CLK", X_INTERFACE_PARAMETER="ASSOCIATED_RESET resetn" *) input wire pixel_clk,
 (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 resetn RST", X_INTERFACE_PARAMETER="POLARITY ACTIVE_LOW" *) input wire resetn,
 input wire [23:0] prod_rgb,input wire prod_hs,prod_vs,prod_de,
 input wire request_bars,
 output reg selected_bars,
 output wire [23:0] rgb,output wire hs,vs,de,
 output wire [31:0] probe_id,geometry,frame_id_inverse,
 output wire [31:0] status,
 output reg [31:0] frame_id,
 output reg [31:0] period,hs_high,vs_high,de_pixels,nonzero_pixels,rgb_sum,
 output reg [31:0] hs_rises,vs_rises,de_lines,de_widths,output_nonzero,
 output reg snapshot_valid,frame_toggle
);
 wire [23:0] raw_rgb;wire raw_hs,raw_vs,raw_de;wire [31:0] unused_count;
 hdmi_diagnostic_pattern #(.HA(1920),.VA(1080),.HT(2200),.VT(1125),
 .HS0(2008),.HS1(2052),.VS0(1084),.VS1(1089)) bars(
 .clk(pixel_clk),.resetn(resetn),.rgb(raw_rgb),.hs(raw_hs),.vs(raw_vs),.de(raw_de),.frame_count(unused_count));
 reg [23:0] bars_rgb;reg bars_hs,bars_vs,bars_de;
 reg last_ref_vs,last_hs,last_vs,last_de,started,snapshot_source;
 reg sync_error,geometry_error;
 reg [31:0] c_period,c_hs,c_vs,c_de,c_nonzero,c_sum,c_hrise,c_vrise,c_lines,c_outnz;
 reg [15:0] run_de,min_de,max_de;
 wire boundary=bars_vs&&!last_ref_vs;
 wire hrise=prod_hs&&!last_hs,vrise=prod_vs&&!last_vs,derise=prod_de&&!last_de;
 wire defall=!prod_de&&last_de;
 wire p_nonzero=prod_de&&(prod_rgb!=24'd0);
 wire o_nonzero=de&&(rgb!=24'd0);
 wire [9:0] pixel_sum={2'b0,prod_rgb[23:16]}+{2'b0,prod_rgb[15:8]}+{2'b0,prod_rgb[7:0]};
 assign rgb=selected_bars?bars_rgb:prod_rgb;
 assign hs=selected_bars?bars_hs:prod_hs;
 assign vs=selected_bars?bars_vs:prod_vs;
 assign de=selected_bars?bars_de:prod_de;
 assign probe_id=32'h4f425331;
 assign geometry=32'h07800438;
 assign frame_id_inverse=~frame_id;
 // bit0 snapshot valid,1 current source,2 snapshot source,3 sync mismatch sticky,
 // bit4 geometry mismatch sticky,5 request,6 current inputHS,7 VS,8 DE.
 assign status={23'b0,prod_de,prod_vs,prod_hs,request_bars,geometry_error,sync_error,snapshot_source,selected_bars,snapshot_valid};
 always @(posedge pixel_clk)begin
  if(!resetn)begin
   bars_rgb<=0;bars_hs<=0;bars_vs<=0;bars_de<=0;
   selected_bars<=0;last_ref_vs<=0;last_hs<=0;last_vs<=0;last_de<=0;
   started<=0;snapshot_source<=0;snapshot_valid<=0;frame_toggle<=0;
   sync_error<=0;geometry_error<=0;frame_id<=0;
   period<=0;hs_high<=0;vs_high<=0;de_pixels<=0;nonzero_pixels<=0;rgb_sum<=0;
   hs_rises<=0;vs_rises<=0;de_lines<=0;de_widths<=0;output_nonzero<=0;
   c_period<=0;c_hs<=0;c_vs<=0;c_de<=0;c_nonzero<=0;c_sum<=0;
   c_hrise<=0;c_vrise<=0;c_lines<=0;c_outnz<=0;
   run_de<=0;min_de<=16'hffff;max_de<=0;
  end else begin
   // Delay the entire proven one-cycle pattern tuple by one cycle.
   bars_rgb<=raw_rgb;bars_hs<=raw_hs;bars_vs<=raw_vs;bars_de<=raw_de;
   last_ref_vs<=bars_vs;last_hs<=prod_hs;last_vs<=prod_vs;last_de<=prod_de;
   if(started&&({prod_hs,prod_vs,prod_de}!={bars_hs,bars_vs,bars_de}))sync_error<=1;
   if(boundary)begin
    selected_bars<=request_bars;
    frame_toggle<=!frame_toggle;
    started<=1;
    if(started)begin
     snapshot_valid<=1;frame_id<=frame_id+1;snapshot_source<=selected_bars;
     period<=c_period;hs_high<=c_hs;vs_high<=c_vs;de_pixels<=c_de;
     nonzero_pixels<=c_nonzero;rgb_sum<=c_sum;hs_rises<=c_hrise;
     vs_rises<=c_vrise;de_lines<=c_lines;de_widths<={min_de,max_de};output_nonzero<=c_outnz;
     if(c_period!=2475000||c_hs!=49500||c_vs!=11000||c_de!=2073600||
        c_hrise!=1125||c_vrise!=1||c_lines!=1080||min_de!=1920||max_de!=1920)
       geometry_error<=1;
    end
    // Start a complete interval [this VS edge,next VS edge), including this beat.
    c_period<=1;c_hs<=prod_hs;c_vs<=prod_vs;c_de<=prod_de;
    c_nonzero<=p_nonzero;c_sum<=prod_de?pixel_sum:0;
    c_hrise<=hrise;c_vrise<=vrise;c_lines<=derise;c_outnz<=o_nonzero;
    run_de<=prod_de?1:0;min_de<=16'hffff;max_de<=0;
   end else begin
    c_period<=c_period+1;c_hs<=c_hs+prod_hs;c_vs<=c_vs+prod_vs;c_de<=c_de+prod_de;
    c_nonzero<=c_nonzero+p_nonzero;if(prod_de)c_sum<=c_sum+pixel_sum;
    c_hrise<=c_hrise+hrise;c_vrise<=c_vrise+vrise;c_lines<=c_lines+derise;c_outnz<=c_outnz+o_nonzero;
    if(prod_de)run_de<=run_de+1;
    else begin
     run_de<=0;
     if(defall)begin
      if(run_de<min_de)min_de<=run_de;
      if(run_de>max_de)max_de<=run_de;
     end
    end
   end
  end
 end
endmodule
