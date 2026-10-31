// AXI4-Lite register endpoint, clocked in the SAME domain as the renderer.
// Integrate through an AXI clock converter when PS/control clocks differ.
// 00 ID, 04 ready/waiting, 08 bin {reserved,dy,dx,index}, 0c commit {state,enable}
// 10 accepted, 14 displayed, 18 rejected commits, 20 frames, 24 underruns, 28 framing.
module motion60_overlay_control(
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 aclk CLK", X_INTERFACE_PARAMETER="ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET aresetn" *) input wire aclk,
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
 output reg write_valid,
 output reg [7:0] write_bin,write_dx,write_dy,
 input wire write_ready,
 output reg commit,overlay_enable,
 output reg [1:0] signal_state,
 input wire commit_accepted,commit_rejected,commit_done,
 input wire [31:0] display_frames,underflows,framing_errors
);
 reg aw_held,w_held,waiting_commit;
 reg [11:0] address;
 reg [31:0] data;
 reg [3:0] strobes;
 reg [31:0] accepted_count,done_count,rejected_count;
 assign s_axi_awready=!aw_held&&!waiting_commit&&!s_axi_bvalid;
 assign s_axi_wready=!w_held&&!waiting_commit&&!s_axi_bvalid;
 assign s_axi_arready=!s_axi_rvalid;
 always @(posedge aclk) begin
  if(!aresetn) begin
   aw_held<=0;w_held<=0;waiting_commit<=0;address<=0;data<=0;strobes<=0;
   s_axi_bvalid<=0;s_axi_bresp<=0;s_axi_rvalid<=0;s_axi_rdata<=0;s_axi_rresp<=0;
   write_valid<=0;write_bin<=0;write_dx<=0;write_dy<=0;
   commit<=0;overlay_enable<=0;signal_state<=0;
   accepted_count<=0;done_count<=0;rejected_count<=0;
  end else begin
   write_valid<=0;commit<=0;
   if(commit_accepted)accepted_count<=accepted_count+1;
   if(commit_done)done_count<=done_count+1;
   if(commit_rejected)rejected_count<=rejected_count+1;
   if(s_axi_bvalid&&s_axi_bready)s_axi_bvalid<=0;
   if(s_axi_rvalid&&s_axi_rready)s_axi_rvalid<=0;
   if(s_axi_awvalid&&s_axi_awready)begin address<=s_axi_awaddr;aw_held<=1;end
   if(s_axi_wvalid&&s_axi_wready)begin data<=s_axi_wdata;strobes<=s_axi_wstrb;w_held<=1;end
   if(aw_held&&w_held&&!waiting_commit&&!s_axi_bvalid)begin
    aw_held<=0;w_held<=0;s_axi_bresp<=2;s_axi_bvalid<=1;
    // Partial writes are explicitly rejected; no stale-byte command merging.
    if(strobes==4'hf)case(address)
     12'h008:if(write_ready&&data[31:24]==0)begin
      write_bin<=data[7:0];write_dx<=data[15:8];write_dy<=data[23:16];
      write_valid<=1;s_axi_bresp<=0;
     end
     12'h00c:if(data[31:3]==0)begin
      overlay_enable<=data[0];signal_state<=data[2:1];commit<=1;
      waiting_commit<=1;s_axi_bvalid<=0;
     end
     default:begin end
    endcase
   end
   // Respond only after the renderer has accepted/rejected the snapshot.
   if(waiting_commit&&(commit_accepted||commit_rejected))begin
    waiting_commit<=0;s_axi_bvalid<=1;s_axi_bresp<=commit_accepted?0:2;
   end
   if(s_axi_arvalid&&s_axi_arready)begin
    s_axi_rvalid<=1;s_axi_rresp<=0;
    case(s_axi_araddr)
     12'h000:s_axi_rdata<=32'h4f534432;
     12'h004:s_axi_rdata<={30'b0,waiting_commit,write_ready};
     12'h010:s_axi_rdata<=accepted_count;
     12'h014:s_axi_rdata<=done_count;
     12'h018:s_axi_rdata<=rejected_count;
     12'h020:s_axi_rdata<=display_frames;
     12'h024:s_axi_rdata<=underflows;
     12'h028:s_axi_rdata<=framing_errors;
     default:begin s_axi_rdata<=0;s_axi_rresp<=2;end
    endcase
   end
  end
 end
endmodule
