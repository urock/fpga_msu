library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package crc_pkg is

  constant IP_HEAD_LENGTH: positive := 20;
  
  type ip_header_t is array (integer range 0 to IP_HEAD_LENGTH-1) of std_logic_vector(7 downto 0);
  type crc_input_t is array (integer range 0 to ((IP_HEAD_LENGTH-2)/2)-1) of std_logic_vector(15 downto 0);

  type s1_t is array (integer range 0 to 3) of std_logic_vector(16 downto 0);
  type s2_t is array (integer range 0 to 1) of std_logic_vector(17 downto 0);
  type s3_t is array (integer range 0 to 1) of std_logic_vector(18 downto 0);

end; 