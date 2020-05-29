LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FU_FD IS
GENERIC (n : integer := 32);
PORT    (
clk,StallCU,StallHU,Call,Int1,Reset ,Flush,Int2,Reset1: IN std_logic; 

Branch,PoppedPC: IN std_logic_vector(31 downto 0); --decide pc
PCsrc ,ChangePC: IN std_logic; 
callRdst: IN std_logic_vector(31 downto 0); --deceide pc after int reset

InstructionbitsBuffer: OUT std_logic_vector(31 downto 0);
PC_Buffer: OUT std_logic_vector(31 downto 0));
END ENTITY FU_FD;

ARCHITECTURE FU_FD_arch of FU_FD IS
component FetchUnit IS
GENERIC (n : integer := 32);
PORT    (

clk,StallCU,StallHU,Call,Int1,Reset1 ,Int2,Reset2: IN std_logic; 

Branch,PoppedPC: IN std_logic_vector(31 downto 0); --decide pc
PCsrc ,ChangePC: IN std_logic; 
callRdst: IN std_logic_vector(31 downto 0); --deceide pc after int reset

Instructionbits: OUT std_logic_vector(31 downto 0);
PC: OUT std_logic_vector(31 downto 0));
END component;
component FDbuffer IS
PORT    (
Instruction: IN std_logic_vector(31 downto 0);
PC: IN std_logic_vector(31 downto 0);
Clk,Stall,Flush :in std_logic;
OutInstruction: OUT std_logic_vector(31 downto 0);
OutPC: OUT std_logic_vector(31 downto 0));

END component;
signal Instructionbitst:std_logic_vector(31 downto 0);    	
signal PCt:std_logic_vector(31 downto 0);  
signal F:std_logic;
begin

fu: FetchUnit  GENERIC MAP (n)  PORT MAP(clk=>clk,
StallCU=>StallCU,
StallHU=>StallHU,
Call=>Call,
Int1=>INT1,
Reset1=>Reset,
Int2=>INT2,
Reset2=> Reset1,
Branch=> Branch,
PoppedPC=>PoppedPC,
PCsrc=>	PCsrc,
ChangePC=>ChangePC,
callRdst=>callRdst,
Instructionbits=>Instructionbitst,
PC=>PCt); 
F<=Flush or Reset;
bufferFD: FDbuffer  port map(Instruction=>Instructionbitst,
PC=>PCt,
Clk=>clk,
Stall=>StallCU,
Flush =>F,
OutInstruction=>InstructionbitsBuffer,
OutPC=>PC_Buffer);



end FU_FD_arch;