Library ieee;
use ieee.std_logic_1164.all;

Entity mux2 is
generic(n:integer :=32);
port(
in1,in2: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic;
outMx : out std_logic_vector(n-1 downto 0));
end entity mux2;

ARCHITECTURE archmx of mux2 is
Begin 
outMx <= in1 when sel ='0'
	Else in2 when sel ='1';
End archmx;
