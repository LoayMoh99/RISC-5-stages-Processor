LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
-----------------------------------------------------------
entity HazardDetection is
port(
F_D_Rsrc1:in std_Logic_vector(2 downto 0); --first operand of current instruction
F_D_Rsrc2:in std_logic_vector(2 downto 0); --second operand of current instruction
D_E_Rdest:in std_Logic_vector(2 downto 0);--destination of the pervious instruction 
D_E_Rdest2:in std_Logic_vector(2 downto 0);
intSelec:in std_logic_vector(2 downto 0); -- INterrupt determination
----------------------------------------------------------- 
D_E_Mem_read:in std_logic; --control sgnal in memory stage
Br_Taken,clk:in std_logic; --from AND gate
------------------------------------------------------------
F_flush:out std_logic; 
D_flush:out std_logic;
stall:out std_logic;
resetCounter:out std_logic
); 
end entity HazardDetection;

architecture detect  of HazardDetection is
signal enteredBefore:std_logic; --0=NO and 1=yes
begin 
process(clk,F_D_Rsrc1,F_D_Rsrc2,D_E_Rdest,D_E_Rdest2 ,intSelec,D_E_Mem_read,Br_Taken)
begin 
if rising_edge(clk) and enteredBefore='0' then
if( (F_D_Rsrc1=D_E_Rdest or F_D_Rsrc2=D_E_Rdest) and D_E_Mem_read='1') then
      stall<='1' ;
      D_flush<='1';
      F_flush<='0';
      resetCounter<='0';
enteredBefore<='1';
elsif( (F_D_Rsrc1=D_E_Rdest2 or F_D_Rsrc2=D_E_Rdest2) and D_E_Mem_read='1') then
      stall<='1' ;
      D_flush<='1';
      F_flush<='0';
      resetCounter<='0';
enteredBefore<='1';
elsif(Br_Taken='1' and intSelec/="001")then
--Flushing the instructions in Fetch and Decode and Reset Counter in the CU
   D_flush<='1';
   F_flush<='0';
   resetCounter<='1';
   stall<='0';
enteredBefore<='1';
elsif(Br_Taken='1' and intSelec="001")then
 D_flush<='1';
 F_flush<='1';
 resetCounter<='0';
 stall<='0';
enteredBefore<='1';
else 
 D_flush<='0';
 F_flush<='0';
 resetCounter<='0';
 stall<='0';
enteredBefore<='0';
end if;
else 
 D_flush<='0';
 F_flush<='0';
 resetCounter<='0';
 stall<='0';
enteredBefore<='0';
end if;
end process;
End detect;