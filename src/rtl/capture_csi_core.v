// Only video adaptation/statistics here. PHY, lane alignment, CSI packets, ECC,
// CRC and RAW10 unpacking all belong to AMD's complete CSI-2 RX Subsystem.
module capture_csi_core #(parameter integer FIXED_PHY=0)(
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME clk, ASSOCIATED_BUSIF S_AXIS:M_AXIS, ASSOCIATED_RESET resetn, FREQ_HZ 100000000" *)
 input wire clk,
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME resetn, POLARITY ACTIVE_LOW" *)
 input wire resetn,
 input wire [31:0] control, output reg [31:0] status,
 input wire [39:0] s_axis_tdata, input wire [9:0] s_axis_tdest,
 input wire s_axis_tvalid, s_axis_tlast, input wire [95:0] s_axis_tuser,
 output wire s_axis_tready,
 output wire [63:0] m_axis_tdata, output wire [7:0] m_axis_tkeep,
 output wire m_axis_tvalid, m_axis_tlast, m_axis_tuser,
 input wire m_axis_tready, input wire phy_ready_async,
 input wire [5:0] phy_lp_async, input wire phy_byteclk
);
 wire [39:0] test_pixels;
 wire test_valid,test_sof,test_eol;
 wire run=control[0],test_mode=control[1];
 wire [31:0] frames,shapes,drops,shape_errors,interval,tslo,tshi;
 reg [31:0] snap[0:15];
 integer i;
 reg snapshot_q;
 (* ASYNC_REG="TRUE" *) reg [1:0] ready_sync=0;
 always @(posedge clk) ready_sync<={ready_sync[0],phy_ready_async};
 // A stall propagates into AMD's video FIFO. Its sticky line-buffer overflow
 // status is monitored in firmware. Never count a held beat more than once.
 assign s_axis_tready=test_mode || !run || !m_axis_tvalid || m_axis_tready;
 wire accepted=s_axis_tvalid && s_axis_tready;
 capture_test_source testgen(.clk(clk),.resetn(resetn && !control[3]),
  .enable(run && test_mode),.checkerboard(control[8]),
  .pixels(test_pixels),.valid(test_valid),.sof(test_sof),.eol(test_eol));
 raw10_axis_guard guard(.clk(clk),.resetn(resetn && !control[3]),.enable(run),
  .packet_error(!test_mode && accepted && s_axis_tuser[1]),.frame_end(1'b0),
  .pixels(test_mode?test_pixels:s_axis_tdata),.valid(test_mode?test_valid:accepted),
  .sof(test_mode?test_sof:s_axis_tuser[0]),.eol(test_mode?test_eol:s_axis_tlast),
  .m_axis_tdata(m_axis_tdata),.m_axis_tkeep(m_axis_tkeep),
  .m_axis_tvalid(m_axis_tvalid),.m_axis_tuser(m_axis_tuser),
  .m_axis_tlast(m_axis_tlast),.m_axis_tready(m_axis_tready),
  .frames(frames),.shape_frames(shapes),.drops(drops),.shape_errors(shape_errors),
  .last_interval(interval),.timestamp_lo(tslo),.timestamp_hi(tshi));
 reg [31:0] dest_errors=0;
 reg [15:0] sensor_frame_last=0;
 reg [31:0] sensor_frame_gaps=0,sensor_frame_changes=0,sensor_frame_sofs=0;
 reg sensor_frame_seen=0,meta_started=0,line_start=1;
 reg [6:0] meta_count=0;
 reg [127:0] meta_mem[0:63],meta_q;
 wire [15:0] sensor_delta=s_axis_tuser[31:16]-sensor_frame_last;
 always @(posedge clk) begin
  meta_q<=meta_mem[control[21:16]];
  if(!resetn || control[3]) begin
   sensor_frame_last<=0;sensor_frame_gaps<=0;sensor_frame_changes<=0;
   sensor_frame_sofs<=0;sensor_frame_seen<=0;meta_count<=0;meta_started<=0;line_start<=1;
  end else if(run && !test_mode && accepted) begin
   if(s_axis_tuser[0]) begin
    sensor_frame_last<=s_axis_tuser[31:16];sensor_frame_seen<=1;
    sensor_frame_sofs<=sensor_frame_sofs+1;meta_started<=1;
    if(sensor_frame_seen) begin
     if(sensor_delta!=16'd1)sensor_frame_gaps<=sensor_frame_gaps+1;
     if(sensor_delta!=0)sensor_frame_changes<=sensor_frame_changes+1;
    end
   end
   if((s_axis_tuser[0] || (meta_started && line_start)) && meta_count<64) begin
    meta_mem[meta_count[5:0]]<={s_axis_tuser,22'b0,s_axis_tdest};meta_count<=meta_count+1;
   end
   line_start<=s_axis_tlast;
  end
 end
 wire [31:0] meta_debug=control[24]?{25'b0,meta_count}:meta_q[control[23:22]*32+:32];
 always @(posedge clk) begin
  if(!resetn || control[3]) dest_errors<=0;
  // Generated vfb_v1_0_29_op_inf packs {datatype[5:0],vc[3:0]}.
  else if(run && !test_mode && accepted && s_axis_tdest!=10'h2b0) dest_errors<=dest_errors+1;
 end
 // Preserve LP/clock startup diagnostics across the video-path resets.
 (* ASYNC_REG="TRUE" *) reg [5:0] lp_meta=0,lp_sync=0;
 (* ASYNC_REG="TRUE" *) reg [1:0] toggle_sync=0;
 reg [7:0] byte_div=0;
 always @(posedge phy_byteclk) byte_div<=byte_div+1;
 reg [31:0] ticks=0,byte_edges=0;
 reg toggle_q=0;
 reg [5:0] last_lp=0;
 reg [7:0] count=0;
 reg [31:0] time_mem[0:127],state_mem[0:127],time_q,state_q;
 always @(posedge clk) begin
  lp_meta<=phy_lp_async;lp_sync<=lp_meta;
  toggle_sync<={toggle_sync[0],byte_div[7]};toggle_q<=toggle_sync[1];
  time_q<=time_mem[control[23:17]];state_q<=state_mem[control[23:17]];
  if(control[13]) begin ticks<=0;count<=0;last_lp<=~lp_sync;byte_edges<=0;end
  else begin
   ticks<=ticks+1;
   if(toggle_sync[1] && !toggle_q)byte_edges<=byte_edges+1;
   if(lp_sync!=last_lp && count<128) begin
    time_mem[count[6:0]]<=ticks;
    state_mem[count[6:0]]<={1'b1,24'b0,toggle_sync[1],lp_sync};
    count<=count+1;last_lp<=lp_sync;
   end
  end
 end
 wire [31:0] lp_debug=control[24]?(control[16]?{18'b0,count,lp_sync}:byte_edges):
  (control[16]?state_q:time_q);
 always @(posedge clk) begin
  if(!resetn) begin snapshot_q<=0;for(i=0;i<16;i=i+1)snap[i]<=0;end
  else begin
   snapshot_q<=control[9];
   if(control[9] && !snapshot_q) begin
    snap[0]<=FIXED_PHY?32'h92810005:32'h92810004;snap[1]<=frames;snap[2]<=shapes;snap[3]<=drops;
    snap[4]<=shape_errors;snap[5]<={16'b0,sensor_frame_last};snap[6]<=sensor_frame_gaps;
    snap[7]<=sensor_frame_changes;snap[8]<=dest_errors;
    snap[9]<=sensor_frame_sofs;snap[10]<=interval;snap[11]<=tslo;snap[12]<=tshi;
    snap[13]<={29'b0,ready_sync[1],1'b0,run};snap[14]<=1280;snap[15]<=800;
   end
  end
 end
 always @* status=control[12]?(control[26]?meta_debug:lp_debug):snap[control[7:4]];
endmodule
