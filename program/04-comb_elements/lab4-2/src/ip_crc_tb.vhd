library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

USE work.crc_pkg.all;


entity ip_crc_tb is
end ip_crc_tb;

architecture behavior of ip_crc_tb is

   component crc_calc 
   port (
      clk      : in  std_logic;
      ip_head  : in  crc_input_t;
      crc_out  : out std_logic_vector(15 downto 0)
   );
   end component;

   
   signal ip_head : ip_header_t;  

   signal crc_input: crc_input_t; 

   signal clk : std_logic := '0'; 

   signal ip_crc_rtl  : std_logic_vector(15 downto 0);
   signal ip_crc_expt : std_logic_vector(15 downto 0);

   signal err: boolean := false;
begin

   clk <= not clk after 10 ns; 

   read_file_process: process
      file   fd    : text is in  "../../../../ip_header.txt";
      variable word: std_logic_vector(7 downto 0);--line;
      variable j : integer;
      variable Message : line;
      variable inline : line;
   begin      

      Write ( Message, string'("-- Reading data from file:  "));
      writeline(output, Message);
      j := 0;
      while (not endfile(fd)) loop

         assert (j < IP_HEAD_LENGTH)
            report "File bigger than IP Header"
            severity failure;

         readline(fd, inline);
         read(inline, word);

         ip_head(j) <= word;
         j := j + 1;
         Write ( Message, word);
         writeline(output, Message);

      end loop;   

      wait; 
   end process;

   -- input process
   crc_input(0) <= ip_head(0) & ip_head(1); 
   crc_input(1) <= ip_head(2) & ip_head(3); 
   crc_input(2) <= ip_head(4) & ip_head(5); 
   crc_input(3) <= ip_head(6) & ip_head(7); 
   crc_input(4) <= ip_head(8) & ip_head(9); 
   crc_input(5) <= ip_head(12) & ip_head(13);
   crc_input(6) <= ip_head(14) & ip_head(15); 
   crc_input(7) <= ip_head(16) & ip_head(17); 
   crc_input(8) <= ip_head(18) & ip_head(19);       

   ip_crc_expt <= ip_head(10) & ip_head(11);


   -- Instantiate the Design Under Test (DUT)
   dut: crc_calc port map (
         clk      => clk,
         ip_head  => crc_input,
         crc_out  => ip_crc_rtl
      );

   -- compare process
   process
      variable Message : line;   
      
   begin

      Write ( Message, string'("-- Waiting for RTL Output:  "));
      writeline(output, Message);   

      for i in 0 to 2 loop
         wait until rising_edge(clk); 
      end loop;    

      if (ip_crc_expt /= ip_crc_rtl) then
         err <= true; 
      else 
         err <= false;
      end if;

      wait until rising_edge(clk); 

      if (err) then
         Write ( Message, string'("-- Compare failed:  "));
         Write ( Message, ip_crc_expt);
         Write ( Message, ip_crc_rtl);
      else 
         Write ( Message, string'("-- Compare OK!"));
      end if;
      writeline(output, Message);
      wait;
   end process;
end;



