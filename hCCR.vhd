Library ieee;
use ieee.std_logic_1164.all;

Entity CCRregister is

port (
inflags:in std_logic_vector(3 downto 0);
clkk,rstt,brTaken:in std_logic;
carryenable: in std_logic_vector(1 downto 0);
branchtype: in std_logic_vector(1 downto 0);
outflags:out std_logic_vector(3 downto 0)); --for flags

end CCRregister;
ARCHITECTURE reg_arch of CCRregister is
begin
Process(clkk,rstt,inflags,carryenable,branchtype) 
--this is mainly used for sequential circuits while combinational also can be performed 
--but you have to put all it's inputs in the sensitivity list
begin
if(rstt ='1') then
   outflags<= "0000";
elsif  rising_edge(clkk) then
	if (carryenable /="00") then
		if carryenable="01" then
			outflags<=inflags;
		elsif carryenable="11" then
			outflags(1)<='1';
		elsif carryenable="10" and brTaken='1' then
			if branchtype="01" then --Z-flag
				outflags(0) <= '0';
			elsif branchtype="10" then --C-flag
				outflags(1) <= '0';
			elsif branchtype="11" then --N-flag
				outflags(2) <= '0';
			end if;
		end if;
	end if; 
	
end if;
end process;
end reg_arch;

