Library ieee;
use ieee.std_logic_1164.all;

Entity stadder is
generic(n:integer :=32);
port(
inSP: IN std_logic_vector(n-1 downto 0);
sel,en: IN std_logic;--sel->stackAddr 
outSP : out std_logic_vector(n-1 downto 0));
end entity stadder;

ARCHITECTURE archst of stadder is
component my_Nadder IS
GENERIC(n:integer :=32);
PORT (a,b : IN  std_logic_vector(n-1 downto 0);
	cin : IN std_logic;
	cout : OUT std_logic;
	s: OUT std_logic_vector(n-1 downto 0));
END component;

Signal aa1,aa2: std_logic_vector(n-1 downto 0);
Signal twoo: std_logic_vector(31 downto 0):=x"00000002";
Signal twocomp: std_logic_vector(31 downto 0):=x"FFFFFFFE";

signal cin: std_logic :='0';
signal cout: std_logic ;

begin
a1: my_Nadder generic map(n) port map(inSP,twoo,cin,cout,aa1);
a2: my_Nadder generic map(n) port map(inSP,twocomp,cin,cout,aa2);
outSP<=aa1 when sel='1' and en='1'
	else aa2 when sel='0' and en='1'
	else inSP;

End archst;
