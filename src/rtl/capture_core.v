// Vivado BD module-reference tops must be Verilog or VHDL, not SystemVerilog.
module capture_core #(parameter integer AMD_PHY=0)(
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME clk, ASSOCIATED_BUSIF s_axis:m_axis, ASSOCIATED_RESET resetn, FREQ_HZ 100000000" *)
 input wire clk, input wire resetn,
 input wire [31:0] control, output wire [31:0] status,
 input wire [31:0] s_axis_tdata, input wire [3:0] s_axis_tkeep,
 input wire s_axis_tvalid, s_axis_tlast, output wire s_axis_tready,
 output wire [63:0] m_axis_tdata, output wire [7:0] m_axis_tkeep,
 output wire m_axis_tvalid, m_axis_tlast, m_axis_tuser, input wire m_axis_tready,
 input wire phy_fault_async, input wire mclk_locked,
 input wire [5:0] phy_lp_async, input wire phy_byteclk, input wire phy_clock_active_async,
 output wire mclk_enable
);
 capture_core_impl #(.AMD_PHY(AMD_PHY)) impl(.clk(clk),.resetn(resetn),.control(control),.status(status),
 .s_axis_tdata(s_axis_tdata),.s_axis_tkeep(s_axis_tkeep),.s_axis_tvalid(s_axis_tvalid),.s_axis_tlast(s_axis_tlast),.s_axis_tready(s_axis_tready),
 .m_axis_tdata(m_axis_tdata),.m_axis_tkeep(m_axis_tkeep),.m_axis_tvalid(m_axis_tvalid),.m_axis_tlast(m_axis_tlast),.m_axis_tuser(m_axis_tuser),.m_axis_tready(m_axis_tready),
 .phy_fault_async(phy_fault_async),.mclk_locked(mclk_locked),.mclk_enable(mclk_enable),
 .phy_lp_async(phy_lp_async),.phy_byteclk(phy_byteclk),.phy_clock_active_async(phy_clock_active_async));
endmodule
