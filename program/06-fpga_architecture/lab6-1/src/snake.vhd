
library IEEE;
use IEEE.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity snake_top is
    Port ( 
	 
		clk 		: in  std_logic;
		rst			: in  std_logic;
		leds_out	: out std_logic_vector(3 downto 0)
		
		);
end snake_top;

architecture rtl of snake_top is

signal shift_en	: std_logic;
signal snake_reg			: std_logic_vector(3 downto 0); 

signal counter	: std_logic_vector(26 downto 0); 

begin

process(clk, rst)
begin
	if rst = '1' then 
		counter <= (others => '0'); 
	elsif rising_edge(clk) then
		if led_tick = '1' then
			counter <= (others => '0'); 
		else
			counter <= counter + 1;
		end if;
	end if;
end process;

shift_en <= '1' when counter = conv_std_logic_vector(50000000,27) else '0'; 

process(clk, rst)
begin
	if rst = '1' then 
		snake_reg	<= "1001";
	elsif rising_edge(clk) then
		if shift_en = '1' then
			snake_reg	<= snake_reg(2 downto 0) & snake_reg(3);
		end if;
	end if;
end process;

leds_out	<= snake_reg; 


end rtl;

