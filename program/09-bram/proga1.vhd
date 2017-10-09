library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb is   
end tb;

architecture arch of tb is

--Объявление временных сигналов
signal ena : std_logic := '0';
signal wea : std_logic_VECTOR(0 downto 0):="0";
signal addra : std_logic_vector (3 downto 0) := (others=> '0');
signal dina,douta : std_logic_VECTOR(7 downto 0) := (others => '0');
signal clk : std_logic := '0';

begin

--Инстанциация (подключение) модуля BRAM (из файла .vho)
BRAM : entity work.BRAM_sample
    port map(
    clka => clk,  --clock for writing data to RAM.
    ena => ena,   --Enable signal.
    wea => wea,   --Write enable signal for Port A.
    addra => addra, --8 bit address for the RAM.
    dina => dina,   --8 bit data input to the RAM.
    douta => douta);  --8 bit data output from the RAM. 
clk <= not clk after 10 ns;
--Процесс симуляции
process
begin
    wait for 10 ns;
    --Заполняем ячейки BRAM данными. Для этого устанавливаем wea в "1".
    for i in 0 to 15 loop
        ena <= '1';  --RAM Работает всегда.
        wea <= "1";
        wait for 20 ns;
        addra <= addra + "1";
        dina <= dina + "1";
    end loop;   
    addra <= "0000";  --сбрасываем параметр адреса в 0
    for i in 0 to 15 loop
        ena <= '1';  --RAM Работает всегда.
        wea <= "0";
        wait for 20 ns;
        addra <= addra + "1";
    end loop;
    wait;
end process;     
end arch;
\end{lstlisting}
\end{Code}