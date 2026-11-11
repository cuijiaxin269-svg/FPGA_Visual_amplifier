`timescale 1ns/1ps
module tb_roi_compose #(parameter WIDTH=64,HEIGHT=48,SMOKE=0);
 localparam PIXELS=WIDTH*HEIGHT,BYTES=PIXELS*2,MEM_BYTES=BYTES*2+65536;
 localparam MAX_POLLS=SMOKE?1000000:10000;
 reg clk=0,resetn=0;always #5 clk=~clk;
 reg [11:0] s_axi_awaddr=0,s_axi_araddr=0;
 reg s_axi_awvalid=0,s_axi_wvalid=0,s_axi_bready=0,s_axi_arvalid=0,s_axi_rready=0;
 wire s_axi_awready,s_axi_wready,s_axi_bvalid,s_axi_arready,s_axi_rvalid;
 reg [31:0] s_axi_wdata=0;reg [3:0] s_axi_wstrb=0;
 wire [31:0] s_axi_rdata;wire [1:0] s_axi_bresp,s_axi_rresp;
 wire [31:0] m_axi_araddr,m_axi_awaddr;
 wire [7:0] m_axi_arlen,m_axi_awlen,m_axi_wstrb;
 wire [2:0] m_axi_arsize,m_axi_awsize,m_axi_arprot,m_axi_awprot;
 wire [1:0] m_axi_arburst,m_axi_awburst;
 wire m_axi_arlock,m_axi_awlock;
 wire [3:0] m_axi_arcache,m_axi_awcache,m_axi_arqos,m_axi_awqos;
 wire m_axi_arvalid,m_axi_rready,m_axi_awvalid,m_axi_wvalid,m_axi_wlast,m_axi_bready;
 wire [63:0] m_axi_wdata;
 reg [63:0] m_axi_rdata=0;
 reg [1:0] m_axi_rresp=0,m_axi_bresp=0;
 reg m_axi_rlast=0,m_axi_rvalid=0,m_axi_bvalid=0;
 wire m_axi_arready,m_axi_awready,m_axi_wready;
 motion60_roi_compose #(.WIDTH(WIDTH),.HEIGHT(HEIGHT)) dut(.aclk(clk),.aresetn(resetn),.*);

 reg [7:0] memory[0:MEM_BYTES-1];
 reg [31:0] random_bits=32'h32f16a09;
 reg rd_active=0,wr_active=0,b_pending=0;
 reg force_ar_stall=0,force_aw_stall=0,force_w_stall=0;
 reg force_r_stall=0,force_b_stall=0;
 integer rd_address,rd_count,rd_length,wr_address,wr_count,wr_length,wr_id;
 integer read_bursts=0,write_bursts=0,read_beats=0,write_responses=0;
 integer inject_r_beat=-1,inject_b_burst=-1;
 integer source_base=32'hff8,destination_base=BYTES+32'h5fb0;
 integer j;
 assign m_axi_arready=resetn&&!rd_active&&!m_axi_rvalid&&random_bits[0]&&!force_ar_stall;
 assign m_axi_awready=resetn&&!wr_active&&!b_pending&&!m_axi_bvalid&&random_bits[3]&&!force_aw_stall;
 assign m_axi_wready=resetn&&wr_active&&random_bits[7]&&!force_w_stall;
 always @(posedge clk)begin
  random_bits<={random_bits[30:0],random_bits[31]^random_bits[21]^random_bits[1]^random_bits[0]};
  if(resetn)begin
   if(m_axi_arvalid&&m_axi_arready)begin
    if(m_axi_arsize!=3||m_axi_arburst!=1||m_axi_arlen>15||m_axi_araddr[2:0]!=0)$fatal(1,"bad read burst");
    if({1'b0,m_axi_araddr[11:0]}+(m_axi_arlen+1)*8>4096)$fatal(1,"read crosses 4KB");
    if((m_axi_araddr-source_base)%(WIDTH*2)+(m_axi_arlen+1)*8>WIDTH*2)$fatal(1,"read crosses row");
    if(m_axi_araddr<source_base||m_axi_araddr+(m_axi_arlen+1)*8>source_base+BYTES)$fatal(1,"read outside frame");
    rd_address<=m_axi_araddr;rd_count<=0;rd_length<=m_axi_arlen+1;rd_active<=1;
    read_bursts<=read_bursts+1;
   end
   if(rd_active&&!m_axi_rvalid&&random_bits[4]&&!force_r_stall)begin
    for(j=0;j<8;j=j+1)m_axi_rdata[j*8+:8]<=memory[rd_address+j];
    m_axi_rresp<=read_beats==inject_r_beat?2'b11:0;
    m_axi_rlast<=rd_count==rd_length-1;m_axi_rvalid<=1;
   end
   if(m_axi_rvalid&&m_axi_rready)begin
    m_axi_rvalid<=0;read_beats<=read_beats+1;
    if(m_axi_rlast)rd_active<=0;
    else begin rd_address<=rd_address+8;rd_count<=rd_count+1;end
   end
   if(m_axi_awvalid&&m_axi_awready)begin
    if(m_axi_awsize!=3||m_axi_awburst!=1||m_axi_awlen>15||m_axi_awaddr[2:0]!=0)$fatal(1,"bad write burst");
    if({1'b0,m_axi_awaddr[11:0]}+(m_axi_awlen+1)*8>4096)$fatal(1,"write crosses 4KB");
    if((m_axi_awaddr-destination_base)%(WIDTH*2)+(m_axi_awlen+1)*8>WIDTH*2)$fatal(1,"write crosses row");
    if(m_axi_awaddr<destination_base||m_axi_awaddr+(m_axi_awlen+1)*8>destination_base+BYTES)$fatal(1,"write outside frame");
    wr_address<=m_axi_awaddr;wr_count<=0;wr_length<=m_axi_awlen+1;wr_active<=1;
    wr_id<=write_bursts;write_bursts<=write_bursts+1;
   end
   if(m_axi_wvalid&&m_axi_wready)begin
    if(m_axi_wlast!=(wr_count==wr_length-1))$fatal(1,"incorrect WLAST");
    for(j=0;j<8;j=j+1)if(m_axi_wstrb[j])memory[wr_address+j]<=m_axi_wdata[j*8+:8];
    if(m_axi_wlast)begin wr_active<=0;b_pending<=1;end
    else begin wr_address<=wr_address+8;wr_count<=wr_count+1;end
   end
   if(b_pending&&!m_axi_bvalid&&random_bits[9]&&!force_b_stall)begin
    m_axi_bvalid<=1;m_axi_bresp<=wr_id==inject_b_burst?2'b10:0;b_pending<=0;
   end
   if(m_axi_bvalid&&m_axi_bready)begin m_axi_bvalid<=0;write_responses<=write_responses+1;end
  end
 end

 // Payload must stay stable under independently randomized channel backpressure.
 reg ar_stalled=0,aw_stalled=0,w_stalled=0,lb_stalled=0,lr_stalled=0;
 reg [39:0] old_ar,old_aw;
 reg [72:0] old_w;
 reg [1:0] old_lb;
 reg [33:0] old_lr;
 always @(posedge clk)if(resetn)begin
  if(ar_stalled&&(!m_axi_arvalid||{m_axi_araddr,m_axi_arlen}!==old_ar))$fatal(1,"AR changed while stalled");
  if(aw_stalled&&(!m_axi_awvalid||{m_axi_awaddr,m_axi_awlen}!==old_aw))$fatal(1,"AW changed while stalled");
  if(w_stalled&&(!m_axi_wvalid||{m_axi_wdata,m_axi_wstrb,m_axi_wlast}!==old_w))$fatal(1,"W changed while stalled");
  if(lb_stalled&&(!s_axi_bvalid||s_axi_bresp!==old_lb))$fatal(1,"Lite B changed while stalled");
  if(lr_stalled&&(!s_axi_rvalid||{s_axi_rdata,s_axi_rresp}!==old_lr))$fatal(1,"Lite R changed while stalled");
  ar_stalled<=m_axi_arvalid&&!m_axi_arready;old_ar<={m_axi_araddr,m_axi_arlen};
  aw_stalled<=m_axi_awvalid&&!m_axi_awready;old_aw<={m_axi_awaddr,m_axi_awlen};
  w_stalled<=m_axi_wvalid&&!m_axi_wready;old_w<={m_axi_wdata,m_axi_wstrb,m_axi_wlast};
  lb_stalled<=s_axi_bvalid&&!s_axi_bready;old_lb<=s_axi_bresp;
  lr_stalled<=s_axi_rvalid&&!s_axi_rready;old_lr<={s_axi_rdata,s_axi_rresp};
 end

 task automatic write_reg(input [11:0] addr,input [31:0] value,input [3:0] strb,input [1:0] expected,input integer order);
  fork
   begin
    repeat(order==0?0:3)@(negedge clk);
    @(negedge clk);s_axi_awaddr=addr;s_axi_awvalid=1;
    do @(posedge clk);while(!s_axi_awready);
    @(negedge clk);s_axi_awvalid=0;
   end
   begin
    repeat(order==0?3:0)@(negedge clk);
    @(negedge clk);s_axi_wdata=value;s_axi_wstrb=strb;s_axi_wvalid=1;
    do @(posedge clk);while(!s_axi_wready);
    @(negedge clk);s_axi_wvalid=0;
   end
  join
  while(!s_axi_bvalid)@(negedge clk);
  if(s_axi_bresp!==expected)$fatal(1,"write %h response %h expected %h",addr,s_axi_bresp,expected);
  repeat(3)@(negedge clk);s_axi_bready=1;
  @(posedge clk);@(negedge clk);s_axi_bready=0;
 endtask
 task automatic read_reg(input [11:0] addr,output [31:0] value,input [1:0] expected);
  @(negedge clk);s_axi_araddr=addr;s_axi_arvalid=1;
  do @(posedge clk);while(!s_axi_arready);
  @(negedge clk);s_axi_arvalid=0;
  while(!s_axi_rvalid)@(negedge clk);
  value=s_axi_rdata;
  if(s_axi_rresp!==expected)$fatal(1,"read %h response mismatch",addr);
  repeat(2)@(negedge clk);s_axi_rready=1;
  @(posedge clk);@(negedge clk);s_axi_rready=0;
 endtask
 task automatic configure(input integer x,y,size,flags);
  write_reg('h10,source_base,15,0,0);write_reg('h14,destination_base,15,0,1);
  write_reg('h18,x,15,0,0);write_reg('h1c,y,15,0,1);
  write_reg('h20,size,15,0,0);write_reg('h24,flags,15,0,1);
 endtask
 function automatic [15:0] original(input integer p);original=(p*37+91)&1023;endfunction
 function automatic [15:0] processed(input integer p);processed=(p*19+613)&1023;endfunction
 task automatic images;
  integer i;reg[15:0] a,b;
  for(i=0;i<MEM_BYTES;i=i+1)memory[i]=8'ha5;
  for(i=0;i<PIXELS;i=i+1)begin
   a=original(i);b=processed(i);
   memory[source_base+i*2]=a[7:0];memory[source_base+i*2+1]=a[15:8];
   memory[destination_base+i*2]=b[7:0];memory[destination_base+i*2+1]=b[15:8];
  end
 endtask
 task automatic wait_done(input integer expected_error);
  reg [31:0] v,e;integer n;
  n=0;v=0;
  while(!v[1]&&n<MAX_POLLS)begin read_reg('h04,v,0);n=n+1;end
  if(n==MAX_POLLS||v[0])$fatal(1,"completion timeout or BUSY with DONE");
  read_reg('h08,e,0);
  if(e!=expected_error)$fatal(1,"ERROR=%0d expected=%0d",e,expected_error);
  repeat(10)@(negedge clk);read_reg('h04,v,0);
  if(v!=2)$fatal(1,"DONE not sticky");
  if(rd_active||wr_active||m_axi_rvalid||m_axi_bvalid||b_pending)$fatal(1,"completion before transactions drained");
 endtask
 task automatic check_image(input integer rx,ry,side,border);
  integer i,x,y;reg in_region,on_border;reg[15:0] expected,actual;
  for(i=0;i<PIXELS;i=i+1)begin
   x=i%WIDTH;y=i/WIDTH;
   in_region=x>=rx&&x<rx+side&&y>=ry&&y<ry+side;
   on_border=in_region&&border&&(x-rx<2||rx+side-1-x<2||y-ry<2||ry+side-1-y<2);
   expected=on_border?1023:in_region?processed(i):original(i);
   actual={memory[destination_base+2*i+1],memory[destination_base+2*i]};
   if(actual!==expected)$fatal(1,"pixel (%0d,%0d) got %h expected %h",x,y,actual,expected);
   actual={memory[source_base+2*i+1],memory[source_base+2*i]};
   if(actual!==original(i))$fatal(1,"source changed");
  end
  for(i=1;i<=16;i=i+1)begin
   if(memory[destination_base-i]!==8'ha5||memory[destination_base+BYTES+i-1]!==8'ha5)$fatal(1,"destination guard changed");
  end
 endtask
 task automatic normal_case(input integer x,y,size,border);
  images();configure(x,y,size,border);write_reg('h04,1,15,0,0);
  wait_done(0);check_image(x,y,size,border);
 endtask
 task automatic reject_start(input integer code);
  integer before_reads,before_writes;
  before_reads=read_bursts;before_writes=write_bursts;
  write_reg('h04,1,15,2,1);wait_done(code);
  if(read_bursts!=before_reads||write_bursts!=before_writes)$fatal(1,"invalid start accessed memory");
 endtask
 reg [31:0] value;
 integer before_reads,before_writes,before_beats;
 initial begin
  repeat(8)@(negedge clk);resetn=1;
  read_reg('h00,value,0);if(value!=32'h524f4931)$fatal(1,"wrong ID");
  read_reg('h04,value,0);if(value!=0)$fatal(1,"wrong reset status");
  if(SMOKE)begin
   normal_case(513,271,257,1);
   if(read_beats!=PIXELS/4||read_bursts!=write_responses)$fatal(1,"production frame incomplete");
   $display("ROI_COMPOSE_FULL_PASS width=%0d height=%0d pixels=%0d beats=%0d bursts=%0d",WIDTH,HEIGHT,PIXELS,read_beats,read_bursts);
   $finish;
  end
  read_reg('h030,value,2);write_reg('h030,0,15,2,1);
  normal_case(11,7,17,0);normal_case(11,7,17,1);
  normal_case(0,0,1,1);normal_case(49,33,15,0);normal_case(3,0,48,1);
  $display("PASS exact pixels, inner border, odd coordinates, row/4KB splits and random stalls");

  images();configure(5,9,13,0);force_ar_stall=1;
  write_reg('h04,1,15,0,1);
  read_reg('h04,value,0);if(value!=1)$fatal(1,"START did not clear DONE/set BUSY");
  write_reg('h18,31,15,2,0);write_reg('h04,1,15,2,1);
  read_reg('h18,value,0);if(value!=5)$fatal(1,"busy config changed");
  force_ar_stall=0;wait_done(0);check_image(5,9,13,0);
  write_reg('h18,99,1,2,0);read_reg('h18,value,0);if(value!=5)$fatal(1,"partial write changed config");
  configure(0,0,0,0);reject_start(4);
  configure(32'hfffffff8,0,8,0);reject_start(4);
  configure(0,0,49,0);reject_start(4);
  configure(0,0,16,2);reject_start(5);
  configure(0,0,16,0);write_reg('h10,source_base+1,15,0,0);reject_start(1);
  configure(0,0,16,0);write_reg('h14,source_base+8,15,0,0);reject_start(3);
  configure(0,0,16,0);write_reg('h10,32'hfffffff8,15,0,0);reject_start(2);
  $display("PASS validation, independent Lite AW/W, partial writes, busy rejection and sticky DONE");

  source_base='h1000;destination_base='h6000;
  images();configure(7,11,19,0);
  before_writes=write_bursts;before_beats=read_beats;inject_r_beat=read_beats+7;
  write_reg('h04,1,15,0,0);wait_done(16);inject_r_beat=-1;
  if(read_beats-before_beats!=16||write_bursts!=before_writes)$fatal(1,"R error not drained or bad burst written");
  images();configure(7,11,19,0);inject_b_burst=write_bursts;
  before_reads=read_bursts;write_reg('h04,1,15,0,1);wait_done(17);inject_b_burst=-1;
  if(read_bursts!=before_reads+1)$fatal(1,"new read after B error");
  normal_case(7,11,19,0);
  $display("PASS R/B error drain and successful restart");
  $display("ROI_COMPOSE_PASS");$finish;
 end
 initial begin #100000000;$fatal(1,"global timeout");end
endmodule

module tb_roi_compose_full;
 tb_roi_compose #(.WIDTH(1280),.HEIGHT(800),.SMOKE(1)) test();
endmodule
