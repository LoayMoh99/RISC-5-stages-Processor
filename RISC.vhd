LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

Entity RISC_processor is
port( 
--inputs:
	clk,INT,Reset : IN std_logic;
        INport : IN std_logic_vector(31 downto 0);
--outputs:
	OUTport : OUT std_logic_vector(31 downto 0));
end entity RISC_processor;

Architecture RISC_processor_arch of RISC_processor is
--components:
component FetchUnit IS
GENERIC (n : integer := 32);
PORT    (
clk,Flush,StallCU,StallHU,Call,Int1,Reset1 ,Int2,Reset2: IN std_logic; 
FirstThreeBitodOPcode: IN std_logic_vector(2 downto 0);
Branch,PoppedPC: IN std_logic_vector(31 downto 0); --decide pc
PCsrc ,ChangePC: IN std_logic; 
callRdst: IN std_logic_vector(31 downto 0); --deceide pc after int reset
Instructionbits: OUT std_logic_vector(31 downto 0);
PC: OUT std_logic_vector(31 downto 0));
END component;
------------------------------------------------------------------
component FDbuffer IS
PORT    (
Instruction: IN std_logic_vector(31 downto 0);
PC: IN std_logic_vector(31 downto 0);
Clk,Stall,Flush :in std_logic;
OutInstruction: OUT std_logic_vector(31 downto 0);
OutPC: OUT std_logic_vector(31 downto 0));

END component;
------------------------------------------------------------------
component ControlUnit is
port( 
--inputs:
	clk,INT,Reset : IN std_logic;
        op_code : IN std_logic_vector(4 downto 0);
	Rdst : IN std_logic_vector(2 downto 0); --Instr[7-5]
	Rsrc : IN std_logic_vector(2 downto 0); --Instr[10-8]
--outputs:
	ALUop,ALUsrc,BranchEN,StackEN,StackAddr,regWrite,regWrite2,memTOreg,OUTportEN,memRead,memWrite : OUT std_logic;
	CarryEN,BrType,WBdataSrc : OUT std_logic_vector(1 downto 0);
	Reset1,Reset2,CallEn,INT1,INT2,StallCU,F_Flush,WrFlags,ChangePC : OUT std_logic;
	MemSrcData : OUT std_logic_vector(1 downto 0));
end component;
------------------------------------------------------------------
component decodingpart is
Generic(n:integer :=32);
PORT( instr: in std_logic_vector(31 downto 0);
wb: in std_logic_vector(31 downto 0); --from WB stage
inport:in std_logic_vector(31 downto 0); --from in device
wbdatasrc: in std_logic_vector(1 downto 0); --from control unit to mux
wreg1:in std_logic_vector(2 downto 0); wreg2:in std_logic_vector(2 downto 0);
wdata2: in std_logic_vector(n-1 downto 0);
rwsignal1:in std_logic; rwsignal2:in std_logic; rstsignal: in std_logic; --from control unit
clk: in std_logic;
pcin: in std_logic_vector(n-1 downto 0); --for mux 2*1
pcjump: in std_logic_vector(n-1 downto 0); --for mux 2*1
branchtaken: in std_logic; --control signal for 2*1 mux
pcout: out std_logic_vector(n-1 downto 0); --for mux 2*1
dataout1:out std_logic_vector(n-1 downto 0);
dataout2:out std_logic_vector(n-1 downto 0); 
instout1: out std_logic_vector(3 downto 0); --3 downto 0
instout2: out std_logic_vector(2 downto 0); --10 downto 8
instout3: out std_logic_vector(2 downto 0); --13 downto 11
instout4: out std_logic_vector(2 downto 0); --7 down to 5
effectiveaddress: out std_logic_vector(31 downto 0);
rdst_call: out std_logic_vector(31 downto 0));
end component ;
------------------------------------------------------------------
component decExBuffer is
Generic(n:integer :=32);
port( pcin: in std_logic_vector(n-1 downto 0);
instrin: in std_logic_vector(n-1 downto 0);
srcreg1in: in std_logic_vector(n-1 downto 0);
srcreg2in: in std_logic_vector(n-1 downto 0);
destregin: in std_logic_vector(n-1 downto 0);
immvalin: in std_logic_vector(n-1 downto 0);
effaddrin: in std_logic_vector(n-1 downto 0);
datareg1in: in std_logic_vector(n-1 downto 0);
datareg2in: in std_logic_vector(n-1 downto 0);
exesignalin: in std_logic_vector(n-1 downto 0); --from control unit
memsignalin: in std_logic_vector(n-1 downto 0);  --from control unit
wbsignalin: in std_logic_vector(n-1 downto 0);   --from control unit
-----------------------------------------------
clk: in std_logic;
flush: in std_logic; 
-----------------------------------------------
pcout: out std_logic_vector(n-1 downto 0);
instrout: out std_logic_vector(n-1 downto 0);
srcreg1out: out std_logic_vector(n-1 downto 0);
srcreg2out: out std_logic_vector(n-1 downto 0);
destregout: out std_logic_vector(n-1 downto 0);
immvalout: out std_logic_vector(n-1 downto 0);
effaddrout: out std_logic_vector(n-1 downto 0);
datareg1out: out std_logic_vector(n-1 downto 0);
datareg2out: out std_logic_vector(n-1 downto 0);
exesignalout: out std_logic_vector(n-1 downto 0); 
memsignalout: out std_logic_vector(n-1 downto 0); 
wbsignalout: out std_logic_vector(n-1 downto 0)
);
end component ;
------------------------------------------------------------------
component EXECUTE is
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
end component ;
------------------------------------------------------------------
component bufferr is
port( pcin: in std_logic_vector(31 downto 0);
     outflagsfrom0extendin: in std_logic_vector(31 downto 0);
    effectiveaddressin,ALUOUTin,DataSwapin: in std_logic_vector(31 downto 0);
    Rdest2in,Rdestin :in std_logic_vector(2 downto 0);
 ---------------------------------------------
clk: in std_logic;
flush: in std_logic; 
stall: in std_logic;
changePC: out std_logic;
-----------------------------
--signal from MEM
--RegWrite ===>outmem(0)
--stackAddress ===> outmem(1) 
--MEMRead ===> outmem(2)
--MEMWrite ===> outmem(3)   
--stackEnable ===>outmem(4)
-----------------------------------------
inputWB:in std_logic_vector(3 downto 0);
inputMEM:in std_logic_vector(7 downto 0);
outMEM:out std_logic_vector(7 downto 0);
outputWB:out std_logic_vector(3 downto 0);
--------------------------------------------
pcout: OUT std_logic_vector(31 downto 0);
outflagsfrom0extendout: OUT std_logic_vector(31 downto 0);
effectiveaddressout,ALUOUTout,DataSwapout: OUT std_logic_vector(31 downto 0);
Rdest2out,Rdestout :out std_logic_vector(2 downto 0));
end component; 
------------------------------------------------------------------
component memorystage is
generic(n:integer :=32);
port( 
flags: in std_logic_vector(n-1 downto 0);
pccall: in std_logic_vector(n-1 downto 0);
effectiveadr:in std_logic_vector(n-1 downto 0);
aluoutt: in std_logic_vector(n-1 downto 0);
dataswapin: in std_logic_vector(n-1 downto 0);
rdestin1: in std_logic_vector(2 downto 0);
rdestin2: in std_logic_vector(2 downto 0);
clk: in std_logic;
stackenable: in std_logic; --control signal
memsrcdata: in std_logic_vector(1 downto 0);  --control signal
stackaddersignal: in std_logic; --control signal
memread: in std_logic; --control signal
memwrite: in std_logic;  --control signal
readdataout: out std_logic_vector(n-1 downto 0);
dataswapout:out std_logic_vector(n-1 downto 0);
aluoutput: out std_logic_vector(n-1 downto 0);
rdest1:out std_logic_vector(2 downto 0);
rdest2:out std_logic_vector(2 downto 0)
);

end component;
------------------------------------------------------------------
component buffer4 is 
Generic(n:integer :=32);
port (
readdata: in std_logic_vector(n-1 downto 0);
dataswaps: in std_logic_vector(n-1 downto 0);
 aluoutp: in std_logic_vector(n-1 downto 0);
reg1: in std_logic_vector(n-1 downto 0);
reg2: in std_logic_vector(n-1 downto 0);
towbsignal: in std_logic_vector(n-1 downto 0);
----------------------
clk,flush: in std_logic;
----------------------
readdataout:out std_logic_vector(n-1 downto 0);
dataswapsout: out std_logic_vector(n-1 downto 0);
 aluoutpout: out std_logic_vector(n-1 downto 0);
reg1out: out std_logic_vector(n-1 downto 0);
reg2out: out std_logic_vector(n-1 downto 0);
fromwbsignal: out std_logic_vector(n-1 downto 0)
);

end component; 
------------------------------------------------------------------
component mux2 is
generic(n:integer :=32);
port(
in1,in2: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic;
outMx : out std_logic_vector(n-1 downto 0));
end component;
------------------------------------------------------------------
--signals: 


begin
	
end RISC_processor_arch;