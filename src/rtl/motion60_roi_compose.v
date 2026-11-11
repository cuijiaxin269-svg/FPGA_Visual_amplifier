`timescale 1ns/1ps
// Copy one original frame outside a square ROI into an unpublished processed
// frame. One read burst and one write burst at a time; no frame-sized storage.
// The caller retains SRC and exclusively owns DST until DONE. Error destinations
// may be partially written and MUST NOT be published to the display.
// 00 ID; 04 START(write 1)/{DONE,BUSY}(read); 08 error; 10 SRC; 14 DST;
// 18 X; 1c Y; 20 SIZE; 24 FLAGS(bit0 inner white border). Full-word writes only.
// Errors: 1 alignment, 2 address wrap, 3 overlap, 4 ROI, 5 flags, 6 geometry,
// 16 read response, 17 write response, 18 read framing. No implicit abort/reset.
module motion60_roi_compose #(
 parameter integer WIDTH=1280, HEIGHT=800
)(
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 aclk CLK", X_INTERFACE_PARAMETER="ASSOCIATED_BUSIF S_AXI:M_AXI, ASSOCIATED_RESET aresetn" *) input wire aclk,
 (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 aresetn RST", X_INTERFACE_PARAMETER="POLARITY ACTIVE_LOW" *) input wire aresetn,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI AWADDR", X_INTERFACE_PARAMETER="PROTOCOL AXI4LITE, DATA_WIDTH 32, ADDR_WIDTH 12" *) input wire [11:0] s_axi_awaddr,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *) input wire s_axi_awvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *) output wire s_axi_awready,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI WDATA" *) input wire [31:0] s_axi_wdata,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *) input wire [3:0] s_axi_wstrb,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI WVALID" *) input wire s_axi_wvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI WREADY" *) output wire s_axi_wready,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI BRESP" *) output reg [1:0] s_axi_bresp,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI BVALID" *) output reg s_axi_bvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI BREADY" *) input wire s_axi_bready,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *) input wire [11:0] s_axi_araddr,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *) input wire s_axi_arvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *) output wire s_axi_arready,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI RDATA" *) output reg [31:0] s_axi_rdata,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI RRESP" *) output reg [1:0] s_axi_rresp,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI RVALID" *) output reg s_axi_rvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI RREADY" *) input wire s_axi_rready,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI ARADDR", X_INTERFACE_PARAMETER="PROTOCOL AXI4, DATA_WIDTH 64, ADDR_WIDTH 32, ID_WIDTH 0, MAX_BURST_LENGTH 16, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1" *) output wire [31:0] m_axi_araddr,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI ARLEN" *) output wire [7:0] m_axi_arlen,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI ARSIZE" *) output wire [2:0] m_axi_arsize,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI ARBURST" *) output wire [1:0] m_axi_arburst,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI ARLOCK" *) output wire m_axi_arlock,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI ARCACHE" *) output wire [3:0] m_axi_arcache,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI ARPROT" *) output wire [2:0] m_axi_arprot,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI ARQOS" *) output wire [3:0] m_axi_arqos,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI ARVALID" *) output wire m_axi_arvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI ARREADY" *) input wire m_axi_arready,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI RDATA" *) input wire [63:0] m_axi_rdata,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI RRESP" *) input wire [1:0] m_axi_rresp,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI RLAST" *) input wire m_axi_rlast,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI RVALID" *) input wire m_axi_rvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI RREADY" *) output wire m_axi_rready,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI AWADDR" *) output wire [31:0] m_axi_awaddr,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI AWLEN" *) output wire [7:0] m_axi_awlen,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI AWSIZE" *) output wire [2:0] m_axi_awsize,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI AWBURST" *) output wire [1:0] m_axi_awburst,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI AWLOCK" *) output wire m_axi_awlock,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI AWCACHE" *) output wire [3:0] m_axi_awcache,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI AWPROT" *) output wire [2:0] m_axi_awprot,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI AWQOS" *) output wire [3:0] m_axi_awqos,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI AWVALID" *) output wire m_axi_awvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI AWREADY" *) input wire m_axi_awready,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI WDATA" *) output wire [63:0] m_axi_wdata,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI WSTRB" *) output wire [7:0] m_axi_wstrb,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI WLAST" *) output wire m_axi_wlast,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI WVALID" *) output wire m_axi_wvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI WREADY" *) input wire m_axi_wready,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI BRESP" *) input wire [1:0] m_axi_bresp,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI BVALID" *) input wire m_axi_bvalid,
 (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 M_AXI BREADY" *) output wire m_axi_bready
);
 localparam [63:0] FRAME_BYTES=WIDTH*(64'd2*HEIGHT);
 localparam IDLE=0,PREPARE=1,READ_ADDRESS=2,READ_DATA=3,
            WRITE_ADDRESS=4,WRITE_DATA=5,WRITE_RESPONSE=6;
 reg [2:0] state;
 reg busy,done,aw_held,w_held;
 reg [11:0] address;
 reg [31:0] data;
 reg [3:0] strobes;
 reg [31:0] cfg_src,cfg_dst,cfg_x,cfg_y,cfg_size,cfg_flags,error_code;
 reg [31:0] roi_x,roi_y,roi_size;
 reg border_enable;
 reg [31:0] src_ptr,dst_ptr,row_x,row_y;
 reg [4:0] burst_beats,read_index,write_index;
 reg [63:0] burst_data[0:15];
 reg [7:0] burst_mask[0:15];
 integer next_beats,src_boundary,dst_boundary,lane;
 reg [31:0] validation_error,pixel_x;
 reg [63:0] read_word;
 reg [7:0] read_mask;
 reg pixel_inside,pixel_border;

 always @* begin
  validation_error=0;
  if(WIDTH<4 || WIDTH%4!=0 || HEIGHT<1 || FRAME_BYTES>64'h100000000) validation_error=6;
  else if(cfg_src[2:0]!=0 || cfg_dst[2:0]!=0) validation_error=1;
  else if({32'b0,cfg_src}+FRAME_BYTES>64'h100000000 ||
          {32'b0,cfg_dst}+FRAME_BYTES>64'h100000000) validation_error=2;
  else if({32'b0,cfg_src}<{32'b0,cfg_dst}+FRAME_BYTES &&
          {32'b0,cfg_dst}<{32'b0,cfg_src}+FRAME_BYTES) validation_error=3;
  else if(cfg_size==0 || cfg_size>WIDTH || cfg_size>HEIGHT ||
          cfg_x>WIDTH-cfg_size || cfg_y>HEIGHT-cfg_size) validation_error=4;
  else if(cfg_flags[31:1]!=0) validation_error=5;
  next_beats=(WIDTH-row_x)/4;
  if(next_beats>16)next_beats=16;
  src_boundary=(4096-{20'b0,src_ptr[11:0]})/8;
  dst_boundary=(4096-{20'b0,dst_ptr[11:0]})/8;
  if(next_beats>src_boundary)next_beats=src_boundary;
  if(next_beats>dst_boundary)next_beats=dst_boundary;
 end
 assign s_axi_awready=!aw_held&&!s_axi_bvalid;
 assign s_axi_wready=!w_held&&!s_axi_bvalid;
 assign s_axi_arready=!s_axi_rvalid;
 assign m_axi_araddr=src_ptr;
 assign m_axi_awaddr=dst_ptr;
 assign m_axi_arlen={3'b0,burst_beats}-8'd1;
 assign m_axi_awlen={3'b0,burst_beats}-8'd1;
 assign m_axi_arsize=3;assign m_axi_awsize=3;
 assign m_axi_arburst=1;assign m_axi_awburst=1;
 assign m_axi_arlock=0;assign m_axi_awlock=0;
 // Non-bufferable writes: completion must not acknowledge an intermediate
 // write buffer before the published frame can be read by the display master.
 assign m_axi_arcache=4'b0010;assign m_axi_awcache=4'b0010;
 assign m_axi_arprot=0;assign m_axi_awprot=0;
 assign m_axi_arqos=0;assign m_axi_awqos=0;
 assign m_axi_arvalid=state==READ_ADDRESS;
 assign m_axi_rready=state==READ_DATA;
 assign m_axi_awvalid=state==WRITE_ADDRESS;
 assign m_axi_wvalid=state==WRITE_DATA;
 assign m_axi_wdata=burst_data[write_index[3:0]];
 assign m_axi_wstrb=burst_mask[write_index[3:0]];
 assign m_axi_wlast=write_index==burst_beats-1;
 assign m_axi_bready=state==WRITE_RESPONSE;

 always @(posedge aclk) begin
  if(!aresetn)begin
   state<=IDLE;busy<=0;done<=0;error_code<=0;
   aw_held<=0;w_held<=0;address<=0;data<=0;strobes<=0;
   s_axi_bvalid<=0;s_axi_bresp<=0;s_axi_rvalid<=0;s_axi_rresp<=0;s_axi_rdata<=0;
   cfg_src<=0;cfg_dst<=0;cfg_x<=0;cfg_y<=0;cfg_size<=0;cfg_flags<=0;
   roi_x<=0;roi_y<=0;roi_size<=0;border_enable<=0;
   src_ptr<=0;dst_ptr<=0;row_x<=0;row_y<=0;
   burst_beats<=1;read_index<=0;write_index<=0;
  end else begin
   if(s_axi_bvalid&&s_axi_bready)s_axi_bvalid<=0;
   if(s_axi_rvalid&&s_axi_rready)s_axi_rvalid<=0;
   if(s_axi_awvalid&&s_axi_awready)begin address<=s_axi_awaddr;aw_held<=1;end
   if(s_axi_wvalid&&s_axi_wready)begin data<=s_axi_wdata;strobes<=s_axi_wstrb;w_held<=1;end
   if(aw_held&&w_held&&!s_axi_bvalid)begin
    aw_held<=0;w_held<=0;s_axi_bvalid<=1;s_axi_bresp<=2;
    if(strobes==4'hf&&!busy)case(address)
     12'h004:if(data==1)begin
      done<=0;error_code<=validation_error;
      if(validation_error!=0)done<=1;
      else begin
       roi_x<=cfg_x;roi_y<=cfg_y;roi_size<=cfg_size;border_enable<=cfg_flags[0];
       src_ptr<=cfg_src;dst_ptr<=cfg_dst;row_x<=0;row_y<=0;
       busy<=1;state<=PREPARE;s_axi_bresp<=0;
      end
     end
     12'h010:begin cfg_src<=data;s_axi_bresp<=0;end
     12'h014:begin cfg_dst<=data;s_axi_bresp<=0;end
     12'h018:begin cfg_x<=data;s_axi_bresp<=0;end
     12'h01c:begin cfg_y<=data;s_axi_bresp<=0;end
     12'h020:begin cfg_size<=data;s_axi_bresp<=0;end
     12'h024:begin cfg_flags<=data;s_axi_bresp<=0;end
     default:begin end
    endcase
   end
   if(s_axi_arvalid&&s_axi_arready)begin
    s_axi_rvalid<=1;s_axi_rresp<=0;
    case(s_axi_araddr)
     12'h000:s_axi_rdata<=32'h524f4931;
     12'h004:s_axi_rdata<={30'b0,done,busy};
     12'h008:s_axi_rdata<=error_code;
     12'h010:s_axi_rdata<=cfg_src;
     12'h014:s_axi_rdata<=cfg_dst;
     12'h018:s_axi_rdata<=cfg_x;
     12'h01c:s_axi_rdata<=cfg_y;
     12'h020:s_axi_rdata<=cfg_size;
     12'h024:s_axi_rdata<=cfg_flags;
     default:begin s_axi_rdata<=0;s_axi_rresp<=2;end
    endcase
   end
   case(state)
    PREPARE:begin
     burst_beats<=next_beats;read_index<=0;write_index<=0;state<=READ_ADDRESS;
    end
    READ_ADDRESS:if(m_axi_arready)state<=READ_DATA;
    READ_DATA:if(m_axi_rvalid)begin
     // Always drain through RLAST, even after RRESP or framing failure.
     if(m_axi_rresp!=0&&error_code==0)error_code<=16;
     if(m_axi_rlast!=(read_index==burst_beats-1)&&error_code==0)error_code<=18;
     if(read_index<burst_beats)begin
      read_word=m_axi_rdata;read_mask=0;
      for(lane=0;lane<4;lane=lane+1)begin
       pixel_x=row_x+read_index*4+lane;
       pixel_inside=pixel_x>=roi_x&&pixel_x<roi_x+roi_size&&row_y>=roi_y&&row_y<roi_y+roi_size;
       pixel_border=pixel_inside&&border_enable&&
        ((pixel_x-roi_x<2)||(roi_x+roi_size-1-pixel_x<2)||
         (row_y-roi_y<2)||(roi_y+roi_size-1-row_y<2));
       if(!pixel_inside||pixel_border)read_mask[lane*2+:2]=2'b11;
       if(pixel_border)read_word[lane*16+:16]=16'd1023;
      end
      burst_data[read_index[3:0]]<=read_word;
      burst_mask[read_index[3:0]]<=read_mask;
     end
     if(read_index<16)read_index<=read_index+1;
     if(m_axi_rlast)begin
      if(error_code!=0||m_axi_rresp!=0||read_index!=burst_beats-1)begin
       busy<=0;done<=1;state<=IDLE;
      end else state<=WRITE_ADDRESS;
     end
    end
    WRITE_ADDRESS:if(m_axi_awready)state<=WRITE_DATA;
    WRITE_DATA:if(m_axi_wready)begin
     if(write_index==burst_beats-1)state<=WRITE_RESPONSE;
     else write_index<=write_index+1;
    end
    WRITE_RESPONSE:if(m_axi_bvalid)begin
     if(m_axi_bresp!=0)begin error_code<=17;busy<=0;done<=1;state<=IDLE;end
     else if(row_y==HEIGHT-1&&row_x+burst_beats*4==WIDTH)begin
      busy<=0;done<=1;state<=IDLE;
     end else begin
      src_ptr<=src_ptr+burst_beats*8;dst_ptr<=dst_ptr+burst_beats*8;
      if(row_x+burst_beats*4==WIDTH)begin row_x<=0;row_y<=row_y+1;end
      else row_x<=row_x+burst_beats*4;
      state<=PREPARE;
     end
    end
    default:begin end
   endcase
  end
 end
endmodule
