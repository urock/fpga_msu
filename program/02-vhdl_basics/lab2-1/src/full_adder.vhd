library IEEE;
use IEEE.std_logic_1164.ALL;


entity full_adder is
    Port ( a 		: in  std_logic;
           b 		: in  std_logic;
           c_in 	: in  std_logic;
           s 		: out std_logic;
           c_out 	: out std_logic
			 );
end full_adder;

architecture rtl of full_adder is


component half_adder
 Port ( a : in  std_logic;
	   b : in  std_logic;
	   s : out std_logic;
	   c : out std_logic);
end component;



signal h1_s	: std_logic;
signal h1_c	: std_logic;

signal h2_c: std_logic;

begin

h1: half_adder port map (
		 a	=> a,
		 b	=> b,
		 s	=> h1_s,
		 c => h1_c
		 );

h2: half_adder	port map (
		 a	=> c_in,
		 b	=> h1_s,
		 s	=> s,
		 c => h2_c
		 );

c_out <= h1_c or h2_c;



end rtl;

