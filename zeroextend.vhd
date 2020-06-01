Library ieee;
use ieee.std_logic_1164.all;
Entity ZEROEXTEND
IS Port (
 zeroin: IN std_logic_vector (3 downto 0);
 zeroout: OUT std_logic_vector (31 downto 0));
End entity ZEROEXTEND;

Architecture archZ of ZEROEXTEND is
Begin 
zeroout(3 downto 0)<= zeroin;
zeroout(31 downto 4)<="0000000000000000000000000000";
End archZ;
