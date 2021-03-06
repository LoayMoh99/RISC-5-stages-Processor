
Library ieee;
use ieee.std_logic_1164.all;

Entity LoayregisterNoCLK is
Generic(n:integer :=32);
port (
Rin:in std_logic_vector(n-1 downto 0);
clk,rst,en:in std_logic;
Rout:out std_logic_vector(n-1 downto 0));
end LoayregisterNoCLK;
ARCHITECTURE reg_arch of LoayregisterNoCLK is
begin
Rout<= (others =>'0') when (rst ='1')
	else Rin when en='1';

end reg_arch;


