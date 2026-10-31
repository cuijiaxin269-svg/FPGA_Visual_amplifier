module capture_test_source #(parameter integer WIDTH=1280, HEIGHT=800, PERIOD=833333)(
 input wire clk, resetn, enable, checkerboard,
 output reg [39:0] pixels, output reg valid, sof, eol
);
 integer x,y,phase; reg [31:0] frame;
 always @(posedge clk) begin
  if(!resetn || !enable) begin x=0;y=0;phase=0;frame<=0;valid<=0;sof<=0;eol<=0;pixels<=0; end
  else begin
   valid<=0;sof<=0;eol<=0;
   if(phase<WIDTH/4*HEIGHT) begin
    valid<=1;sof<=(x==0 && y==0);eol<=(x==WIDTH-4);
    for(integer p=0;p<4;p=p+1)
     pixels[p*10 +: 10]<=checkerboard ? ((((x+p)/32+y/32)%2) ? 10'd1023:10'd0) : ((y*WIDTH+x+p+frame)&1023);
    if(x==WIDTH-4) begin x=0; y=y+1; end else x=x+4;
   end
   if(phase==PERIOD-1) begin phase=0;x=0;y=0;frame<=frame+1;end else phase=phase+1;
  end
 end
endmodule
