library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

USE work.crc_pkg.all;

entity crc_calc is
   port (
      clk            : in  std_logic;
      ip_head        : in  crc_input_t;
      header_valid   : in  std_logic;
      crc_out        : out std_logic_vector(15 downto 0);
      crc_valid      : out std_logic
   );
end crc_calc;

architecture rtl of crc_calc is

signal ip_head_reg : crc_input_t; 

signal s1 : s1_t;
signal temp17_reg : std_logic_vector(16 downto 0);
signal temp18_reg : std_logic_vector(17 downto 0);
signal s2 : s2_t;
signal s3 : s3_t;

signal sum : std_logic_vector(19 downto 0); 
signal sum16 : std_logic_vector(15 downto 0); 

signal crc_reg    : std_logic_vector(15 downto 0);

   
begin

process(clk)
begin
   if rising_edge(clk) then
      ip_head_reg <= ip_head; 
   end if; 
end process;


process(clk)
begin
   if rising_edge(clk) then
      for i in 0 to 3 loop
         s1(i) <= ('0' & ip_head_reg(2*i)) + ('0' & ip_head_reg(2*i + 1)); 
      end loop; 

      temp17_reg <= '0' & ip_head_reg(8); 
   end if;
end process;


process(clk)
begin
   if rising_edge(clk) then

      s2(0) <= ('0' & s1(0)) + ('0' & s1(1)); 
      s2(1) <= ('0' & s1(2)) + ('0' & s1(3));   

      temp18_reg <= '0' & temp17_reg; 

   end if;
end process;

process(clk)
begin
   if rising_edge(clk) then

      s3(0) <= ('0' & s2(0)) + ('0' & s2(1)); 
      s3(1) <= '0' & temp18_reg;    

   end if;
end process;

process(clk)
begin
   if rising_edge(clk) then

      sum <= ('0' & s3(0)) + ('0' & s3(1));    

   end if;
end process;


process(clk)
begin
   if rising_edge(clk) then

      sum16 <= (X"00" & sum(19 downto 16)) + sum(15 downto 0);

   end if;
end process;



process(clk)
begin
   if rising_edge(clk) then
      crc_reg <= not sum16; 
   end if; 
end process;

crc_out <= crc_reg; 

end rtl;