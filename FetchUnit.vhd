LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY FetchUnit IS
GENERIC (n : integer := 32);
PORT    (
clk,StallCU,StallHU,Call,Int1,Reset1 ,Int2,Reset2: IN std_logic; 
Branch,PoppedPC: IN std_logic_vector(31 downto 0); --decide pc
PCsrc ,ChangePC: IN std_logic; 
callRdst: IN std_logic_vector(31 downto 0); --deceide pc after int reset
Instructionbits: OUT std_logic_vector(31 downto 0);
PC: OUT std_logic_vector(31 downto 0));
END ENTITY FetchUnit;



ARCHITECTURE FetchingUnit OF FetchUnit IS

--memory

component Mux4x1 IS
GENERIC (n : integer := 32);
PORT(
in1,in2,in3,in4: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic_vector(1 downto 0);
outMx : out std_logic_vector(n-1 downto 0));
END component;

component my_Nadder IS
GENERIC (n : integer := 32);
PORT(
        a,b : IN  std_logic_vector(n-1 downto 0);
	cin : IN std_logic; --dc
	cout : OUT std_logic;
	s: OUT std_logic_vector(n-1 downto 0)
);
END component;



component PC_reg is
Generic(n:integer :=32);
port (
dataIn:in std_logic_vector(n-1 downto 0);
clk,rst,en:in std_logic;
dataOut:out std_logic_vector(n-1 downto 0):=x"00000000");
end component;

component InstMemory IS
PORT(
Clk : IN std_logic;
Address:in std_logic_vector(11 downto 0);
Instruction:out std_logic_vector(31 downto 0)
);
END component;

Signal cin: std_logic :='0';
Signal ToAddOneorTwo: std_logic;
Signal IntReset: std_logic;
Signal Stall: std_logic;
Signal toAdd: std_logic_vector(n-1 downto 0);
Signal carryout: std_logic;--dc
Signal outAdder: std_logic_vector(n-1 downto 0);

Signal outPCfromMux: std_logic_vector(n-1 downto 0); --hyruh buffer
--Signal instAdressIntReset: std_logic_vector(n-1 downto 0);
Signal FinalPC: std_logic_vector(n-1 downto 0);
Signal outPC: std_logic_vector(n-1 downto 0):=x"00000000"; --khareg mn pc
Signal ReadAdddress: std_logic_vector(n-1 downto 0);

signal selcmux1 : std_logic_vector (1 downto 0);
signal selcmuxChoosePC : std_logic_vector (1 downto 0);
signal selcmuxforIntReset : std_logic_vector (1 downto 0);
signal selclastmux : std_logic_vector (1 downto 0);
signal notFirstThirdBitodOPcode :std_logic;
signal FirstThreeBitodOPcode: std_logic_vector(2 downto 0);
Signal InstructionbitsTemp: std_logic_vector(n-1 downto 0):=x"00000000";

begin
FirstThreeBitodOPcode<= InstructionbitsTemp(4 downto 2);
notFirstThirdBitodOPcode <= NOT FirstThreeBitodOPcode(0);
ToAddOneorTwo <= FirstThreeBitodOPcode(2) AND FirstThreeBitodOPcode(1) AND notFirstThirdBitodOPcode;
IntReset <= Int2 OR Reset2;
Stall <= StallCU OR StallHU;
--selcmux1 <= Stall & ToAddOneorTwo;
--selcmuxChoosePC <= ChangePC & PCsrc;
selcmuxforIntReset <= Call & IntReset;
selclastmux <= Int1 & Reset1;

--mux1: Mux4x1 GENERIC MAP (n)  PORT MAP (x"00000001",x"00000002",x"00000000",x"00000000",selcmux1,toAdd);
toAdd<=x"00000001" when Stall='0' and ToAddOneorTwo='0'
	else x"00000002" when Stall='0' and ToAddOneorTwo='1'
	else x"00000000";
Adder1: my_Nadder GENERIC MAP (n) PORT MAP(toAdd,outPC,cin,carryout,outAdder);
--muxChoosePC: Mux4x1 GENERIC MAP (n)  PORT MAP(outAdder,Branch,PoppedPC,PoppedPC,selcmuxChoosePC,outPCfrommux);
outPCfrommux<=outAdder when ChangePC='0' and PCsrc='0' 
		else Branch when ChangePC='0' and PCsrc='1'
		else PoppedPC when ChangePC='1';
--muxforIntReset: Mux4x1 GENERIC MAP (n)  PORT MAP (outPCfrommux,instAdressIntReset,callRdst,callRdst,selcmuxforIntReset ,FinalPC);
FinalPC<=outPCfrommux when Call='0' and IntReset='0'
	else InstructionbitsTemp when Call='0' and IntReset='1'
	else callRdst when Call='1';

PC1: PC_reg GENERIC MAP (n) PORT MAP(FinalPC,Clk,Reset1,'1',outPC);
lastmux:Mux4x1 GENERIC MAP (n)  PORT MAP (outPC,x"00000000",x"00000002",x"00000000",selclastmux,ReadAdddress);--???akteb ezay eno hy2ara mkan 0,2 fe reset w int?

memory:InstMemory PORT MAP(Clk,ReadAdddress(11 downto 0),InstructionbitsTemp);
Instructionbits<=InstructionbitsTemp;
--instAdressIntReset<=InstructionbitsTemp;
PC <= outPCfromMux;

END FetchingUnit;