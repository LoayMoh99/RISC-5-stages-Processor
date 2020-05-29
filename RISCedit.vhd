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
clk,Reset,StallCU,StallHU,Call,Int1,Reset1 ,Int2,Reset2: IN std_logic; 
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
instout1: out std_logic_vector(3 downto 0); --3 downto 0
instout2: out std_logic_vector(2 downto 0); --10 downto 8
instout3: out std_logic_vector(2 downto 0); --13 downto 11
instout4: out std_logic_vector(2 downto 0); --7 down to 5
effectiveaddress: out std_logic_vector(31 downto 0));
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
fromwbsignal: out std_logic_vector(n-1 downto 0));

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
signal StallCU:std_logic;
signal StallHU:std_logic :='0';
signal ALUop:std_logic;
signal ALUsrc:std_logic;
signal BranchEN:std_logic;
signal StackEN:std_logic;
signal StackAddr:std_logic;
signal regWrite:std_logic;
signal regWrite2:std_logic;
signal memTOreg:std_logic;
signal OUTportEN:std_logic;
signal memRead:std_logic;
signal memWrite :std_logic;
signal CarryEN :std_logic_vector(1 downto 0);
signal BrType:std_logic_vector(1 downto 0);
signal WBdataSrc:std_logic_vector(1 downto 0); 
signal Reset1:std_logic;
signal Reset2:std_logic;
signal CallEn:std_logic;
signal INT1:std_logic;
signal INT2:std_logic;
signal F_Flush:std_logic;
signal FlushHaz:std_logic:='0';
signal WrFlags:std_logic;
signal ChangePC :std_logic;
signal MemSrcData:std_logic_vector(1 downto 0); 

--out mn FU   
signal Instructionbits:std_logic_vector(31 downto 0);    	
signal PC:std_logic_vector(31 downto 0);    

--out mn F/D buffer 
signal OutInstruction:std_logic_vector(31 downto 0);   
signal OutPC_FD:std_logic_vector(31 downto 0); 

--out from dec stage  
signal dataOut1:std_logic_vector(31 downto 0);
signal PC_outDU:std_logic_vector(31 downto 0);

--out from D/E buffer 
signal OutPC_DE:std_logic_vector(31 downto 0); 

--out from exec stage
signal branchEx:std_logic_vector(31 downto 0);
signal BrEnExecute:std_logic;
signal PC_outEU:std_logic_vector(31 downto 0);

--out from E/M buffer 
signal OutPC_EM:std_logic_vector(31 downto 0); 

--out from mem stage
signal ReadOutMem:std_logic_vector(31 downto 0);

--out from M/WB buffer 
signal wReg1,wReg2:std_logic_vector(2 downto 0);
signal wDataSwap:std_logic_vector(31 downto 0);

--out from wb stage
signal WBdata:std_logic_vector(31 downto 0);

begin
--fetch unit (d)
fu: FetchUnit generic map(n) port map ( clk=>clk,
Reset=>	Reset,
StallCU=>StallCU,
StallHU=>StallHU,
Call=>CallEn,
Int1=>INT1,
Reset1=>Reset1,
Int2=>INT2,
Reset2=> Reset2,
FirstThreeBitodOPcode=>	Instructionbits(2 downto 0),
Branch=> branchEx,
PoppedPC=>ReadOutMem,
PCsrc=>	BrEnExecute,
ChangePC=>ChangePC,
callRdst=>dataOut1,
Instructionbits=>Instructionbits,
PC=>PC); 
-----------------------------------------------------------------------------------
--fetch decode buffer (d)
bufferFD: FDbuffer  port map(Instruction=>Instructionbits,
PC=>PC,
Clk=>clk,
Stall=>StallCU or StallHU,
Flush => F_Flush or FlushHaz,
OutInstruction=>OutInstruction,
OutPC=>OutPC_FD);
--------------------------------------------------------------------------------------
--control unit (d)
CU:  ControlUnit port map(clk=>clk ,
INT=> INT,
Reset => Reset ,
op_code => OutInstruction(4 downto 0),
Rdst =>OutInstruction(7 downto 5),
Rsrc=> OutInstruction(10 downto 8) ,
--outputs:
ALUop=> ALUop,
ALUsrc=> ALUsrc ,
BranchEN=> BranchEN,
StackEN=>StackEN ,
StackAddr=> StackAddr ,
regWrite=> regWrite ,
regWrite2=>regWrite2 ,
memTOreg=>memTOreg ,
OUTportEN=> OUTportEN ,
memRead=> memRead ,
memWrite => memWrite ,
CarryEN=>CarryEN ,
BrType=> BrType ,
WBdataSrc => WBdataSrc,
Reset1=> Reset1,
Reset2=> Reset2,
CallEn=> CallEn,
INT1=> INT1 ,
INT2=> INT2 ,
StallCU=> StallCU ,
F_Flush=> F_Flush ,
WrFlags=> WrFlags,
ChangePC => ChangePC,
MemSrcData=> MemSrcData);
------------------------------------------------------------------------------------	
--decoding unit
DEC:  decodingpart generic map(n) port map(instr=>OutInstruction,
wb=>WBdata,
inport=>INport,
wbdatasrc=> WBdataSrc,
wreg1=> wReg1,
wreg2=> wReg2,
wdata2=>wDataSwap ,
rwsignal1 =>regWrite,
rwsignal2 =>regWrite2,
rstsignal=> Reset,
clk=> clk,
pcin=>OutPC_FD,
pcjump=>OutPC_DE,
branchtaken=>BrEnExecute,
pcout=>PC_outDU ,
dataout1=>    ,
dataout2=>    ,
instout1=>    ,
instout2=>    ,
instout3=>    ,
instout4=>    ,
effectiveaddress=>    );
  
---------------------------------------------------------------------------------------------
--dec to execute buffer
DECtoEXE:decExBuffer generic map(n) port map(pcin=>PC_outDU,
instrin =>    ,
srcreg1in=>    ,
srcreg2in=>    ,
destregin=>    ,
immvalin=>    ,
effaddrin=>    ,
datareg1in=>    ,
datareg2in=>    ,
exesignalin=>    ,
memsignalin=>    ,
wbsignalin=>    ,
clk=> clk,
flush=> Reset,
pcout=>OutPC_DE,
instrout=>    ,
srcreg1out=>    ,
srcreg2out=>    ,
destregout=>    ,
immvalout=>    ,
effaddrout=>    ,
datareg1out=>    ,
datareg2out=>    ,
exesignalout=>    ,
memsignalout=>    ,
wbsignalout=>    );
----------------------------------------------------------------------------------------------
--EXECUTE STAGE
EXE:EXECUTE generic map(n) port map(pcin=> OutPC_DE,
regfiledata1=>     ,
ALUoutmem=>     ,
WBdata=>     ,
regfiledata2=>     ,
immvaluein=>     ,
effaddin=>     ,
readdatafromMEM=>     ,
BRenable=>     ,
Rst=>Reset,
clk=> clk,
BRtype=>     ,
forwardA=>     ,
forwardB=>     ,
carryenab=>     ,
Rdestin=>     ,
Rdest2in=>     ,
instr=>     ,
cin1=>     ,
ALUOP=>     ,
wrflags=>     ,
flags=>     ,
pcout=> PC_outEU,
effaddout=>     ,
ALUout=>     ,
DATASWAP=>     ,
PCJMP=>     ,
BRANCH=>branchEx,
toOUTPORT=>     ,
--BRANCH IN FETCH STAGE
Rdestout=>     ,
Rdest2out=>     , 
BRTAKEN =>     );
-------------------------------------------------------------------------------------------------
---EXE TO MEM BUFFER
BUFFERextomem:bufferr  port map(pcin=>PC_outEU,
outflagsfrom0extendin=>     ,
effectiveaddressin=>     ,
 ALUOUTin=>     ,
DataSwapin=>     ,
 Rdest2in=>     ,
Rdestin =>     ,
clk=> clk,
flush=>Reset ,
stall=>     ,
changePC=>     ,
--signal from MEM
--RegWrite ===>outmem(0)
--stackAddress ===> outmem(1) 
--MEMRead ===> outmem(2)
--MEMWrite ===> outmem(3)   
--stackEnable ===>outmem(4)
inputWB=>     ,
inputMEM=>     ,
outMEM=>     ,
outputWB=>     ,
pcout=>OutPC_EM,
outflagsfrom0extendout=>     ,
effectiveaddressout=>     ,
ALUOUTout=>     ,
DataSwapout=>     ,
Rdest2out=>     ,
Rdestout =>     );
---------------------------------------------------------------------------------------------------
----memory stage

mem:memorystage   generic map(n) port map(flags=>        ,
pccall=>OutPC_EM ,
effectiveadr=>        ,
aluoutt=>        ,
dataswapin=>        ,
rdestin1=>        ,
rdestin2=>        ,
clk=> clk,
stackenable=>        ,
memsrcdata=>        ,
stackaddersignal=>        ,
memread=>        ,
memwrite=>        ,
readdataout=> ReadOutMem,
dataswapout=>        ,
aluoutput=>        ,
rdest1=>        ,
rdest2=>        );

------------------------------------------------------------------------------------------------------------
---buffer 
buff4 : buffer4  generic map(n) port map(readdata=>            ,
dataswaps=>            ,
aluoutp=>            ,
reg1=>            ,
reg2=>            ,
towbsignal=>            ,
clk=>clk,
flush=> Reset ,
readdataout=>            ,
dataswapsout=>            ,
 aluoutpout=>            ,
reg1out=>            ,
reg2out=>            ,
fromwbsignal=>            );


--------------------------------------------------------------------------------------------------------------
---mux2
Mcontrol: mux2  generic map(n) port map(in1=>     ,
in2=>     ,
sel=>     ,
outMx =>     );

wbMux: mux2  generic map(n) port map(in1=>     ,
in2=>     ,
sel=>     ,
outMx => WBdata );







----------------------------------------------------------------------------------------------------------
end RISC_processor_arch;