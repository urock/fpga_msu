
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity protocol_stm is

   port(
      clk 		: in std_logic;
      reset_n 	: in std_logic;
      
      -- UART RX interface
      s_tdata	: in  std_logic_vector(7 downto 0);
      s_tvalid	: in  std_logic; 
      s_tready	: out std_logic;
      
      -- UART TX interface
      m_tdata	: out std_logic_vector(7 downto 0);
      m_tvalid	: out std_logic; 
      m_tready	: in  std_logic;
      
      -- register file interface
      reg_addr	   : out std_logic_vector(7 downto 0);
      reg_we    	: out std_logic; 
      reg_din   	: out std_logic_vector(31 downto 0);
      
      reg_re	   : out std_logic;
      reg_dout   	: in  std_logic_vector(31 downto 0)

   );
end protocol_stm;

architecture rtl of protocol_stm is

constant WR_CMD : std_logic_vector(7 downto 0) := X"01"; 
constant RD_CMD : std_logic_vector(7 downto 0) := X"02";


type rx_state_type is (RX_IDLE_ST, RX_WR_ST, RX_RD_ST);
signal rx_state: rx_state_type;

type tx_state_type is (TX_IDLE_ST, TX_TRANSMIT_ST);
signal tx_state: tx_state_type;

signal reg_rd_en  : std_logic; 
signal tx_valid   : std_logic; 
signal reg_we_s   : std_logic;

begin

reg_re <= reg_rd_en; 

m_tvalid <= tx_valid and m_tready;

reg_we <= reg_we_s; 

process(clk)

   variable mode_rx: integer range 0 to 4;
   variable mode_tx: integer range 0 to 3;

begin
   if rising_edge(clk) then
      if reset_n = '0' then
         rx_state       <= RX_IDLE_ST;
         tx_state       <= TX_IDLE_ST;
         reg_addr    <= (others => '0');
         reg_we_s    <= '0';
         reg_din     <= (others => '0');
         reg_rd_en   <= '0'; 
         s_tready    <= '0';
         m_tdata     <= (others => '0');
         tx_valid    <= '0';
      else 
      
         -- rx state machine
         s_tready    <= '1'; 
         reg_rd_en   <= '0';
         
         if (s_tvalid = '1') then
      
            case rx_state is
               when RX_IDLE_ST => 
                  if s_tdata = WR_CMD then  
                     rx_state <= RX_WR_ST;
                     mode_rx     := 0;
                  elsif s_tdata = RD_CMD then
                     rx_state <= RX_RD_ST;
                  end if; 
                  
               when RX_WR_ST => 
                  case mode_rx is
                     when 0 => reg_addr              <= s_tdata; mode_rx := 1;
                     when 1 => reg_din(31 downto 24) <= s_tdata; mode_rx := 2;
                     when 2 => reg_din(23 downto 16) <= s_tdata; mode_rx := 3;
                     when 3 => reg_din(15 downto  8) <= s_tdata; mode_rx := 4;
                     when 4 => 
                        reg_din(7 downto 0) <= s_tdata; 
                        rx_state            <= RX_IDLE_ST; 
                        reg_we_s            <= '1'; 
                  end case; 
                  
               when RX_RD_ST => 
                  reg_addr    <= s_tdata;
                  reg_rd_en   <= '1';
                  rx_state    <= RX_IDLE_ST;
             
            end case;
            
         end if; -- s_tvalid
         
         if reg_we_s = '1' then
            reg_we_s <= '0';
         end if; 
         
         
         -- tx state machine
         case tx_state is
            
            when TX_IDLE_ST => 
               tx_valid <= '0';
               if reg_rd_en = '1' then
                  tx_state    <= TX_TRANSMIT_ST;
                  mode_tx     := 0;
               end if; 
               
            when TX_TRANSMIT_ST => 
               if m_tready = '1' then
                  tx_valid <= '1';
                  case mode_tx is
                     when 0 => m_tdata <= reg_dout(31 downto 24); mode_tx := 1;
                     when 1 => m_tdata <= reg_dout(23 downto 16); mode_tx := 2;
                     when 2 => m_tdata <= reg_dout(15 downto  8); mode_tx := 3;
                     when 3 => 
                        m_tdata     <= reg_dout(7 downto 0); 
                        tx_state    <= TX_IDLE_ST; 
                  end case;    
               else 
                  tx_valid <= '0';
               end if; -- m_tready
         
         end case;
         

         
      end if; -- reset_n
   end if;
end process; 

   
               
               
end rtl;