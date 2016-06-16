library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity g_inc is
    generic (
        WIDTH: natural := 4
    );
    port (
        g : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
        g_next : out STD_LOGIC_VECTOR (WIDTH-1 downto 0)
    );
end g_inc;

architecture compact_arch of g_inc is
    signal b, b_next: std_logic_vector(WIDTH-1 downto 0);
begin
    -- Gray to binary
	b <= g xor ('0' & b(WIDTH-1 downto 1));
	-- binary increment
	b_next <= b + 1;
	-- binary to Gray
	g_next <= b_next xor ('0' & b_next(WIDTH-1 downto 1));
end compact_arch;