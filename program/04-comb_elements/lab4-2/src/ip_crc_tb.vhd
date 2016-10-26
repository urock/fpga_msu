library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;


entity ip_crc_tb is
end ip_crc_tb;

architecture behavior of ip_crc_tb is

   constant IP_HEAD_LENGTH: positive := 20;

   -- file I/O stuff
   type std_logic_vector_file is file of std_logic_vector(7 downto 0);

   type ip_header_t is array (integer range 0 to IP_HEAD_LENGTH-1) of std_logic_vector(7 downto 0);
   
   signal ip_head : ip_header_t;  


begin


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

end;



