LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Mem IS
PORT(clk,we,re : IN std_logic; 
address : IN  std_logic_vector(11 DOWNTO 0);
dataIn  : IN  std_logic_vector(31 DOWNTO 0);
dataOut : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY Mem;

ARCHITECTURE arch_Mem OF Mem IS
TYPE Mem_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
SIGNAL Mem : Mem_type ;
BEGIN
PROCESS(clk) IS
BEGIN
		IF rising_edge(clk) THEN  
			IF we = '1' THEN
				Mem(to_integer(unsigned(address))) <= dataIn(15 downto 0);
                                Mem(to_integer(unsigned(address))+1) <= dataIn(31 downto 16);
			END IF;
		END IF;
		--elsiF falling_edge(clk) THEN  
		 --	IF re='1' THEN
                 --              dataOut(15 downto 0) <= Mem(to_integer(unsigned(address)));
                  --             dataOut(31 downto 16) <= Mem(to_integer(unsigned(address))+1);
              		-- END IF;
		--END IF;
                
END PROCESS;
                               dataOut(15 downto 0) <= Mem(to_integer(unsigned(address))) when re='1';
                               dataOut(31 downto 16) <= Mem(to_integer(unsigned(address))+1) when re='1';
END arch_Mem;
