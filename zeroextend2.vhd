LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity zeroextend2 IS
PORT( input:IN std_logic_vector(19 downto 0);
output:out std_logic_vector(31 downto 0));
END zeroextend2;

ARCHITECTURE archz of zeroextend2 is
Begin 

output(19 downto 0) <=input;
output(31 downto 20) <= "000000000000";

End archz;
