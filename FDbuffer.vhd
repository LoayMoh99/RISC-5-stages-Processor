
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FDbuffer IS
PORT    (
Instruction,inportIN: IN std_logic_vector(31 downto 0);
PC: IN std_logic_vector(31 downto 0);
Clk,Stall,Flush :in std_logic;
OutInstruction,inportOUT: OUT std_logic_vector(31 downto 0);
OutPC: OUT std_logic_vector(31 downto 0));

END ENTITY FDbuffer;

ARCHITECTURE arch_FDbuffer OF FDbuffer IS

component LoayregisterFalling IS
Generic(n:integer :=32);
PORT(
Rin:in std_logic_vector(31 downto 0);
clk,rst,en:in std_logic;
Rout:out std_logic_vector(31 downto 0)
);
END component;

component Flushreg IS
PORT(
Rin:in std_logic_vector(31 downto 0);
clk,rst,en:in std_logic;
Rout:out std_logic_vector(31 downto 0)
);
END component;


signal enable :std_logic;
signal reset :std_logic :='0';
begin
enable <= not Stall;

PC1: LoayregisterFalling Generic map(32) PORT MAP(PC,Clk,reset,enable,OutPC);
inport: LoayregisterFalling generic map(32) port map(inportIN,clk,Flush,enable,inportOUT);
Inst1: Flushreg PORT MAP(Instruction,Clk,Flush,enable,OutInstruction);
END arch_FDbuffer;