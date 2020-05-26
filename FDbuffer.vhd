LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FDbuffer IS
PORT    (
Instruction: IN std_logic_vector(31 downto 0);
PC: IN std_logic_vector(31 downto 0);
Clk,Stall,Flush :in std_logic;
OutInstruction: OUT std_logic_vector(31 downto 0);
OutPC: OUT std_logic_vector(31 downto 0));

END ENTITY FDbuffer;

ARCHITECTURE arch_FDbuffer OF FDbuffer IS

component Loayregister IS
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
begin
enable <= not Stall;

PC1: Loayregister PORT MAP(PC,Clk,'0',enable,OutPC);
Inst1: Flushreg PORT MAP(Instruction,Clk,Flush,enable,OutInstruction);
END arch_FDbuffer;