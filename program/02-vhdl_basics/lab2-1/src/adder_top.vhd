----------------------------------------------------------------------------------
-- Company:       MSU
-- Engineer:      urock
--
-- Create Date:      22:47:17 10/27/2011

-- Design Name:      Atlys_study project
-- Module Name:      comb_02_adder - rtl
-- Project Name:

-- Description:      полный сумматор 4х битных чисел. Использует схемы полусумматора и полного однобитного сумматора
--          Реализует функцию A + B = C
--          switch_in - входная шина данных с переключателей на плате
--          Операнды    A  <= switch_in(7 downto 4);
--                   B  <= switch_in(3 downto 0);

--                   leds_out(5 downto 0) <= C;
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity adder_top is
    Port (

			switch_in 	: in  STD_LOGIC_VECTOR (7 downto 0);
			leds_out 	: out STD_LOGIC_VECTOR (7 downto 0)

			  );
end adder_top;

architecture rtl of adder_top is


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


b0: full_adder port map (
		a 		=> A(0),
		b 		=> B(0),
		c_in 	=> C(0),
		s 		=> S(0),
		c_out => C(1)
		);

b1: full_adder port map (
		a 		=> A(1),
		b 		=> B(1),
		c_in 	=> C(1),
		s 		=> S(1),
		c_out => C(2)
		);

b2: full_adder port map (
		a 		=> A(2),
		b 		=> B(2),
		c_in 	=> C(2),
		s 		=> S(2),
		c_out => C(3)
		);


b3: full_adder port map (
		a 		=> A(3),
		b 		=> B(3),
		c_in 	=> C(3),
		s 		=> S(3),
		c_out => C(4)
		);


leds_out	<= "000" & C(4) & S;


end rtl;


