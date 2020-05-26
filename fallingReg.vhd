Library ieee;
use ieee.std_logic_1164.all;

Entity LoayregisterFalling is
Generic(n:integer :=8);
port (
Rin:in std_logic_vector(n-1 downto 0);
clk,rst,en:in std_logic;
Rout:out std_logic_vector(n-1 downto 0));
end LoayregisterFalling;
ARCHITECTURE reg_arch of LoayregisterFalling is
begin
Process(clk,rst) 
--this is mainly used for sequential circuits while combinational also can be performed 
--but you have to put all it's inputs in the sensitivity list
begin
if(rst ='1') then
   Rout<= (others=>'0');
elsif  falling_edge(clk) then
	if en='1' then
		Rout<=Rin;
	end if;
end if;
end process;
end reg_arch;

