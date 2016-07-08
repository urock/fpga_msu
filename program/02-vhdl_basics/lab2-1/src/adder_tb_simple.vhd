library ieee;
use ieee.std_logic_1164.all;

entity adder_tb IS
end adder_tb;

architecture behavior of adder_tb IS

   component adder_gen
   port(
      switch_in : in  std_logic_vector(7 downto 0);
      leds_out : out  std_logic_vector(7 downto 0)
   );
   end component;

   --Inputs
   signal switch_in : std_logic_vector(7 downto 0) := (others => '0');

   --Outputs
   signal leds_out : std_logic_vector(7 downto 0);

   signal A, B  : std_logic_vector(3 downto 0);

begin

   -- Instantiate the Design Under Test (DUT)
   dut: adder_gen port map (
      switch_in => switch_in,
      leds_out => leds_out
   );

   switch_in <= B & A;

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
end;
