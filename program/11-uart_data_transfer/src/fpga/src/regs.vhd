
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity reg_file is

   port(
      clk 		: in std_logic;
      reset_n 	   : in std_logic;

      addr	   : in  std_logic_vector(7 downto 0);
      we    	: in  std_logic; 
      din   	: in  std_logic_vector(31 downto 0);
      
      re	      : in  std_logic;
      dout   	: out std_logic_vector(31 downto 0)

   );
end reg_file;

architecture rtl of reg_file is

signal reg_0 : std_logic_vector(31 downto 0);
signal reg_1 : std_logic_vector(31 downto 0);
signal reg_2 : std_logic_vector(31 downto 0);
signal reg_3 : std_logic_vector(31 downto 0);

begin

process(clk)
begin
   if rising_edge(clk) then
      if reset_n = '0' then
         reg_0 <= (others => '0');
         reg_1 <= (others => '0');
         reg_2 <= (others => '0');
         reg_3 <= (others => '0');
      else 
      
         if we = '1' then
            case addr is
               when X"00" => reg_0 <= din; 
               when X"01" => reg_1 <= din;                 
               when X"02" => reg_2 <= din; 
               when X"03" => reg_3 <= din;   
               when others => null;                
            end case;
            
         end if;
         
         if re = '1' then
            case addr is
               when X"00" => dout <= reg_0; 
               when X"01" => dout <= reg_1;                 
               when X"02" => dout <= reg_2; 
               when X"03" => dout <= reg_3;   
               when others => dout <= X"BEBEBEBE";                 
            end case;         
         
         end if; 
         
      end if; -- reset_n
   end if;
end process; 

   
               
               
end rtl;