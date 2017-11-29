library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_loopback is
   port(
      clk      : in std_logic;
--      reset_n    : in std_logic;
      
      rx_line 	: in std_logic;
      tx_line 	: out std_logic;	  
      
      led      : out std_logic_vector(3 downto 0)
   );
end uart_loopback;

architecture arch of uart_loopback is

   signal uart_m_tdata : std_logic_vector(7 downto 0);
   signal uart_m_tvalid: std_logic;
   signal uart_m_tready: std_logic;
   
   signal uart_s_tdata : std_logic_vector(7 downto 0);
   signal uart_s_tvalid: std_logic;
   signal uart_s_tready: std_logic;   
   
	
   signal clk_cnt : std_logic_vector(26 downto 0); 
   signal reset : std_logic; 
    
-- ATTRIBUTE MARK_DEBUG : string;
-- ATTRIBUTE MARK_DEBUG of rx_tdata: SIGNAL IS "TRUE";
-- ATTRIBUTE MARK_DEBUG of m_tvalid: SIGNAL IS "TRUE";
-- ATTRIBUTE MARK_DEBUG of m_tready: SIGNAL IS "TRUE";

    signal reset_n : std_logic;
    
begin

reset_n <= '1'; 

reset <= not reset_n; 

-- instantiate uart
uart_unit: entity work.uart(str_arch)
   port map(
      clk      => clk, 
      reset_n  => reset_n, 
      
      -- UART PHY interface
      rx_line 	   => rx_line,
      tx_line 	   => tx_line, 
      
      -- UART RX interface
      m_tdata	   => uart_m_tdata, 
      m_tvalid	   => uart_m_tvalid, 
      m_tready	   => uart_m_tready, 

      -- UART TX interface
      s_tdata	   => uart_s_tdata, 
      s_tvalid	   => uart_s_tvalid, 
      s_tready	   => uart_s_tready
   );
   
uart_s_tvalid <= uart_m_tvalid; 
uart_m_tready <= uart_s_tready; 
   
            
-- incremented data loop back
uart_s_tdata <= std_logic_vector(unsigned(uart_m_tdata)+1);

--  led display
led(2 downto 0) <= uart_m_tdata(2 downto 0);

   process(clk)
   begin
      if (clk'event and clk='1') then
			if reset = '1' then
				clk_cnt <= (others => '0'); 
			else 
				clk_cnt <= std_logic_vector(unsigned(clk_cnt) + 1);
			end if;
      end if;
   end process;
	
led(3) <= clk_cnt(26); 

end arch;