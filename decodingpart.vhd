LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity decodingpart is
Generic(n:integer :=32);
PORT( instr: in std_logic_vector(31 downto 0);
wb: in std_logic_vector(31 downto 0); --from WB stage
inport,immValIN:in std_logic_vector(31 downto 0); --from in device
wbdatasrc: in std_logic_vector(1 downto 0); --from control unit to mux
wreg1:in std_logic_vector(2 downto 0);
wreg2:in std_logic_vector(2 downto 0);
wdata2: in std_logic_vector(n-1 downto 0);
rwsignal1:in std_logic; rwsignal2:in std_logic; rstsignal: in std_logic; --from control unit
clk: in std_logic;
pcin: in std_logic_vector(n-1 downto 0); --for mux 2*1
pcjump: in std_logic_vector(n-1 downto 0); --for mux 2*1
branchtaken: in std_logic; --control signal for 2*1 mux
pcout: out std_logic_vector(n-1 downto 0); --for mux 2*1
dataout1:out std_logic_vector(n-1 downto 0);
dataout2:out std_logic_vector(n-1 downto 0); 
instout1: out std_logic_vector(4 downto 0); --3 downto 0
instout2: out std_logic_vector(2 downto 0); --10 downto 8
instout3: out std_logic_vector(2 downto 0); --13 downto 11
instout4: out std_logic_vector(2 downto 0); --7 down to 5
effectiveaddress,immValOUT: out std_logic_vector(31 downto 0));
end decodingpart;



architecture structr of decodingpart is
component regsfile is
Generic(n:integer :=32);
port (
ReadReg1:in std_logic_vector(2 downto 0); --Adress of Rsrc1
ReadReg2:in std_logic_vector(2 downto 0); --Adress of Rsrc2
WriteReg1:in std_logic_vector(2 downto 0); --Adress of Rdst1
WriteReg2:in std_logic_vector(2 downto 0); --Adress of Rdst2
WriteData1:in std_logic_vector(n-1 downto 0);
WriteData2:in std_logic_vector(n-1 downto 0); --For Swapping
RegWrite1:in std_logic; --Control Signal
RegWrite2:in std_logic; --For Swapping "Control Signal"
clk,rst:in std_logic; --For registers
DataOut1:out std_logic_vector(n-1 downto 0);
DataOut2:out std_logic_vector(n-1 downto 0)
);
end component;

component zeroextend1 IS
PORT( input:IN std_logic_vector(15 downto 0);
output:out std_logic_vector(31 downto 0));
end component;

component zeroextend2 IS
PORT( input:IN std_logic_vector(19 downto 0);
output:out std_logic_vector(31 downto 0));
end component;

component Mux4x1 is
generic(n:integer :=32);
port(
in1,in2,in3,in4: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic_vector(1 downto 0);
outMx : out std_logic_vector(n-1 downto 0));
end component;

component mux2 is
generic(n:integer :=32);
port(
in1,in2: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic;
outMx : out std_logic_vector(n-1 downto 0));
end component;


--Signals
Signal fromzeroextend1: std_logic_vector(31 downto 0); 
Signal frommux: std_logic_vector(31 downto 0);
Signal dataout1Temp,dataout2Temp: std_logic_vector(31 downto 0); --Signal to wbData2(swap) f stage tanya and out

Begin
--z1: zeroextend1 port map(instr(26 downto 11), fromzeroextend1); --out to mux4*1 and out
--z2: zeroextend2 port map(instr(30 downto 11), effectiveaddress); --out
immValOUT<=x"0000"&instr(26 downto 11);
effectiveaddress<=x"000"&instr(30 downto 11);
-------------------------

frommux<=wb when wbdatasrc="00" 
	else inport when wbdatasrc="01"
	else immValIN when wbdatasrc="10";
--------------------------
rf: regsfile generic map(n) port map (instr(10 downto 8),instr(13 downto 11),wreg1,wreg2,frommux,wdata2,rwsignal1,rwsignal2,clk,rstsignal,dataout1Temp,dataout2Temp);
---------------------------
m2: mux2 generic map(n) port map (pcin,pcjump,branchtaken,pcout); 
---------------------------
dataout1 <=dataout1Temp;
dataout2 <=dataout2Temp;
instout1 <= instr(4 downto 0);
instout2 <= instr(10 downto 8);
instout3 <= instr(13 downto 11);
instout4 <= instr(7 downto 5);
-----------------------
End structr;