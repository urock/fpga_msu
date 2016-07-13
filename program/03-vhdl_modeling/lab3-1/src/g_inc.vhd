library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity g_inc is
   generic (
      word_w: natural := 4
   );
   port (
      g : in std_logic_vector (word_w-1 downto 0);
      g_next : out std_logic_vector (word_w-1 downto 0)
   );
end g_inc;

architecture compact_arch of g_inc is
   signal b, b_next: std_logic_vector(word_w-1 downto 0);
begin
   -- Gray to binary
   b <= g xor ('0' & b(word_w-1 downto 1));
   -- binary increment
   b_next <= b + 1;
   -- binary to Gray
   g_next <= b_next xor ('0' & b_next(word_w-1 downto 1));
end compact_arch;