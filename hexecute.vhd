Library ieee;
use ieee.std_logic_1164.all;

Entity EXECUTE is
generic(n: integer :=32);
port(
pcin,regfiledata1,ALUoutmem,WBdata,regfiledata2,immvaluein,effaddin,readdatafromMEM: IN std_logic_vector (n-1 downto 0);
BRenable,Rst,clk: IN std_logic;
BRtype,forwardA,forwardB,carryenab: IN std_logic_vector (1 downto 0);
Rdestin,Rdest2in: IN std_logic_vector (2 downto 0);
instr: IN std_logic_vector (3 downto 0); --instruction[3,0]
cin1,ALUOP,wrflags: IN std_logic;
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

sel: IN std_logic_vector (3 downto 0);

outALU: OUT std_logic_vector (n-1 downto 0);
flagout: OUT std_logic_vector (3 downto 0)); ---zawdtha 3ashan output lel ccr
end component;
--CCR
component CCRregister is

port (
inflags:in std_logic_vector(3 downto 0);
clkk,rstt:in std_logic;
carryenable: in std_logic_vector(1 downto 0);
branchtype: in std_logic_vector(1 downto 0);
outflags:out std_logic_vector(3 downto 0)); --for flags

end component;
--MUX4X1

COMPONENT Mux4x11 is

port(
in11,in22,in33,in44: IN std_logic;
sell: IN std_logic_vector(1 downto 0);
outMxx : out std_logic);
end COMPONENT;




--MUX4X1
component Mux4x1 is
generic(n:integer :=32);
port(
in1,in2,in3,in4: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic_vector(1 downto 0);
outMx : out std_logic_vector(n-1 downto 0));
end component;

--MUX3X1
component mux2 is 
port ( innn1,innn2 ,innn3 : in  std_logic_vector (31 downto 0);
       sel2 : in std_logic_vector (1 downto 0);
       outt1 : out std_logic_vector (31 downto 0));
end component;
--MUX2X1

component mux1 is generic(n : integer :=16);
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

signal out2mux2toALU ,out1mux2toALU : std_logic_vector (31 downto 0);
signal outmux2x1,flagsoutfromALU ,outofzeroextract,inflagstoccr,OUTflagsfromccr: std_logic_vector (3 downto 0);
signal outflagtobr : std_logic;
begin
-- 2nd mux to alu
MUX421 : Mux4x1 GENERIC MAP(n) port map(regfiledata2,immvaluein,ALUoutmem,WBdata,forwardB,out2mux2toALU);
-- 2nd mux to data swap
MUX422 : Mux4x1 GENERIC MAP(n) port map(regfiledata2,immvaluein,ALUoutmem,WBdata,forwardB,DATASWAP);


--1st mux to alu
MUX311 : mux2  port map(regfiledata1,ALUoutmem,WBdata,forwardA,out1mux2toALU);
--1st mux to alu to pc jump
MUX312 : mux2  port map(regfiledata1,ALUoutmem,WBdata,forwardA,PCJMP);
--1st mux to alu to branch
MUX313 : mux2  port map(regfiledata1,ALUoutmem,WBdata,forwardA,BRANCH);
--1st mux to alu to outport
MUX314 : mux2  port map(regfiledata1,ALUoutmem,WBdata,forwardA,toOUTPORT);
-- ALU
ALU1: ALU GENERIC MAP(n) port map (out1mux2toALU,out2mux2toALU,outmux2x1,ALUout,flagsoutfromALU);
--mux 2x1 as aselector to ALU
muxselector: mux1 GENERIC MAP(4) port map(instr,"0000",ALUOP,outmux2x1);

--flags from alu to mux 2x1
MUX2x1fromalu: mux1 GENERIC MAP(4) port map(outofzeroextract,flagsoutfromALU,wrflags,inflagstoccr);
--zero extract
zeroextract1: ZEROEXTRACT port map( readdatafromMEM   ,outofzeroextract);
--ccr
CCR1 :  CCRregister  port map (inflagstoccr ,clk ,Rst,carryenab,BRtype,OUTflagsfromccr);
--ccr1: CCRregister 
zeroextend1: ZEROEXTEND port map (OUTflagsfromccr,flags);
--flags to mux4x1
MUX423 : Mux4x11  port map(OUTflagsfromccr(0),OUTflagsfromccr(1),OUTflagsfromccr(2),'1',BRtype,outflagtobr);

BRTAKEN <= ( outflagtobr AND BRenable);



end STRUCTEXECUTE;
