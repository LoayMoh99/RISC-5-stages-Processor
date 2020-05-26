Library ieee;
use ieee.std_logic_1164.all;

Entity Mux4x1 is
generic(n:integer :=32);
port(
in1,in2,in3,in4: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic_vector(1 downto 0);
outMx : out std_logic_vector(n-1 downto 0));
end entity mux4x1;

ARCHITECTURE archM of Mux4x1 is
Begin 
outMx <= in1 when sel ="00"
	Else in2 when sel ="01"
	Else in3 when sel ="10"
	Else in4 when sel ="11";
End archM;