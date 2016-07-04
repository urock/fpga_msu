LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY adder_tb2 IS
END adder_tb2;

ARCHITECTURE behavior OF adder_tb2 IS

    COMPONENT adder_top
    PORT(
         switch_in : IN  std_logic_vector(7 downto 0);
         leds_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   --Inputs
   signal switch_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal leds_out : std_logic_vector(7 downto 0);

	signal A, B	: std_logic_vector(3 downto 0);

	signal error	: std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: adder_top PORT MAP (
          switch_in => switch_in,
          leds_out => leds_out
        );

	switch_in	<= B & A;

   -- Stimulus process
   stim_proc: process
   begin

		error	<= '0';

		for i in 0 to 15 loop
			for j in 0 to 15 loop
				A	<= conv_std_logic_vector(i,4);
				B	<= conv_std_logic_vector(j,4);

				wait for 10 ns;

				if leds_out /= conv_std_logic_vector(i+j,8) then
					error <= '1';
				else
					error	<= '0';
				end if;

				ASSERT leds_out = conv_std_logic_vector(i+j,8)
					report "Error!";
			end loop;
		end loop;

      wait;
   end process;
END;
