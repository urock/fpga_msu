----------------------------------------------------------------------------------
-- Company: 		MSU
-- Engineer: 		urock
--
-- Create Date:    	22:47:17 10/27/2011

-- Design Name: 		Atlys_study project
-- Module Name:    	comb_02_adder - rtl
-- Project Name:

-- Description: 		полный сумматор 4х битных чисел. Использует схемы полусумматора и полного однобитного сумматора
--				Реализует функцию A + B = C
--				switch_in - входная шина данных с переключателей на плате
--				Операнды 	A 	<= switch_in(7 downto 4);
--							B	<= switch_in(3 downto 0);

--							leds_out(5 downto 0)	<= C;
--
--				Продвинутая версия с оператором for generate
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity adder_top_gen is
    Port (

			switch_in 	: in  STD_LOGIC_VECTOR (7 downto 0);
			leds_out 	: out STD_LOGIC_VECTOR (7 downto 0)

			  );
end adder_top_gen;

architecture rtl of adder_top_gen is


-- объявление компонента
COMPONENT full_adder
Port ( a 		: in  std_logic;
	   b 		: in  std_logic;
	   c_in 	: in  std_logic;
	   s 		: out std_logic;
	   c_out 	: out std_logic
		 );
END COMPONENT;


signal A, B	: std_logic_vector(3 downto 0);

signal C		: std_logic_vector(4 downto 0);

signal S		: std_logic_vector(3 downto 0);

begin


A 	<= switch_in(7 downto 4);
B	<= switch_in(3 downto 0);


C(0) <= '0';

-- вставка компонентов в цикле
-- тут g1 - это метка цикла
g1: for i in 0 to 3 generate
begin

	b: full_adder port map (
			a 		=> A(i),
			b 		=> B(i),
			c_in 	=> C(i),
			s 		=> S(i),
			c_out => C(i+1)
			);

end generate g1;


leds_out	<= "000" & C(4) & S;


end rtl;
