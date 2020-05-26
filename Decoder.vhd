LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY decoder IS
PORT( enable: IN std_logic; in1:IN std_logic_vector(2 downto 0);
out1:out std_logic_vector(7 downto 0));
END decoder;


ARCHITECTURE dec OF decoder IS
BEGIN
PROCESS (enable)
BEGIN
IF enable='1' THEN

if in1="000"  then out1<="00000001";
 elsif in1="001"  then out1<="00000010";
 elsif in1="010" then out1<="00000100";
 elsif in1="011" then out1<="00001000";
 elsif in1="100" then out1<="00010000";
 elsif in1="101" then out1<="00100000";
 elsif in1="110" then out1<="01000000";
 elsif in1="111" then out1<="10000000";
End if;
else

out1<="00000000";

END IF;
END PROCESS;
END dec;



