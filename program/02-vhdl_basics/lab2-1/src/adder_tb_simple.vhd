LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY adder_tb IS
END adder_tb;

ARCHITECTURE behavior OF adder_tb IS

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
		A <= "0000";
		B <= "0000";
      wait for 100 ns;

		A <= "0001";
		B <= "0100";
      wait for 100 ns;

		A <= "0011";
		B <= "0101";
      wait for 100 ns;

		A <= "0001";
		B <= "0100";
      wait for 100 ns;

		A <= "0001";
		B <= "0111";
      wait;
   end process;
END;
