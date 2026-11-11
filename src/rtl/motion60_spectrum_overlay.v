// V15 OSD2: atomic 256-word packet, committed at VSYNC.
// 0..128: axis heights/peak flag. 129..236: six 36-character rows.
// 237..251: five six-character frequency ticks. 252..254: "NN P/P".
// 255: measured sample frequency in 0.01 Hz. RGB and sync latency: 3 clocks.
module motion60_spectrum_overlay #(parameter ROI_X=512,ROI_Y=272,ROI_SIZE=256,ROI_BORDER=2)(
 input wire pixel_clk,resetn,input wire [11:0] x,y,input wire [23:0] rgb_in,
 input wire hsync_in,vsync_in,de_in,write_valid,
 input wire [7:0] write_bin,write_dx,write_dy,output wire write_ready,
 input wire commit,overlay_enable,input wire [1:0] signal_state,
 output reg commit_accepted,commit_rejected,commit_done,
 output reg [23:0] rgb_out,output reg hsync_out,vsync_out,de_out
);
 // One synchronous read and one write port per bank; no wide asynchronous mux.
 (* ram_style="block" *) reg [15:0] bins0[0:255],bins1[0:255];
 reg active_bank,pending,vsync_previous,enable_active,enable_pending;
 reg [255:0] written;reg [7:0] stale_frames;
 reg [1:0] state_active,state_pending;
 wire frame_boundary=vsync_in&&!vsync_previous;
 assign write_ready=!pending;
 wire roi_outer=x>=ROI_X-ROI_BORDER&&x<ROI_X+ROI_SIZE+ROI_BORDER&&y>=ROI_Y-ROI_BORDER&&y<ROI_Y+ROI_SIZE+ROI_BORDER;
 wire roi_inner=x>=ROI_X&&x<ROI_X+ROI_SIZE&&y>=ROI_Y&&y<ROI_Y+ROI_SIZE;
 wire chart_x=x>=1312&&x<1828;
 wire [11:0] local_x=x-12'd1312;
 wire [11:0] local_y=y-12'd624;
 wire [5:0] column=local_x[9:4];
 wire [2:0] row=local_y[7:5];
 wire [7:0] text_position=({5'b0,row}<<5)+({5'b0,row}<<2)+{2'b0,column};
 wire [2:0] axis_segment=local_x[9:7];
 wire [3:0] axis_column=local_x[6:3];
 wire [4:0] axis_word=({2'b0,axis_segment}<<1)+{2'b0,axis_segment}+{2'b0,axis_column[3:1]};
 reg [7:0] address,character;
 reg [287:0] line_text;
 reg [23:0] background,ink;
 reg text_on,payload,byte_high;
 reg [3:0] gx,gy;
 reg [1:0] plot;
 reg [7:0] level;
 reg [15:0] read0,read1;
 reg s1_bank,s1_payload,s1_high,s1_text,s1_roi,s1_half,s1_needle;
 reg [1:0] s1_plot;
 reg [7:0] s1_level,s1_character;
 reg [5:0] s1_bit;
 reg [23:0] s1_background,s1_ink;
 reg s1_hs,s1_vs,s1_de;
 reg [34:0] s2_glyph;
 reg [5:0] s2_bit;
 reg [23:0] s2_background,s2_ink;
 reg s2_text,s2_roi,s2_hs,s2_vs,s2_de;
 wire [15:0] fetched=s1_bank?read1:read0;
 wire [7:0] decoded=s1_payload?(s1_high?fetched[15:8]:fetched[7:0]):s1_character;
 wire [6:0] maximum=fetched[6:0]>fetched[14:8]?fetched[6:0]:fetched[14:8];
 wire [7:0] needle_height={1'b0,maximum}+{2'b0,maximum[6:1]};
 reg [23:0] plot_background;
 function [34:0] font;
 input [7:0] c;reg [34:0] glyph;
 begin
  case(c)
    8'd48:glyph=35'b01110100011001110101110011000101110;
    8'd49:glyph=35'b00100011000010000100001000010001110;
    8'd50:glyph=35'b01110100010000100010001000100011111;
    8'd51:glyph=35'b11110000010000101110000010000111110;
    8'd52:glyph=35'b00010001100101010010111110001000010;
    8'd53:glyph=35'b11111100001000011110000010000111110;
    8'd54:glyph=35'b01110100001000011110100011000101110;
    8'd55:glyph=35'b11111000010001000100010000100001000;
    8'd56:glyph=35'b01110100011000101110100011000101110;
    8'd57:glyph=35'b01110100011000101111000010000101110;
    8'd65:glyph=35'b01110100011000111111100011000110001;
    8'd66:glyph=35'b11110100011000111110100011000111110;
    8'd67:glyph=35'b01111100001000010000100001000001111;
    8'd68:glyph=35'b11110100011000110001100011000111110;
    8'd69:glyph=35'b11111100001000011110100001000011111;
    8'd70:glyph=35'b11111100001000011110100001000010000;
    8'd71:glyph=35'b01111100001000010111100011000101111;
    8'd72:glyph=35'b10001100011000111111100011000110001;
    8'd73:glyph=35'b01110001000010000100001000010001110;
    8'd74:glyph=35'b00111000100001000010100101001001100;
    8'd75:glyph=35'b10001100101010011000101001001010001;
    8'd76:glyph=35'b10000100001000010000100001000011111;
    8'd77:glyph=35'b10001110111010110101100011000110001;
    8'd78:glyph=35'b10001110011010110011100011000110001;
    8'd79:glyph=35'b01110100011000110001100011000101110;
    8'd80:glyph=35'b11110100011000111110100001000010000;
    8'd81:glyph=35'b01110100011000110001101011001001101;
    8'd82:glyph=35'b11110100011000111110101001001010001;
    8'd83:glyph=35'b01111100001000001110000010000111110;
    8'd84:glyph=35'b11111001000010000100001000010000100;
    8'd85:glyph=35'b10001100011000110001100011000101110;
    8'd86:glyph=35'b10001100011000110001100010101000100;
    8'd87:glyph=35'b10001100011000110101101011010101010;
    8'd88:glyph=35'b10001100010101000100010101000110001;
    8'd89:glyph=35'b10001100010101000100001000010000100;
    8'd90:glyph=35'b11111000010001000100010001000011111;
    8'd46:glyph=35'b00000000000000000000000000011000110;
    8'd37:glyph=35'b11001110100010000100010001011000110;
    8'd47:glyph=35'b00001000100001000100010000100010000;
    8'd45:glyph=35'b00000000000000011111000000000000000;
    8'd58:glyph=35'b00000001100011000000001100011000000;
   default:glyph=0;
  endcase
  font=glyph;
 end
 endfunction
 // Stage 1: classify the pixel and select exactly one packet word.
 // Numeric tick conversion is performed at publication time by the display
 // formatter, never in the per-pixel clock path.
 always @* begin
  address=0;character=32;line_text=0;background=rgb_in;ink=24'hdce7ee;
  text_on=0;payload=0;byte_high=0;gx=local_x[3:0];gy=y[3:0];plot=0;level=0;
  if(de_in&&enable_active)begin
   if(x>=1296&&x<1904&&y>=32&&y<960)background=24'h101922;
   if(chart_x&&((y>=144&&y<336)||(y>=416&&y<544)))begin
    background=24'h081017;address=local_x[9:2];
    if(local_x[6:0]==0||y==335||y==543||y==144||y==416)background=24'h304452;
    if(state_active==1)begin
     if(y>=416)begin plot=2;level=12'd544-y;end
     else begin plot=1;level=12'd336-y;end
    end
   end
   if(x>=1312&&x<1888)begin
    if(y>=48&&y<64)begin line_text="VIBRATION SPECTRUM                  ";text_on=1;ink=24'hffffff;end
    if(y>=80&&y<96)begin
     text_on=1;
     case(state_active)
      0:begin line_text="MEASURING - FILLING 256 SAMPLES     ";ink=24'ha0b3c0;end
      1:begin line_text="LIVE - INPUT ROI / RELATIVE SPECTRUM";ink=24'h6ef0b0;end
      2:begin line_text="LOW TEXTURE - ALIGN ROI             ";ink=24'hffb040;end
      3:begin line_text="DATA INVALID - WAITING FOR RECOVERY ";ink=24'hff7070;end
     endcase
    end
    if(y>=112&&y<128)begin line_text="AC COMPONENTS - MAX X/Y             ";text_on=1;ink=24'h6ef0b0;end
    if(y>=384&&y<400)begin line_text="FULL FFT  X CYAN / Y AMBER          ";text_on=1;end
    if(y>=576&&y<592)begin line_text="FREQUENCY / RELATIVE BIN AMPLITUDE  ";text_on=1;end
    if(y>=864&&y<880)begin line_text="PEAK GATE: 3% MAX / 6X MEDIAN       ";text_on=1;ink=24'h8ca0ae;end
    if(y>=896&&y<912)begin line_text="UNRESOLVED / WEAK BINS SHOWN ABOVE  ";text_on=1;ink=24'h8ca0ae;end
    if(y>=624&&y<816&&local_y[4:0]<16&&state_active==1)begin
     address=8'd129+{1'b0,text_position[7:1]};byte_high=text_position[0];payload=1;text_on=1;
     if(row>0)ink=24'h6ef0b0;
    end
    if(y>=816&&y<832&&state_active==1)begin
     line_text="PEAKS 00  PAGE 0/0  REL BIN %       ";text_on=1;
     case(column)
      6:begin address=252;payload=1;byte_high=0;end
      7:begin address=252;payload=1;byte_high=1;end
      15:begin address=253;payload=1;byte_high=1;end
      17:begin address=254;payload=1;byte_high=1;end
     endcase
    end
    if(text_on&&!payload)character=line_text[287-{column,3'b000} -: 8];
   end
   if(x>=1312&&x<1872&&((y>=352&&y<360)||(y>=552&&y<560))&&state_active==1)begin
    text_on=axis_segment<=4&&axis_column<6;
    address=8'd237+{3'b0,axis_word};byte_high=axis_column[0];payload=1;
    gx={local_x[2:0],1'b0};gy={y[2:0],1'b0};ink=24'hb8c9d5;
   end
  end
 end
 always @* begin
  plot_background=s1_background;
  if(s1_plot==2)begin
   if(fetched[6:0]!=0&&s1_level<={1'b0,fetched[6:0]})plot_background=24'h00d8ff;
   if(fetched[14:8]!=0&&s1_level<={1'b0,fetched[14:8]}&&s1_half)plot_background=24'hffb040;
  end
  if(s1_plot==1&&fetched[7]&&s1_needle&&s1_level<=needle_height)plot_background=24'h6ef0b0;
 end
 // Synchronous memory reads deliberately have no reset, enabling BRAM inference.
 // Reset masks both later stages, so uninitialised bank contents cannot display.
 always @(posedge pixel_clk)begin read0<=bins0[address];read1<=bins1[address];end
 always @(posedge pixel_clk)begin
  if(!resetn)begin
   s1_bank<=0;s1_payload<=0;s1_high<=0;s1_text<=0;s1_roi<=0;s1_half<=0;s1_needle<=0;
   s1_plot<=0;s1_level<=0;s1_character<=32;s1_bit<=0;s1_background<=0;s1_ink<=0;s1_hs<=0;s1_vs<=0;s1_de<=0;
   s2_glyph<=0;s2_bit<=0;s2_background<=0;s2_ink<=0;s2_text<=0;s2_roi<=0;s2_hs<=0;s2_vs<=0;s2_de<=0;
   rgb_out<=0;hsync_out<=0;vsync_out<=0;de_out<=0;
  end else begin
   s1_bank<=active_bank;s1_payload<=payload;s1_high<=byte_high;s1_character<=character;
   s1_text<=text_on&&gx<10&&gy<14;s1_bit<=6'd34-({3'b0,gy[3:1]}<<2)-{3'b0,gy[3:1]}-{3'b0,gx[3:1]};
   // The fixed red square belongs to the spectrum panel (VIEW 2). The local
   // magnification outline is already composed into the image independently.
   s1_background<=background;s1_ink<=ink;s1_roi<=de_in&&enable_active&&roi_outer&&!roi_inner;
   s1_plot<=plot;s1_level<=level;s1_half<=x[1];s1_needle<=!x[1];
   s1_hs<=hsync_in;s1_vs<=vsync_in;s1_de<=de_in;
   s2_glyph<=font(decoded);s2_bit<=s1_bit;s2_background<=plot_background;s2_ink<=s1_ink;
   s2_text<=s1_text;s2_roi<=s1_roi;s2_hs<=s1_hs;s2_vs<=s1_vs;s2_de<=s1_de;
   rgb_out<=s2_roi?24'hff0000:((s2_text&&s2_glyph[s2_bit])?s2_ink:s2_background);
   hsync_out<=s2_hs;vsync_out<=s2_vs;de_out<=s2_de;
  end
 end
 always @(posedge pixel_clk)begin
  if(!resetn)begin
   active_bank<=0;pending<=0;written<=0;vsync_previous<=0;stale_frames<=0;
   enable_active<=0;enable_pending<=0;state_active<=0;state_pending<=0;
   commit_accepted<=0;commit_rejected<=0;commit_done<=0;
  end else begin
   vsync_previous<=vsync_in;commit_accepted<=0;commit_rejected<=0;commit_done<=0;
   if(frame_boundary&&state_active==1)begin
    if(stale_frames==59)state_active<=3;else stale_frames<=stale_frames+1'b1;
   end
   if(write_valid&&write_ready)begin
    if(active_bank)bins0[write_bin]<={write_dy,write_dx};else bins1[write_bin]<={write_dy,write_dx};
    written[write_bin]<=1;
   end
   if(commit)begin
    if(!pending&&(&written))begin
     pending<=1;enable_pending<=overlay_enable;state_pending<=signal_state;commit_accepted<=1;
    end else commit_rejected<=1;
   end
   if(pending&&frame_boundary)begin
    active_bank<=!active_bank;pending<=0;written<=0;stale_frames<=0;
    enable_active<=enable_pending;state_active<=state_pending;commit_done<=1;
   end
  end
 end
endmodule
