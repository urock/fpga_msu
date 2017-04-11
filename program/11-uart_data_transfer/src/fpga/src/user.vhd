
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity user is

   port(
      clk 		: in std_logic;
      reset_n 	   : in std_logic;

      -- UART RX interface
      s_tdata	: in  std_logic_vector(7 downto 0);
      s_tvalid	: in  std_logic; 
      s_tready	: out std_logic;
      
      -- UART TX interface
      m_tdata	: out std_logic_vector(7 downto 0);
      m_tvalid	: out std_logic; 
      m_tready	: in  std_logic


   );
end user;

architecture rtl of user is

signal reg_addr	   : std_logic_vector(7 downto 0);
signal reg_we    	: std_logic; 
signal reg_din   	: std_logic_vector(31 downto 0);
signal reg_re	   : std_logic;
signal reg_dout   	: std_logic_vector(31 downto 0);
   
begin

regs_access: entity work.protocol_stm(rtl)
   port map(

      clk 		=> clk,
      reset_n 	=> reset_n,
      
      -- UART RX interface
      s_tdata	=> s_tdata,
      s_tvalid	=> s_tvalid,
      s_tready	=> s_tready,
      
      -- UART TX interface
      m_tdata	=> m_tdata,
      m_tvalid	=> m_tvalid,
      m_tready	=> m_tready,
      
      -- register file interface
      reg_addr	=> reg_addr,
      reg_we   => reg_we,
      reg_din  => reg_din,
      
      reg_re	=> reg_re,
      reg_dout => reg_dout

   );

regs: entity work.reg_file(rtl)
   port map(
      clk 		=> clk,
      reset_n 	=> reset_n,

      addr	   => reg_addr,
      we    	=> reg_we,
      din   	=> reg_din,
      
      re	      => reg_re,
      dout   	=> reg_dout
   );
               
               
end rtl;