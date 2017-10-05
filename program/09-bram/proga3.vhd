library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;


entity bram_tb is
end bram_tb;

architecture arch of bram_tb is
type num_input1 is array (integer range 0 to 15) of std_logic_vector(15 downto 0);

   
   signal dout : std_logic_vector (15 downto 0);  
   signal num_input: num_input1;
   signal din: std_logic_vector (15 downto 0); 
   signal dv_in,dv_out:std_logic;
   signal clk : std_logic := '0'; 
   signal reset: std_logic;
   signal err: boolean := false;
   
   
begin
 dut: entity work.bram (arch)
 
port map (
clk=>clk,
dout=>dout,
dv_in=>dv_in,
dv_out=>dv_out,
din=>din,
reset=>reset
);
   clk <= not clk after 10 ns; 

   read_file_process: process
      file   fd    : text is in  ".../ip_header.txt";
      variable word: std_logic_vector(15 downto 0);--line;
      variable j : integer;
      variable Message : line;
      variable inline : line;
   begin      

      Write ( Message, string'("- Reading data from file:  "));
      writeline(output, Message);
      j := 0;
      for i in 0 to 15 loop

         assert (j < 16)
            report "File bigger than IP Header"
            severity failure;

         readline(fd, inline);
         read(inline, word);
         num_input(j)<=word;
         j := j + 1;
         Write ( Message, word);
         writeline(output, Message);

      end loop;   
--      valid<='1';
--     wait for 30 ns;
--     valid<='0'; 
      wait;
   end process;

   -- input process
   process
   begin
   reset<='1';
   wait for 100 ns;
   reset <='0';
   wait for 20 ns;
   for i in 0 to 15 loop
        din<=num_input(i);
        dv_in<='1';
        wait for 20 ns;
        
    end loop;
    dv_in<='0';
    wait;
    end process;


   -- compare process
   process
      variable Message : line;   
      
   begin
      Write ( Message, string'("- Waiting for RTL Output:  "));
      writeline(output, Message);   

      for i in 0 to 2 loop
         wait until rising_edge(clk); 
      end loop;  
      wait until (dv_out='1');  
      wait for 20 ns;
      for k in 0 to 15 loop
            
      if (dout /= num_input(k)) then
         err <= true; 
         Write ( Message, num_input(k));
         writeline(output, Message);
         Write ( Message, dout);
         writeline(output, Message);
      else 
         err <= false;
      end if;
      wait until rising_edge(clk); 
      end loop;

      wait until rising_edge(clk); 

      if (err) then
         Write ( Message, string'("- Compare failed:  "));
      else 
         Write ( Message, string'("- Compare OK!"));
      end if;
      writeline(output, Message);
      wait;
   end process;
end;