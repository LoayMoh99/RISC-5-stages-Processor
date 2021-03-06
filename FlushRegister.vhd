Library ieee;
use ieee.std_logic_1164.all;

Entity Flushreg is
port (
Rin:in std_logic_vector(31 downto 0);
clk,rst,en:in std_logic;
Rout:out std_logic_vector(31 downto 0));
end Flushreg;
ARCHITECTURE Flushreg_arch of Flushreg is
begin
Process(clk,rst) 
--this is mainly used for sequential circuits while combinational also can be performed 
--but you have to put all it's inputs in the sensitivity list
begin
if(rst ='1') then
   Rout<= x"00000010";
elsif  falling_edge(clk) then
	if en='1' then
		Rout<=Rin;
	end if;
end if;
end process;
end Flushreg_arch;

