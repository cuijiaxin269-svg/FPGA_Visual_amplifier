// V15: coherent 256-word display packet, committed at VSYNC.
// 0..128: two 7-bit relative axis heights; bit7 marks a resolved AC peak.
// 129..254: 252 ASCII bytes; 255: measured sample frequency in 0.01 Hz.
module reference_spectrum_overlay #(parameter ROI_X=512,ROI_Y=272,ROI_SIZE=256,ROI_BORDER=2)(
 input wire pixel_clk,resetn,input wire [11:0] x,y,input wire [23:0] rgb_in,
 input wire hsync_in,vsync_in,de_in,write_valid,
 input wire [7:0] write_bin,write_dx,write_dy,output wire write_ready,
 input wire commit,overlay_enable,input wire [1:0] signal_state,
 output reg commit_accepted,commit_rejected,commit_done,
 output reg [23:0] rgb_out,output reg hsync_out,vsync_out,de_out
);
 reg [15:0] bins0[0:255],bins1[0:255];
 reg active_bank,pending,vsync_previous,enable_active,enable_pending;
 reg [255:0] written;
 reg [7:0] stale_frames;
 reg [1:0] state_active,state_pending;
 wire frame_boundary=vsync_in&&!vsync_previous;
 assign write_ready=!pending;
 wire roi_outer=x>=ROI_X-ROI_BORDER&&x<ROI_X+ROI_SIZE+ROI_BORDER&&y>=ROI_Y-ROI_BORDER&&y<ROI_Y+ROI_SIZE+ROI_BORDER;
 wire roi_inner=x>=ROI_X&&x<ROI_X+ROI_SIZE&&y>=ROI_Y&&y<ROI_Y+ROI_SIZE;
 wire chart_x=x>=1312&&x<1828;
 wire [7:0] bin_index=(x-1312)>>2;
 reg [15:0] heights,textword,nyquist;
 reg [23:0] composed,ink;
 reg [7:0] character;
 reg [34:0] glyph;
 reg [287:0] line_text;
 integer column,row,position,gx,gy,value,axis_segment,axis_column,local_x;
 reg text_on;
 function [34:0] font;
 input [7:0] c;
 reg [34:0] glyph;
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
 always @* begin
  heights=0;textword=0;nyquist=0;composed=rgb_in;ink=24'hdce7ee;
  character=32;glyph=0;line_text=0;text_on=0;
  column=0;row=0;position=0;gx=0;gy=0;value=0;axis_segment=0;axis_column=0;local_x=0;
  if(enable_active&&state_active==1)begin
   if(chart_x)heights=active_bank?bins1[bin_index]:bins0[bin_index];
   nyquist=active_bank?bins1[255]:bins0[255];
  end
  if(de_in&&enable_active)begin
   if(x>=1296&&x<1904&&y>=32&&y<960)composed=24'h101922;
   if(chart_x&&((y>=144&&y<336)||(y>=416&&y<544)))begin
    composed=24'h081017;
    if((x-1312)%128==0||y==335||y==543||y==144||y==416)composed=24'h304452;
    if(state_active==1)begin
     // All raw bins remain visible on a shared relative scale.
     if(y>=416&&y<544)begin
      if(heights[6:0]!=0&&y>=544-heights[6:0])composed=24'h00d8ff;
      if(heights[14:8]!=0&&y>=544-heights[14:8]&&x[1])composed=24'hffb040;
     end
     if(y>=144&&y<336&&heights[7]&&x[1:0]<2)begin
      if(y>=336-((heights[6:0]>heights[14:8]?heights[6:0]:heights[14:8])*3/2))composed=24'h6ef0b0;
     end
    end
   end
   if(x>=1312&&x<1888)begin
    column=(x-1312)>>4;gx=(x-1312)&15;gy=y&15;
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
    if(text_on)character=line_text[287-column*8 -: 8];
    if(y>=624&&y<848&&((y-624)&31)<16&&state_active==1)begin
     row=(y-624)>>5;position=row*36+column;
     textword=active_bank?bins1[129+(position>>1)]:bins0[129+(position>>1)];
     character=position[0]?textword[15:8]:textword[7:0];text_on=1;
     if(row>0&&row<6)ink=24'h6ef0b0;
    end
   end
   // Small labels centered on each measured-frequency grid line (Hz).
   if(x>=1312&&x<1872&&((y>=352&&y<360)||(y>=552&&y<560))&&state_active==1)begin
    local_x=x-1312;axis_segment=local_x>>7;axis_column=(local_x&127)>>3;
    if(axis_segment<=4&&axis_column<6)begin
     value=(nyquist*axis_segment+40)/80;
     case(axis_column)
      0:character=48+value/100;
      1:character=48+(value/10)%10;
      2:character=46;
      3:character=48+value%10;
      4:character=72;
      5:character=90;
     endcase
     gx=(local_x&7)*2;gy=(y&7)*2;text_on=1;ink=24'hb8c9d5;
    end else text_on=0;
   end
   glyph=font(character);
   if(text_on&&gx<10&&gy<14&&glyph[34-(gy>>1)*5-(gx>>1)])composed=ink;
  end
  if(de_in&&roi_outer&&!roi_inner)composed=24'hff0000;
 end
 always @(posedge pixel_clk)begin
  if(!resetn)begin
   active_bank<=0;pending<=0;written<=0;vsync_previous<=0;stale_frames<=0;
   enable_active<=0;enable_pending<=0;state_active<=0;state_pending<=0;
   commit_accepted<=0;commit_rejected<=0;commit_done<=0;
   rgb_out<=0;hsync_out<=0;vsync_out<=0;de_out<=0;
  end else begin
   vsync_previous<=vsync_in;commit_accepted<=0;commit_rejected<=0;commit_done<=0;
   // Firmware faults/stalls must not leave a frozen valid peak display.
   // Normal publication is 5 Hz; 60 display frames is about two seconds.
   if(frame_boundary&&state_active==1)begin
    if(stale_frames==59)state_active<=3;
    else stale_frames<=stale_frames+1'b1;
   end
   rgb_out<=composed;hsync_out<=hsync_in;vsync_out<=vsync_in;de_out<=de_in;
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
