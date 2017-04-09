
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity uart is
   generic(
      -- Default setting:
      -- 115,200 baud, 8 data bis, 1 stop its, 2^2 FIFO
      DBIT: integer:=8;     -- # data bits
      SB_TICK: integer:=16; -- # ticks for stop bits, 16/24/32
                            --   for 1/1.5/2 stop bits
      DVSR: integer:= 54;  -- baud rate divisor
                            -- DVSR = 100M/(16*baud rate)
      DVSR_BIT: integer:=7; -- # bits of DVSR
      FIFO_W: integer:=2    -- # addr bits of FIFO
                            -- # words in FIFO=2^FIFO_W
   );
   port(
      clk 		: in std_logic;
      reset_n 	   : in std_logic;

      -- UART PHY interface
      rx_line 	: in  std_logic;
      tx_line 	: out std_logic;	  

      -- UART RX interface
      m_tdata	: out std_logic_vector(7 downto 0);
      m_tvalid	: out std_logic; 
      m_tready	: in  std_logic;

      -- UART TX interface
      s_tdata	: in  std_logic_vector(7 downto 0);
      s_tvalid	: in  std_logic; 
      s_tready	: out std_logic
   );
end uart;

architecture str_arch of uart is
   signal tick: std_logic;
   signal rx_done_tick: std_logic;
   signal rx_data_out: std_logic_vector(7 downto 0);
   
   signal fifo_tx_tdata: std_logic_vector(7 downto 0);   
   signal fifo_tx_tvalid: std_logic;
   signal fifo_tx_tready: std_logic;
   
   signal tx_done_tick: std_logic;
   
   signal tx_full, rx_empty: std_logic;   
   signal reset : std_logic; 
   signal tx_start : std_logic; 
   
   type state_type is (IDLE_ST, TX_START_ST, WAIT_TX_END_ST);
   signal state: state_type;
   
begin

    reset <= not reset_n; 
    
   baud_gen_unit: entity work.mod_m_counter(arch)
      generic map(M=>DVSR, N=>DVSR_BIT)
      port map(clk=>clk, reset=>reset,
               q=>open, max_tick=>tick);
               
   uart_rx_unit: entity work.uart_rx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(clk=>clk, reset=>reset, rx=>rx_line,
               s_tick=>tick, rx_done_tick=>rx_done_tick,
               dout=>rx_data_out);
               
   fifo_rx_unit : entity work.uart_fifo
     PORT MAP (
       s_aclk => clk,
       s_aresetn => reset_n,
       s_axis_tvalid => rx_done_tick,
       s_axis_tready => open,
       s_axis_tdata => rx_data_out,
       
       m_axis_tvalid => m_tvalid,
       m_axis_tready => m_tready,
       m_axis_tdata => m_tdata,
       axis_prog_full => open
     );
                                
               
    fifo_tx_unit : entity work.uart_fifo
      PORT MAP (
        s_aclk => clk,
        s_aresetn => reset_n,
        s_axis_tvalid => s_tvalid,
        s_axis_tready => s_tready,
        s_axis_tdata => s_tdata,
        
        m_axis_tvalid => fifo_tx_tvalid,
        m_axis_tready => fifo_tx_tready,
        m_axis_tdata => fifo_tx_tdata,
        axis_prog_full => open
      );
   
   uart_tx_unit: entity work.uart_tx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(clk=>clk, reset=>reset,
               tx_start=>tx_start,
               s_tick=>tick, din=>fifo_tx_tdata,
               tx_done_tick=> tx_done_tick, tx=>tx_line);
               
   tx_start <= fifo_tx_tvalid and fifo_tx_tready; 
                         
   process(clk)
   begin
      if (clk'event and clk='1') then
			if reset_n = '0' then
            fifo_tx_tready <= '0';
            state          <= IDLE_ST; 
			else 
              
            case state is
               when IDLE_ST =>
                  if fifo_tx_tvalid = '1' then
                     state <= TX_START_ST;
                  end if;
                  
               when TX_START_ST =>
                  fifo_tx_tready <= '1';
                  state <= WAIT_TX_END_ST;
               
               when WAIT_TX_END_ST =>
                  fifo_tx_tready <= '0';
                  if tx_done_tick = '1' then
                     state <= IDLE_ST;
                  end if;           

            end case;
            
			end if; -- reset_n
      end if;
   end process;               
               
               
               
end str_arch;