LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

Entity InstMemory is

port (
Clk : IN std_logic;
Address:in std_logic_vector(11 downto 0);
Instruction:out std_logic_vector(31 downto 0));
end InstMemory;

ARCHITECTURE Mem_arch of InstMemory is
TYPE InstMemory_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
SIGNAL InstMem : InstMemory_type ;
begin


	Instruction(15 downto 0) <= InstMem(to_integer(unsigned(Address)));
	Instruction(31 downto 16) <= InstMem(to_integer(unsigned(Address))+1);


end Mem_arch;
