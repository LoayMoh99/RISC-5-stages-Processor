library ieeE;
use ieee.std_logic_1164.all;
entity mux2 is 
port ( innn1,innn2 ,innn3 : in  std_logic_vector (31 downto 0);
       sel2 : in std_logic_vector (1 downto 0);
       outt1 : out std_logic_vector (31 downto 0));
end entity mux2;

architecture archmux2 of mux2 is
begin 
outt1<= innn1 when sel2(0)='1' and sel2(1)='0'
else innn2 when sel2(0)='1' and sel2(1)='1'
else innn3 when sel2(0)='0' and sel2(1)='0';

end archmux2;