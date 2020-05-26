Library ieee;
use ieee.std_logic_1164.all;

Entity PC_reg is
Generic(n:integer :=16);
port (
dataIn:in std_logic_vector(n-1 downto 0);
clk,rst,en:in std_logic;
dataOut:out std_logic_vector(n-1 downto 0));
end PC_reg;

ARCHITECTURE PC_arch of PC_reg is
begin
Process(clk) 
begin
if(rst ='1') then
   dataOut<= (others=>'0');
elsif  rising_edge(clk) then
	if en='1' then
		dataOut<=DataIn;
	end if;
end if;
end process;
end PC_arch ;

--reset=0  enble=1


