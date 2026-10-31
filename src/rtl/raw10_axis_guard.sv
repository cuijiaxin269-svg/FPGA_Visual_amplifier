// Non-stallable source -> elastic AXIS register. Drop a damaged remainder until SOF.
// A partial frame already in DDR must be invalidated; counters never imply DMA completion.
module raw10_axis_guard #(parameter integer WIDTH=1280, HEIGHT=800)(
 input wire clk, resetn, enable, packet_error, frame_end,
 input wire [39:0] pixels, input wire valid, sof, eol,
 output reg [63:0] m_axis_tdata, output wire [7:0] m_axis_tkeep,
 output reg m_axis_tvalid, output reg m_axis_tuser, m_axis_tlast,
 input wire m_axis_tready,
 output reg [31:0] frames, shape_frames, drops, shape_errors,
 output reg [31:0] last_interval, timestamp_lo, timestamp_hi
);
 reg dropping, active; integer x,y;
 reg [63:0] ticks, last_sof;
 wire slot_ready=!m_axis_tvalid || m_axis_tready;
 assign m_axis_tkeep=8'hff;
 always @(posedge clk) begin
  if(!resetn) begin
   m_axis_tdata<=0; m_axis_tvalid<=0; m_axis_tuser<=0; m_axis_tlast<=0;
   frames<=0; shape_frames<=0; drops<=0; shape_errors<=0;
   last_interval<=0; timestamp_lo<=0; timestamp_hi<=0;
   ticks<=0; last_sof<=0; dropping<=1; active<=0; x=0;y=0;
  end else begin
   ticks<=ticks+1;
   if(m_axis_tready) m_axis_tvalid<=0;
   if(!enable) begin dropping<=1; active<=0; end
   if(frame_end && active && !dropping) begin
    shape_errors<=shape_errors+1; drops<=drops+1; dropping<=1; active<=0;
   end
   if(packet_error) begin
    if(active && !dropping) drops<=drops+1;
    dropping<=1; active<=0;
   end
   if(valid && enable && !packet_error) begin
    if(sof) begin
     frames<=frames+1; last_interval<=ticks-last_sof; last_sof<=ticks;
     timestamp_lo<=ticks[31:0]; timestamp_hi<=ticks[63:32];
     if(active && !dropping) begin shape_errors<=shape_errors+1; drops<=drops+1; end
     x=0;y=0; active<=1; dropping<=!slot_ready;
    end
    if(sof || (active && !dropping)) begin
     if(!slot_ready) begin
      if(sof || !dropping) drops<=drops+1;
      dropping<=1; active<=0;
     end else if((eol!=(x==WIDTH-4)) || x>=WIDTH || y>=HEIGHT) begin
      shape_errors<=shape_errors+1; drops<=drops+1; dropping<=1; active<=0;
     end else begin
      for(integer p=0;p<4;p=p+1) m_axis_tdata[p*16 +: 16]<={6'b0,pixels[p*10 +: 10]};
      m_axis_tvalid<=1; m_axis_tuser<=sof; m_axis_tlast<=eol;
      if(eol) begin
       x=0;
       if(y==HEIGHT-1) begin shape_frames<=shape_frames+1; active<=0; end
       y=y+1;
      end else x=x+4;
     end
    end
   end
  end
 end
endmodule
