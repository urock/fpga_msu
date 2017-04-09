library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_test is
   port(
      clk      : in std_logic;
      reset_n    : in std_logic;
      
      rx_line 	: in std_logic;
      tx_line 	: out std_logic;	  
      
      btnu     : in std_logic;
      Led      : out std_logic_vector(7 downto 0)
   );
end uart_test;

architecture arch of uart_test is

   signal rx_tdata : std_logic_vector(7 downto 0);
   signal tx_tdata : std_logic_vector(7 downto 0);
   signal m_tvalid: std_logic;
   signal m_tready: std_logic;
	
    signal clk_cnt : std_logic_vector(26 downto 0); 
    signal reset : std_logic; 
    
-- ATTRIBUTE MARK_DEBUG : string;
-- ATTRIBUTE MARK_DEBUG of rx_tdata: SIGNAL IS "TRUE";
-- ATTRIBUTE MARK_DEBUG of m_tvalid: SIGNAL IS "TRUE";
-- ATTRIBUTE MARK_DEBUG of m_tready: SIGNAL IS "TRUE";

    
begin

reset <= not reset_n; 

-- instantiate uart
uart_unit: entity work.uart(str_arch)
   port map(
      clk   => clk, 
      reset_n => reset_n, 
      
      rx_line 	   => rx_line,
      tx_line 	   => tx_line, 
      
      m_tdata	   => rx_tdata, 
      m_tvalid	   => m_tvalid, 
      m_tready	   => m_tready, 

      s_tdata	   => rx_tdata, 
      s_tvalid	   => m_tvalid, 
      s_tready	   => m_tready
   );
   
-- instantiate debounce circuit
-- btn_db_unit: entity work.db_fsm(arch)
   -- port map(clk=>clk, reset=>reset, sw=>btnu, db=>btn_tick);
            
-- incremented data loop back
-- tx_tdata <= std_logic_vector(unsigned(rx_tdata)+1);

--  led display
led(4 downto 0) <= (others => '0');

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
	
Led(7) <= '0'; 
Led(6) <= '1'; 
Led(5) <= clk_cnt(26); 

end arch;