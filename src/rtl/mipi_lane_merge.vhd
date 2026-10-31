library ieee;
use ieee.std_logic_1164.all;
entity mipi_lane_merge is
 port (
  byte_clk, resetn : in std_logic;
  d0, d1 : in std_logic_vector(7 downto 0);
  valid0, valid1, active0, active1, sync0, sync1 : in std_logic;
  sot0, sot1, sotsync0, sotsync1 : in std_logic;
  m_axis_tdata : out std_logic_vector(31 downto 0);
  m_axis_tkeep : out std_logic_vector(3 downto 0);
  m_axis_tvalid, m_axis_tlast : out std_logic;
  m_axis_tready : in std_logic;
  fault_sticky : out std_logic
 );
end entity;
architecture rtl of mipi_lane_merge is
 attribute X_INTERFACE_PARAMETER : string;
 attribute X_INTERFACE_INFO : string;
 attribute X_INTERFACE_INFO of byte_clk : signal is "xilinx.com:signal:clock:1.0 byte_clk CLK";
 attribute X_INTERFACE_PARAMETER of byte_clk : signal is "ASSOCIATED_BUSIF m_axis, ASSOCIATED_RESET resetn";
 attribute X_INTERFACE_INFO of resetn : signal is "xilinx.com:signal:reset:1.0 resetn RST";
 attribute X_INTERFACE_PARAMETER of resetn : signal is "POLARITY ACTIVE_LOW";
 signal v, skew, ovf : std_logic;
 -- Synchronous deassertion into an intermittent recovered byte clock.
 attribute ASYNC_REG : string;
 signal rstpipe : std_logic_vector(1 downto 0) := "00";
 attribute ASYNC_REG of rstpipe : signal is "TRUE";
begin
 process(byte_clk,resetn) begin
  if resetn='0' then rstpipe<="00";
  elsif rising_edge(byte_clk) then rstpipe<=rstpipe(0)&'1'; end if;
 end process;
 lane_merge : entity work.LM
  generic map(kMaxLaneCount=>4,kLaneCount=>2)
  port map(RxByteClkHS=>byte_clk,RxDataHS=>d1&d0,
   RxSyncHS=>sync1&sync0,RxValidHS=>valid1&valid0,RxActiveHS=>active1&active0,
   rbMAxisTdata=>m_axis_tdata,rbMAxisTkeep=>m_axis_tkeep,rbMAxisTvalid=>v,
   rbMAxisTlast=>m_axis_tlast,rbMAxisTready=>'1',rbErrSkew=>skew,rbErrOvf=>ovf,
   rbEn=>rstpipe(1),rbRst=>not rstpipe(1),dbgLMLane=>open,dbgLM=>open);
 m_axis_tvalid<=v;
 process(byte_clk,resetn) begin
  if resetn='0' then fault_sticky<='0';
  elsif rising_edge(byte_clk) then
   if skew='1' or ovf='1' or sot0='1' or sot1='1' or sotsync0='1' or sotsync1='1' or
      (v='1' and m_axis_tready='0') then fault_sticky<='1'; end if;
  end if;
 end process;
end architecture;
