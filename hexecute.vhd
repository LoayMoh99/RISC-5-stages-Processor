Library ieee;
use ieee.std_logic_1164.all;

Entity EXECUTE is
generic(n: integer :=32);
port(
pcin,regfiledata1,ALUoutmem,WBdata,regfiledata2,immvaluein,effaddin,readdatafromMEM: IN std_logic_vector (n-1 downto 0);
BRenable,Rst,clk: IN std_logic;
BRtype,forwardA,forwardB,carryenab: IN std_logic_vector (1 downto 0);
Rdestin,Rdest2in: IN std_logic_vector (2 downto 0);
instr: IN std_logic_vector (4 downto 0); --instruction[4,0]
ALUOP,wrflags: IN std_logic;
flags,pcout,effaddout,ALUout,DATASWAP,PCJMP,BRANCH,toOUTPORT: OUT std_logic_vector (n-1 downto 0); --PCJMP IN THE DECODE STAGE
--BRANCH IN FETCH STAGE
Rdestout,Rdest2out: OUT std_logic_vector (2 downto 0); 
BRTAKEN :OUT std_logic);
end EXECUTE;

ARCHITECTURE STRUCTEXECUTE of EXECUTE is
component ALU is
generic(n: integer :=32);
port(
in1,in2: IN std_logic_vector (n-1 downto 0);

sel: IN std_logic_vector (4 downto 0);

outALU: OUT std_logic_vector (n-1 downto 0);
flagout: OUT std_logic_vector (3 downto 0)); ---zawdtha 3ashan output lel ccr
end component;
--CCR
component CCRregister is

port (
inflags:in std_logic_vector(3 downto 0);
clkk,rstt,brTaken:in std_logic;
carryenable: in std_logic_vector(1 downto 0);
branchtype: in std_logic_vector(1 downto 0);
outflags:out std_logic_vector(3 downto 0)); --for flags

end component;

--MUX4X1
component Mux4x1 is
generic(n:integer :=32);
port(
in1,in2,in3,in4: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic_vector(1 downto 0);
outMx : out std_logic_vector(n-1 downto 0));
end component;

component Mux4x11 is
port(
in11,in22,in33,in44: IN std_logic;
sell: IN std_logic_vector(1 downto 0);
outMxx : out std_logic);
end component;

--MUX2X1
component mux1 is 
generic(n : integer :=32);
port ( inn1,inn2 : in  std_logic_vector (n-1 downto 0);
       sel2 : in std_logic ;
       outt1 : out std_logic_vector (n-1 downto 0));
end component;


component ZEROEXTEND
IS Port (
 zeroin: IN std_logic_vector (3 downto 0);
 zeroout: OUT std_logic_vector (31 downto 0));
End component;

component ZEROEXTRACT
IS Port (
 zeroEin: IN std_logic_vector (31 downto 0);
 zeroEout: OUT std_logic_vector (3 downto 0));
End component;
signal temp1 ,temp2 : std_logic_vector (31 downto 0);
signal out2mux2toALU ,out1mux2toALU : std_logic_vector (31 downto 0);
signal flagsoutfromALU ,outofzeroextract,inflagstoccr,OUTflagsfromccr: std_logic_vector (3 downto 0);
signal outflagtobr,Br_Taken : std_logic;
signal outmux2x1: std_logic_vector (4 downto 0);
begin
-- 2nd mux to alu
MUX421 : Mux4x1 GENERIC MAP(n) port map(regfiledata2,immvaluein,ALUoutmem,WBdata,forwardB,temp1);
--out2mux2toALU<=temp1;
DATASWAP<=temp1;

--1st mux to alu
MUX311 : Mux4x1 GENERIC MAP(n) port map(regfiledata1,regfiledata1,ALUoutmem,WBdata,forwardA,temp2);
--out1mux2toALU<=temp2;
PCJMP<=temp2;
toOUTPORT<=temp2;
BRANCH<=temp2;


-- ALU
ALU1: ALU GENERIC MAP(n) port map (temp2,temp1,instr,ALUout,flagsoutfromALU);
--mux 2x1 as a selector to ALU func
--muxselector: mux1 GENERIC MAP(5) port map(instr,"10000",ALUOP,outmux2x1);

--flags from alu to mux 2x1
MUX2x1fromalu: mux1 GENERIC MAP(4) port map(flagsoutfromALU,outofzeroextract,wrflags,inflagstoccr);
--zero extract
zeroextract1: ZEROEXTRACT port map( readdatafromMEM   ,outofzeroextract);
Br_Taken<= ( outflagtobr AND BRenable);
--ccr
CCR1 :  CCRregister  port map (inflagstoccr ,clk ,Rst,Br_Taken ,carryenab,BRtype,OUTflagsfromccr);
--ccr1: CCRregister 
zeroextend1: ZEROEXTEND port map (OUTflagsfromccr,flags);
--flags to mux4x1
MUX423 : Mux4x11 port map('1',OUTflagsfromccr(0),OUTflagsfromccr(1),OUTflagsfromccr(2),BRtype,outflagtobr);

BRTAKEN <=Br_Taken;
pcout<=pcin;
effaddout<=effaddin;
Rdestout<=Rdestin;
Rdest2out<=Rdest2in;

end STRUCTEXECUTE;
