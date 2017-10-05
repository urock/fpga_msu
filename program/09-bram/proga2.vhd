library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity bram is
port(
    clk, reset: in std_logic;
    din: in std_logic_vector (15 downto 0);
    dv_in: in std_logic;
    dv_out: out std_logic;
    dout : out STD_LOGIC_VECTOR ( 15 downto 0 )
);
end bram;
architecture arch of bram is
    component blk_mem_gen_0 --Объявление компонента BRAM
       Port ( 
           clka : in STD_LOGIC;
           wea : in STD_LOGIC_VECTOR ( 0 to 0 );
           addra : in STD_LOGIC_VECTOR ( 3 downto 0 );
           dina : in STD_LOGIC_VECTOR ( 15 downto 0 );
           douta : out STD_LOGIC_VECTOR ( 15 downto 0 ));
    end component;
    
    type state_type is (state_wr, state_rd);
    signal state_reg, state_next: state_type;
    signal cnt_reg, cnt_next, cnt_next1:unsigned (3 downto 0);
    signal dv_reg, dv_reg1, dv_next: std_logic;
    signal din_reg, dout_reg: std_logic_vector(15 downto 0);
    signal addr: std_logic_vector(3 downto 0);
    signal wr_en:  std_logic_vector ( 0 to 0 );

begin
blk_mem_inst : blk_mem_gen_0 --Инстаниация BRAM
PORT MAP (clka => clk,
         wea => wr_en,
         addra => addr,
         dina => din,
         douta => dout);   

process(clk,reset) -- Настройка смены состояний по фронту clk
begin
    if (reset='1') then
        state_reg <= state_wr;
        cnt_reg <= (others => '0');
        dv_reg <= '0';
        dv_reg1<='0';

    elsif (rising_edge(clk)) then
        state_reg <= state_next;
        cnt_reg <= cnt_next;
        dv_reg <= dv_next;
        dv_reg1 <= dv_reg;  
    end if;
end process;

process(state_reg, cnt_reg, dv_in, dv_reg, dv_reg1) -- Смена состояний
begin
state_next <= state_reg;
cnt_next <= cnt_reg;
dv_out <= dv_reg1;
addr <= std_logic_vector(cnt_reg);
case state_reg is
    when state_rd =>
        dv_next <= '1';
        wr_en <= "0"; 
        if (cnt_reg /= 15) then
            cnt_next <= cnt_reg + 1;  
            
        else
            state_next <= state_wr;
            cnt_next <= (others => '0');
        end if;
    when state_wr =>
         dv_next <= '0';
         wr_en <= "1";
         if (dv_in = '1') then
              cnt_next <= cnt_reg + 1;
         
         end if;     
         if (cnt_reg /= 15) then
             state_next <= state_wr;
 
         elsif (dv_in = '1') then
             state_next <= state_rd;
             cnt_next <= (others => '0'); 
         end if;      
end case;
end process;
end arch;
    if (reset='1') then
        state_reg <= state_wr;
        cnt_reg <= (others => '0');
        dv_reg <= '0';
        dv_reg1<='0';

    elsif (rising_edge(clk)) then
        state_reg <= state_next;
        cnt_reg <= cnt_next;
        dv_reg <= dv_next;
        dv_reg1 <= dv_reg;  
    end if;
end process;

process(state_reg, cnt_reg, dv_in, dv_reg, dv_reg1)
begin
state_next <= state_reg;
cnt_next <= cnt_reg;
dv_out <= dv_reg1;
addr <= std_logic_vector(cnt_reg);
case state_reg is
    when state_rd =>
        dv_next <= '1';
        wr_en <= "0"; 
        if (cnt_reg /= 15) then
            cnt_next <= cnt_reg + 1;  
            
        else
            state_next <= state_wr;
            cnt_next <= (others => '0');
        end if;
    when state_wr =>
         dv_next <= '0';
         wr_en <= "1";
         if (dv_in = '1') then
              cnt_next <= cnt_reg + 1;
         
         end if;     
         if (cnt_reg /= 15) then
             state_next <= state_wr;
 
         elsif (dv_in = '1') then
             state_next <= state_rd;
             cnt_next <= (others => '0'); 
         end if;      
end case;
end process;
end arch;