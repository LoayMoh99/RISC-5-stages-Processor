Library ieee;
use ieee.std_logic_1164.all;

Entity Mux4x11 is

port(
in11,in22,in33,in44: IN std_logic;
sell: IN std_logic_vector(1 downto 0);
outMxx : out std_logic);
end entity mux4x11;

ARCHITECTURE archMm of Mux4x11 is
Begin 
outMxx <= in11 when sell ="00"
	Else in22 when sell ="01"
	Else in33 when sell ="10"
	Else in44 when sell ="11";
End archMm;
