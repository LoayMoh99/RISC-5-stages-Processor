LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity zeroextend1 IS
PORT( input:IN std_logic_vector(15 downto 0);
output:out std_logic_vector(31 downto 0));
END zeroextend1;

ARCHITECTURE archz of zeroextend1 is
Begin 
output(15 downto 0)<= input(15 downto 0);
output(31 downto 16) <= "0000000000000000";
End archz;
