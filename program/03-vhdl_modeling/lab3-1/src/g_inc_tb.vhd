library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity g_inc_tb is
end g_inc_tb;

architecture behavior of g_inc_tb is

    -- Component Declaration for the Design Under Test (DUT)
    component g_inc
    port(
         g      : in   std_logic_vector(3 downto 0);
         g_next : out  std_logic_vector(3 downto 0)
        );
    end component;


   --Inputs
   signal g : std_logic_vector(3 downto 0) := (others => '0');

   --Outputs
   signal g_next : std_logic_vector(3 downto 0);

   constant clk_period : time := 10 ns;

   type input_vector_record is record
      test_num: integer; -- Test Number
      input: std_logic_vector(3 downto 0); -- Test input
   end record;

   type input_vector_array is array (integer range 1 to 16) of input_vector_record;

   constant test_input_vectors : input_vector_array := (
      (  1, "0000"),
      (  2, "0001"),
      (  3, "0011"),
      (  4, "0010"),
      (  5, "0110"),
      (  6, "0110"),
      --(  6, "0111"),
      (  7, "0101"),
      (  8, "0100"),
      (  9, "1100"),
      ( 10, "1101"),
      ( 11, "1111"),
      ( 12, "1110"),
      ( 13, "1010"),
      ( 14, "1011"),
      ( 15, "1001"),
      ( 16, "1000"));

   type bool_array is array (integer range <>) of boolean;

   type output_vector_array is array (integer range 1 to 16) of std_logic_vector(3 downto 0);

   signal expected_output_vectors : output_vector_array;
   signal real_output_vectors : output_vector_array;
   signal test_result : bool_array (1 to 16);
   signal results_ready : std_logic := '0';

begin

   -- Instantiate the Design Under Test (DUT)
   dut: g_inc port map (
          g => g,
          g_next => g_next
        );


   -- Stimulus process
   stim_proc: process
      variable Message : line;
   begin

      wait for 100 ns;

      for i in 1 to 16 loop
         Write ( Message, string'("-- Test "));
         Write ( Message, test_input_vectors(i).test_num);
         Write ( Message, string'(": INPUT = "));
         Write ( Message, test_input_vectors(i).input);
         writeline(output, Message);

         g <= test_input_vectors(i).input;

         wait for clk_period;

      end loop;

      wait;
   end process;


   -- Catch outpus process
   catch_proc: process
   begin

      wait for 100 ns;

      for i in 1 to 16 loop
         wait for clk_period;
         real_output_vectors(i) <= g_next;
      end loop;

      wait for clk_period;
      results_ready <= '1';

      wait;
   end process;


   -- compare results process
   copmare_proc: process

      variable Message : line;
      variable inline : line;
      variable tmp_vector : std_logic_vector(3 downto 0);

      file   fd    : text is in  "../../../../src/gray_golden_output.txt";

      variable j : integer;
      variable error : boolean := false;

   begin

      ---- read golden data
      j := 1;
      while (not endfile(fd)) loop
         readline(fd, inline);
         read(inline,tmp_vector);
         expected_output_vectors(j) <= tmp_vector;
         j := j + 1;
      end loop;

      wait until results_ready = '1';

      for i in 1 to 16 loop
         test_result(i) <= (real_output_vectors(i) = expected_output_vectors(i));
         if (not test_result(i)) then
            error := true;
         end if;
      end loop;

      wait for clk_period;


      Write ( Message, LF);
      Write ( Message, string'("-- DRP Cycle Tests Completed!")&LF);
      Write ( Message, string'("-- Summary:")&LF);

      for i in 1 to 16 loop
         if (test_result(i)) then
            Write ( Message, string'("-- Test "));
            Write ( Message, i);
            Write ( Message, string'(": PASS")&LF);
         else
            Write ( Message, string'("-- Test "));
            Write ( Message, i);
            Write ( Message, string'(": FAIL")&LF);
         end if;
      end loop;

      writeline(output, Message);
      
      if (error) then
         Write ( Message, string'("Status Error"));
      else 
         Write ( Message, string'("Status OK"));
      end if; 
        
      writeline(output, Message);  

      wait;
   end process;
end;
