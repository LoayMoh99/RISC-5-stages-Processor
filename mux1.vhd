library ieeE;
use ieee.std_logic_1164.all;
entity mux1 is generic(n : integer :=16);
port ( inn1,inn2 : in  std_logic_vector (n-1 downto 0);
       sel2 : in std_logic ;
       outt1 : out std_logic_vector (n-1 downto 0));
end entity mux1;

architecture archmux1 of mux1 is
begin 
outt1<= inn1 when sel2='0'
else inn2  ;

end archmux1;