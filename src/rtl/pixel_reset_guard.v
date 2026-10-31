// Candidate only: stop-clock-safe reset for the existing pixel consumers.
// The legacy proc_sys_reset sequencing remains a release qualification.
// No clock, serializer, video, DMA, software or address parameters change.
module pixel_reset_guard (
    (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 pixel_clk CLK",
       X_INTERFACE_PARAMETER="FREQ_HZ 74250000, ASSOCIATED_RESET resetn" *)
    input wire pixel_clk,
    input wire reset0_n,
    input wire locked,
    input wire legacy_resetn,
    (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 resetn RST",
       X_INTERFACE_PARAMETER="POLARITY ACTIVE_LOW" *)
    output wire resetn
);
    wire async_fault = !reset0_n || !locked || !legacy_resetn;

    // Every stage is a flip-flop, never an SRL. Assertion does not require
    // PixelClk; release requires sixteen running PixelClk capture edges.
    // The extra hold also absorbs a delayed legacy reset assertion after
    // PixelClk restarts. Any renewed fault restarts the entire hold period.
    (* ASYNC_REG="TRUE", SHREG_EXTRACT="NO" *)
    reg [15:0] release_pipeline = 16'b0;
    always @(posedge pixel_clk or posedge async_fault) begin
        if (async_fault)
            release_pipeline <= 16'b0;
        else
            release_pipeline <= {release_pipeline[14:0], 1'b1};
    end
    assign resetn = release_pipeline[15];
endmodule
