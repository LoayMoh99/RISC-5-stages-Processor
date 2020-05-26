Library ieee;
use ieee.std_logic_1164.all;

Entity stadder is
generic(n:integer :=32);
port(
inp1: IN std_logic_vector(n-1 downto 0);
--inp2: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic;
outst : out std_logic_vector(n-1 downto 0));
end entity stadder;

ARCHITECTURE archst of stadder is
component my_Nadder IS
GENERIC(n:integer :=32);
PORT (a: IN  std_logic_vector(n-1 downto 0);
b : IN  std_logic_vector(n-1 downto 0);
	--cout : OUT std_logic;
	s: OUT std_logic_vector(n-1 downto 0));
end component;
component mux2 is
generic(n:integer :=32);
port(
in1,in2: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic;
outMx : out std_logic_vector(n-1 downto 0));
end component;

Signal aa1,aa2: std_logic_vector(n-1 downto 0);
Signal twoo: std_logic_vector(31 downto 0):=x"00000002";
Signal twocomp: std_logic_vector(31 downto 0):=x"FFFFFFFE";

Begin 

a1: my_Nadder generic map(n) port map(inp1,twoo,aa1);
a2: my_Nadder generic map(n) port map(inp1,twocomp,aa2);
m1: mux2 generic map(n) port map(aa1,aa2,sel,outst); 

End archst;
