// CSI-2 packet stream after LM+CDC. Header is one complete 32-bit beat.
// Payload uses contiguous TKEEP; TLAST marks end of an HS burst, after HS_Trail.
// One CSI-2 packet per burst. WC bounds payload/CRC; PHY trail samples are ignored.
module csi2_raw10_rx #(parameter integer WIDTH=1280)(
 input wire clk, resetn,
 input wire [31:0] s_data, input wire [3:0] s_keep,
 input wire s_valid, s_last,
 output reg [39:0] pixels, output reg valid, sof, eol,
 output reg frame_start, frame_end, packet_error,
 output reg [31:0] ecc_corrected, ecc_errors, crc_errors, format_errors, packets
);
 function automatic [5:0] ecc(input [23:0] d);
  begin
   ecc[0]=^(d & 24'hf12cb7); ecc[1]=^(d & 24'hf2555b);
   ecc[2]=^(d & 24'h749a6d); ecc[3]=^(d & 24'hb8e38e);
   ecc[4]=^(d & 24'hdf03f0); ecc[5]=^(d & 24'heffc00);
  end
 endfunction
 function automatic [15:0] crc_byte(input [15:0] c, input [7:0] b);
  reg [15:0] v; integer j;
  begin
   v=c;
   for(j=0;j<8;j=j+1) v=(v[0]^b[j]) ? ((v>>1)^16'h8408) : (v>>1);
   crc_byte=v;
  end
 endfunction
 // Register the FIFO's BRAM outputs before header/ECC and byte processing.
 reg [31:0] data_q; reg [3:0] keep_q; reg valid_q,last_q;
 always @(posedge clk) begin
  if(!resetn) begin data_q<=0;keep_q<=0;valid_q<=0;last_q<=0;end
  else begin data_q<=s_data;keep_q<=s_keep;valid_q<=s_valid;last_q<=s_last;end
 end
 reg [23:0] corrected_header;
 reg [5:0] syndrome;
 reg [7:0] byte_value,crc_low;
 reg [31:0] group_bytes;
 reg [15:0] crc,wc;
 reg [16:0] pos,index,next_pos;
 reg [5:0] dt;
 reg [1:0] vc;
 reg [2:0] group_pos;
 integer k,bit_index;
 reg header_ok,target,pending_sof,frame_active,crc_checked,bad;
 wire [16:0] payload_end={1'b0,wc}+17'd4;
 always @(posedge clk) begin
  if(!resetn) begin
   pixels<=0;valid<=0;sof<=0;eol<=0;frame_start<=0;frame_end<=0;packet_error<=0;
   ecc_corrected<=0;ecc_errors<=0;crc_errors<=0;format_errors<=0;packets<=0;
   pos=0;wc=0;dt=0;vc=0;group_pos=0;group_bytes=0;crc=16'hffff;crc_low=0;
   target=0;pending_sof=0;frame_active=0;crc_checked=0;bad=0;header_ok=0;
  end else begin
   valid<=0;sof<=0;eol<=0;frame_start<=0;frame_end<=0;packet_error<=0;
   if(valid_q) begin
    if(pos==0) begin
     corrected_header=data_q[23:0];syndrome=ecc(corrected_header)^data_q[29:24];
     header_ok=(data_q[31:30]==0 && keep_q==4'hf);
     if(syndrome!=0) begin
      bit_index=-1;
      for(integer b=0;b<24;b=b+1) if(ecc(24'b1<<b)==syndrome)bit_index=b;
      if(bit_index>=0)begin corrected_header[bit_index]=~corrected_header[bit_index];ecc_corrected<=ecc_corrected+1;end
      else if((syndrome & (syndrome-1))==0)ecc_corrected<=ecc_corrected+1;
      else header_ok=0;
     end
     if(!header_ok)begin ecc_errors<=ecc_errors+1;bad=1;packet_error<=1;frame_active=0;end
     wc=corrected_header[23:8];dt=corrected_header[5:0];vc=corrected_header[7:6];
     target=header_ok && vc==0 && dt==6'h2b && wc==WIDTH*5/4 && frame_active;
     if(header_ok && vc==0)begin
      if(dt==0)begin pending_sof=1;frame_active=1;frame_start<=1;end
      if(dt==1)begin frame_active=0;frame_end<=1;end
      if(dt==6'h2b && wc!=WIDTH*5/4)begin bad=1;packet_error<=1;format_errors<=format_errors+1;frame_active=0;end
     end
     pos=4;
    end else begin
     next_pos=pos;
     // The header and WC are stable from the previous beat. No header mux chain here.
     for(k=0;k<4;k=k+1) if(keep_q[k])begin
      index=pos+k;byte_value=data_q[k*8 +: 8];next_pos=next_pos+1'b1;
      if(dt>=16 && index<payload_end)begin
       crc=crc_byte(crc,byte_value);
       if(target)begin
        if(group_pos<4)begin group_bytes[group_pos*8 +: 8]=byte_value;group_pos=group_pos+1'b1;end
        else begin
         for(integer p=0;p<4;p=p+1)pixels[p*10 +: 10]<={group_bytes[p*8 +: 8],byte_value[p*2 +: 2]};
         valid<=1;sof<=pending_sof;pending_sof=0;eol<=(index==payload_end-1'b1);group_pos=0;
        end
       end
      end else if(dt>=16 && index==payload_end)crc_low=byte_value;
      else if(dt>=16 && index==payload_end+1'b1)begin
       crc_checked=1;
       if(header_ok && {byte_value,crc_low}!=crc)begin crc_errors<=crc_errors+1;packet_error<=1;bad=1;frame_active=0;end
      end
     end
     pos=next_pos;
    end
    if(last_q)begin
     packets<=packets+1;
     if(keep_q==0 || (keep_q & (keep_q+1))!=0 ||
        (header_ok && ((dt<16 && pos<4) || (dt>=16 && (pos<{1'b0,wc}+17'd6 || !crc_checked)))))begin
      if(!bad)format_errors<=format_errors+1;
      packet_error<=1;frame_active=0;
     end
     pos=0;crc=16'hffff;group_pos=0;target=0;header_ok=0;crc_checked=0;bad=0;
    end
   end
  end
 end
endmodule
