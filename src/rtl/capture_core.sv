module capture_core_impl #(parameter integer AMD_PHY=0)(
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME clk, ASSOCIATED_BUSIF S_AXIS:M_AXIS, ASSOCIATED_RESET resetn, FREQ_HZ 100000000" *)
 input wire clk, input wire resetn,
 input wire [31:0] control, output reg [31:0] status,
 input wire [31:0] s_axis_tdata, input wire [3:0] s_axis_tkeep,
 input wire s_axis_tvalid, s_axis_tlast, output wire s_axis_tready,
 output wire [63:0] m_axis_tdata, output wire [7:0] m_axis_tkeep,
 output wire m_axis_tvalid, m_axis_tlast, m_axis_tuser, input wire m_axis_tready,
 input wire phy_fault_async, input wire mclk_locked,
 input wire [5:0] phy_lp_async, input wire phy_byteclk, input wire phy_clock_active_async,
 output wire mclk_enable
);
 wire [39:0] rx_pixels, test_pixels;
 wire rx_valid, rx_sof, rx_eol, fs, fe, error, test_valid, test_sof, test_eol;
 wire [31:0] ec,ee,ce,pe,pk,frames,shapes,drops,se,interval,tslo,tshi;
 (* ASYNC_REG="TRUE" *) reg [1:0] phy_fault;
 reg [31:0] snap[0:15];
 reg snapshot_q;
 wire [31:0] byte_debug;
 wire [31:0] lp_debug;
 generate if(AMD_PHY) begin: lp_monitor
  // Diagnostic sampling only: LP state duration resolution is 10ns.
  // Reset with bit13 before streaming; pipeline reset must preserve startup trace.
  (* ASYNC_REG="TRUE" *) reg [5:0] lp_meta=0,lp_sync=0;
  (* ASYNC_REG="TRUE" *) reg [1:0] active_sync=0,toggle_sync=0;
  reg [7:0] byte_div=0;
  always @(posedge phy_byteclk) byte_div<=byte_div+1;
  reg [31:0] ticks=0,byte_edges=0;
  reg toggle_q=0;
  reg [5:0] last_lp=0;
  reg [7:0] count=0;
  reg [31:0] time_mem[0:127],state_mem[0:127],time_q,state_q;
  always @(posedge clk) begin
   lp_meta<=phy_lp_async;lp_sync<=lp_meta;
   active_sync<={active_sync[0],phy_clock_active_async};
   toggle_sync<={toggle_sync[0],byte_div[7]};toggle_q<=toggle_sync[1];
   time_q<=time_mem[control[23:17]];state_q<=state_mem[control[23:17]];
   if(control[13]) begin ticks<=0;count<=0;last_lp<=~lp_sync;byte_edges<=0;end
   else begin
    ticks<=ticks+1;
    if(toggle_sync[1] && !toggle_q)byte_edges<=byte_edges+1;
    if(lp_sync!=last_lp && count<128) begin
     time_mem[count[6:0]]<=ticks;
     state_mem[count[6:0]]<={1'b1,23'b0,toggle_sync[1],active_sync[1],lp_sync};
     count<=count+1;last_lp<=lp_sync;
    end
   end
  end
  assign lp_debug=control[24]?(control[16]?{18'b0,count,lp_sync}:byte_edges):
   (control[16]?state_q:time_q);
 end else begin assign lp_debug=0;end endgenerate
 generate if(AMD_PHY) begin: packet_debug
  // First four AXIS words of 32 HS packets, captured in the parser's domain.
  // Read using control bit11 and index[23:16] (even=data, odd=metadata).
  reg [31:0] data_mem[0:127], meta_mem[0:127];
  reg [5:0] packet_idx;
  reg [2:0] word_idx;
  reg [31:0] data_q,meta_q;
  wire [6:0] write_idx={packet_idx[4:0],word_idx[1:0]};
  always @(posedge clk) begin
   data_q<=data_mem[control[23:17]];meta_q<=meta_mem[control[23:17]];
   if(!resetn) begin packet_idx<=0;word_idx<=0;end
   else if(s_axis_tvalid && packet_idx<32) begin
    if(word_idx<4) begin
     data_mem[write_idx]<=s_axis_tdata;
     meta_mem[write_idx]<={1'b1,12'b0,packet_idx,5'b0,word_idx,s_axis_tlast,s_axis_tkeep};
     word_idx<=word_idx+1;
    end
    if(s_axis_tlast) begin packet_idx<=packet_idx+1;word_idx<=0;end
   end
  end
  assign byte_debug=control[16]?meta_q:data_q;
 end else begin assign byte_debug=0;end endgenerate
 wire run=control[0]; wire test_mode=control[1];
 assign mclk_enable=control[2];
 assign s_axis_tready=1'b1;
 always @(posedge clk) if(!resetn) phy_fault<=0; else phy_fault<={phy_fault[0],phy_fault_async};
 csi2_raw10_rx rx(.clk(clk),.resetn(resetn && !control[3]),
  .s_data(s_axis_tdata),.s_keep(s_axis_tkeep),.s_valid(s_axis_tvalid),.s_last(s_axis_tlast),
  .pixels(rx_pixels),.valid(rx_valid),.sof(rx_sof),.eol(rx_eol),.frame_start(fs),.frame_end(fe),.packet_error(error),
  .ecc_corrected(ec),.ecc_errors(ee),.crc_errors(ce),.format_errors(pe),.packets(pk));
 capture_test_source testgen(.clk(clk),.resetn(resetn && !control[3]),.enable(run && test_mode),.checkerboard(control[8]),
  .pixels(test_pixels),.valid(test_valid),.sof(test_sof),.eol(test_eol));
 raw10_axis_guard guard(.clk(clk),.resetn(resetn && !control[3]),.enable(run),
  .packet_error(!test_mode && error),.frame_end(!test_mode && fe),
  .pixels(test_mode?test_pixels:rx_pixels),.valid(test_mode?test_valid:rx_valid),
  .sof(test_mode?test_sof:rx_sof),.eol(test_mode?test_eol:rx_eol),
  .m_axis_tdata(m_axis_tdata),.m_axis_tkeep(m_axis_tkeep),.m_axis_tvalid(m_axis_tvalid),
  .m_axis_tuser(m_axis_tuser),.m_axis_tlast(m_axis_tlast),.m_axis_tready(m_axis_tready),
  .frames(frames),.shape_frames(shapes),.drops(drops),.shape_errors(se),
  .last_interval(interval),.timestamp_lo(tslo),.timestamp_hi(tshi));
 // Freeze all counters atomically in this clock domain before software reads them.
 always @(posedge clk) begin
  if(!resetn) begin snapshot_q<=0; for(integer i=0;i<16;i=i+1) snap[i]<=0; end
  else begin
   snapshot_q<=control[9];
   if(control[9] && !snapshot_q) begin
    snap[0]<=AMD_PHY?32'h92810002:32'h92810001; snap[1]<=frames; snap[2]<=shapes; snap[3]<=drops;
    snap[4]<=se; snap[5]<=ec; snap[6]<=ee; snap[7]<=ce; snap[8]<=pe;
    snap[9]<=pk; snap[10]<=interval; snap[11]<=tslo; snap[12]<=tshi;
    snap[13]<={29'b0,mclk_locked,phy_fault[1],run}; snap[14]<=1280; snap[15]<=800;
   end
  end
 end
 always @* status=(AMD_PHY && control[12])?lp_debug:(AMD_PHY && control[11])?byte_debug:snap[control[7:4]];
endmodule
