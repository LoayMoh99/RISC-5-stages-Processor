Library ieee;
use ieee.std_logic_1164.all;
Entity ZEROEXTRACT
IS Port (
 zeroEin: IN std_logic_vector (31 downto 0);
 zeroEout: OUT std_logic_vector (3 downto 0));
End entity ZEROEXTRACT;

Architecture archZE of ZEROEXTRACT is
Begin 
zeroEout<= zeroEin(3 downto 0);

End archZE;
