// Open-drain SCCB pass-through with GPIO readback and a diagnostic bit-bang mode.
// GPIO bits 0/1 are SDA/SCL; bit 2 selects GPIO when high. No MCLK/FSIN connection.
module sccb_bridge(
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 PS SCL_I" *) output wire ps_scl_i,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 PS SCL_O" *) input wire ps_scl_o,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 PS SCL_T" *) input wire ps_scl_t,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 PS SDA_I" *) output wire ps_sda_i,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 PS SDA_O" *) input wire ps_sda_o,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 PS SDA_T" *) input wire ps_sda_t,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 CAM SCL_I" *) input wire cam_scl_i,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 CAM SCL_O" *) output wire cam_scl_o,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 CAM SCL_T" *) output wire cam_scl_t,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 CAM SDA_I" *) input wire cam_sda_i,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 CAM SDA_O" *) output wire cam_sda_o,
 (* X_INTERFACE_INFO="xilinx.com:interface:iic:1.0 CAM SDA_T" *) output wire cam_sda_t,
 input wire [3:0] bb_data,bb_tri,
 input wire button_clk,key0_n,
 output wire [3:0] levels
);
 // KEY0 is asynchronous, pulled up on the dock, and active low. EMIO bit 3
 // is input-only; the existing SDA/SCL/select outputs retain bits 0/1/2.
 // No PL capture reset here: camera restarts must not fabricate a key edge.
 (* ASYNC_REG="TRUE", SHREG_EXTRACT="NO" *) reg key_meta=1'b1;
 (* ASYNC_REG="TRUE", SHREG_EXTRACT="NO" *) reg key_sync=1'b1;
 always @(posedge button_clk) begin
  key_meta<=key0_n;
  key_sync<=key_meta;
 end
 assign ps_scl_i=cam_scl_i;
 assign ps_sda_i=cam_sda_i;
 assign cam_scl_o=bb_data[2]?1'b0:ps_scl_o;
 assign cam_sda_o=bb_data[2]?1'b0:ps_sda_o;
 assign cam_scl_t=bb_data[2]?bb_tri[1]:ps_scl_t;
 assign cam_sda_t=bb_data[2]?bb_tri[0]:ps_sda_t;
 assign levels={key_sync,1'b0,cam_scl_i,cam_sda_i};
endmodule
