// Independent FCLK health view remains accessible if the pixel clock stops.
// Only individual status bits cross domains; no multibit snapshot bus crosses.
module full_hdmi_health(
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 clk CLK", X_INTERFACE_PARAMETER="ASSOCIATED_RESET resetn" *) input wire clk,
 (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 resetn RST", X_INTERFACE_PARAMETER="POLARITY ACTIVE_LOW" *) input wire resetn,
 input wire pixel_clk,locked,pixel_resetn,selected_bars,snapshot_valid,frame_toggle,
 output wire [31:0] probe_id,health,
 output reg [31:0] heartbeat_age,fclk_count
);
 wire s_locked,s_resetn,s_selected,s_valid,s_toggle;
 xpm_cdc_single #(.DEST_SYNC_FF(2),.INIT_SYNC_FF(0),.SIM_ASSERT_CHK(1),.SRC_INPUT_REG(0))
  sync_locked(.src_clk(pixel_clk),.src_in(locked),.dest_clk(clk),.dest_out(s_locked));
 xpm_cdc_single #(.DEST_SYNC_FF(2),.INIT_SYNC_FF(0),.SIM_ASSERT_CHK(1),.SRC_INPUT_REG(0))
  sync_reset(.src_clk(pixel_clk),.src_in(pixel_resetn),.dest_clk(clk),.dest_out(s_resetn));
 xpm_cdc_single #(.DEST_SYNC_FF(2),.INIT_SYNC_FF(0),.SIM_ASSERT_CHK(1),.SRC_INPUT_REG(0))
  sync_selected(.src_clk(pixel_clk),.src_in(selected_bars),.dest_clk(clk),.dest_out(s_selected));
 xpm_cdc_single #(.DEST_SYNC_FF(2),.INIT_SYNC_FF(0),.SIM_ASSERT_CHK(1),.SRC_INPUT_REG(0))
  sync_valid(.src_clk(pixel_clk),.src_in(snapshot_valid),.dest_clk(clk),.dest_out(s_valid));
 xpm_cdc_single #(.DEST_SYNC_FF(2),.INIT_SYNC_FF(0),.SIM_ASSERT_CHK(1),.SRC_INPUT_REG(0))
  sync_frame(.src_clk(pixel_clk),.src_in(frame_toggle),.dest_clk(clk),.dest_out(s_toggle));
 reg last_toggle,first_lock_seen,loss_after_first_lock;
 // OBH2: history is sampled only in FCLK, through the existing s_locked CDC.
 // A zero history flag does not exclude a pulse missed by that synchronizer.
 assign probe_id=32'h4f424832;
 assign health={24'b0,loss_after_first_lock,first_lock_seen,s_toggle,s_valid,s_selected,resetn,s_resetn,s_locked};
 always @(posedge clk)begin
  if(!resetn)begin
   heartbeat_age<=0;fclk_count<=0;last_toggle<=0;
   first_lock_seen<=0;loss_after_first_lock<=0;
  end
  else begin
   if(s_locked)first_lock_seen<=1;
   if(first_lock_seen&&!s_locked)loss_after_first_lock<=1;
   fclk_count<=fclk_count+1;last_toggle<=s_toggle;
   if(s_toggle!=last_toggle)heartbeat_age<=0;
   else if(heartbeat_age!=32'hffffffff)heartbeat_age<=heartbeat_age+1;
  end
 end
endmodule
