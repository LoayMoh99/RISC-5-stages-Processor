LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

Entity RISC_processor_V is
generic(n:integer :=32);
port( 
--inputs:
	clk,INT,Reset : IN std_logic;
        INport : IN std_logic_vector(31 downto 0);
--outputs:
	OUTport : OUT std_logic_vector(31 downto 0));
end entity RISC_processor_V;

Architecture RISC_processorV_arch of RISC_processor_V is
--components:
component FetchUnit IS
GENERIC (n : integer := 32);
PORT    (
clk,StallCU,StallHU,Call,Int1,Int2,Reset1,Reset2: IN std_logic; 
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
component ControlUnit_V is
port( 
--inputs:
	clk,INT,Reset : IN std_logic;
        op_code : IN std_logic_vector(4 downto 0);
	Rdst : IN std_logic_vector(2 downto 0); --Instr[7-5]
	Rsrc : IN std_logic_vector(2 downto 0); --Instr[10-8]
counterIn: IN unsigned(2 downto 0):="000";

--outputs:
	ALUop,ALUsrc,BranchEN,StackEN,StackAddr,regWrite,regWrite2,memTOreg,OUTportEN,memRead,memWrite : OUT std_logic;
	CarryEN,BrType,WBdataSrc : OUT std_logic_vector(1 downto 0);
	Reset1,CallEn,INT1,INT2,StallCU,F_Flush,WrFlags,ChangePC : OUT std_logic;
	MemSrcData : OUT std_logic_vector(1 downto 0);
counterOut: Out unsigned(2 downto 0)
);
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
instrin: in std_logic_vector(3 downto 0);
srcreg1in: in std_logic_vector(2 downto 0);
srcreg2in: in std_logic_vector(2 downto 0);
destregin: in std_logic_vector(2 downto 0);
immvalin: in std_logic_vector(n-1 downto 0);
effaddrin: in std_logic_vector(n-1 downto 0);
datareg1in: in std_logic_vector(n-1 downto 0);
datareg2in: in std_logic_vector(n-1 downto 0);
exesignalin: in std_logic_vector(7 downto 0); --from control unit
memsignalin: in std_logic_vector(7 downto 0);  --from control unit
wbsignalin: in std_logic_vector(3 downto 0);   --from control unit
-----------------------------------------------
clk: in std_logic;
flush: in std_logic; 
-----------------------------------------------
pcout: out std_logic_vector(n-1 downto 0);
instrout: out std_logic_vector(3 downto 0);
srcreg1out: out std_logic_vector(2 downto 0);
srcreg2out: out std_logic_vector(2 downto 0);
destregout: out std_logic_vector(2 downto 0);
immvalout: out std_logic_vector(n-1 downto 0);
effaddrout: out std_logic_vector(n-1 downto 0);
datareg1out: out std_logic_vector(n-1 downto 0);
datareg2out: out std_logic_vector(n-1 downto 0);
exesignalout: out std_logic_vector(7 downto 0); 
memsignalout: out std_logic_vector(7 downto 0); 
wbsignalout: out std_logic_vector(3 downto 0)
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
ALUOP,wrflags: IN std_logic;
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
--changePC: out std_logic;
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
clk,rst: in std_logic;
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
reg1: in std_logic_vector(2 downto 0);
reg2: in std_logic_vector(2 downto 0);
towbsignal: in std_logic_vector(3 downto 0);
----------------------
clk,flush: in std_logic;
----------------------

readdataout:out std_logic_vector(n-1 downto 0);
dataswapsout: out std_logic_vector(n-1 downto 0);
aluoutpout: out std_logic_vector(n-1 downto 0);
reg1out: out std_logic_vector(2 downto 0);
reg2out: out std_logic_vector(2 downto 0);
fromwbsignal: out std_logic_vector(3 downto 0)
);

end component; 
------------------------------------------------------------------

component counter is 
port (clk	: in std_logic;
CoIN		: in unsigned(2 downto 0);
CoOut		: out unsigned(2 downto 0));
end component;

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
signal CallEn:std_logic;
signal INT1,INT2:std_logic;
signal F_Flush:std_logic;
signal FlushHaz:std_logic:='0';
signal WrFlags:std_logic;
signal ChangePC :std_logic;
signal MemSrcData:std_logic_vector(1 downto 0); 
signal stallFDbuffer:std_logic;
signal flushFDbuffer:std_logic;
signal ex_mem_wbSignals,ex_mem_wbSignalsOutMux :std_logic_vector(31 downto 0);
signal D_Flush :std_logic:='0';
signal counterIn: unsigned(2 downto 0):="000";
signal counterOut: unsigned(2 downto 0);

--out mn FU   
signal Instructionbits:std_logic_vector(31 downto 0);    	
signal PC:std_logic_vector(31 downto 0);    

--out mn F/D buffer 
signal OutInstruction:std_logic_vector(31 downto 0);   
signal OutPC_FD:std_logic_vector(31 downto 0); 
------------------------------------------------------------------mn awel hena nezwd
--out from dec stage  
signal dataOut1:std_logic_vector(31 downto 0);
signal PC_outDU:std_logic_vector(31 downto 0);
signal dataOut2:std_logic_vector(31 downto 0);
signal immValue,effectiveaddressDec: std_logic_vector(31 downto 0);
signal instout1:std_logic_vector(3 downto 0);
signal instout2:std_logic_vector(2 downto 0);
signal instout3:std_logic_vector(2 downto 0);
signal instout4:std_logic_vector(2 downto 0);

--out from D/E buffer 
signal OutPC_DE:std_logic_vector(31 downto 0); 
signal instrOut: std_logic_vector(3 downto 0);
signal srcreg1Out: std_logic_vector(2 downto 0);
signal srcreg2Out: std_logic_vector(2 downto 0);
signal destregOut: std_logic_vector(2 downto 0);
signal immvalueOut: std_logic_vector(31 downto 0); 
signal effaddrOut: std_logic_vector(31 downto 0); 
signal datareg1Out: std_logic_vector(31 downto 0); 
signal datareg2Out:std_logic_vector(31 downto 0); 
signal exesignalOut: std_logic_vector(7 downto 0); --mariam
signal memsignalOut:std_logic_vector(7 downto 0);  --mariam 
signal wbsignalOut :std_logic_vector(3 downto 0);  --mariam


--out from exec stage
signal branchEx:std_logic_vector(31 downto 0);
signal BrEnExecute:std_logic;
signal PC_outEU:std_logic_vector(31 downto 0);
signal Flags : std_logic_vector(31 downto 0);
signal AluOut:std_logic_vector(31 downto 0);
signal EffaddOut:std_logic_vector(31 downto 0);
signal DataSwap:std_logic_vector(31 downto 0);
signal PcJump:std_logic_vector(31 downto 0);
signal ToOutport:std_logic_vector(31 downto 0);
signal RdestOut:std_logic_vector (2 downto 0);
signal Rdest2Out:std_logic_vector (2 downto 0);


--out from E/M buffer 
signal OutMem:std_logic_vector(7 downto 0);
signal OutputWB: std_logic_vector(3 downto 0);
signal OutPC_EM:std_logic_vector(31 downto 0); 
signal Outflagsfrom0extendout :std_logic_vector(31 downto 0);
signal EffectiveaddressOut:std_logic_vector(31 downto 0);
signal AluOUTout:std_logic_vector(31 downto 0);
signal DataSWAPOUT:std_logic_vector(31 downto 0);
signal Rdest2OUTm:std_logic_vector(2 downto 0);
signal RdestOUTm:std_logic_vector(2 downto 0);

--out from mem stage
signal ReadOutMem:std_logic_vector(31 downto 0);
signal dataswapOutm:std_logic_vector(31 downto 0);
signal aluOutput:std_logic_vector(31 downto 0);
signal  R1 :  std_logic_vector(2 downto 0);
signal  R2 :std_logic_vector(2 downto 0);

--out from M/WB buffer 
signal wReg1,wReg2:std_logic_vector(2 downto 0);
signal wDataSwap:std_logic_vector(31 downto 0);
signal ReadOutMemData: std_logic_vector(31 downto 0);
signal AlUouttowb :std_logic_vector(31 downto 0);

--out from wb stage
signal WBDATAA:std_logic_vector(31 downto 0);
signal WBsignalss:std_logic_vector(3 downto 0);

begin
--fetch unit (d)
fu: FetchUnit generic map(n) port map ( clk=>clk,
StallCU=>StallCU,
StallHU=>StallHU,
Call=>CallEn,
Int1=>INT1,
Reset1=>Reset,
Int2=>INT2,
Reset2=> Reset1,
Branch=> branchEx,
PoppedPC=>ReadOutMem,
PCsrc=>	BrEnExecute,
ChangePC=>ChangePC,
callRdst=>dataOut1,
Instructionbits=>Instructionbits,
PC=>PC); 
-----------------------------------------------------------------------------------
--fetch decode buffer (d)
stallFDbuffer<=StallCU or StallHU;
flushFDbuffer<=F_Flush or FlushHaz;
bufferFD: FDbuffer  port map(Instruction=>Instructionbits,
PC=>PC,
Clk=>clk,
Stall=>stallFDbuffer,
Flush => flushFDbuffer,
OutInstruction=>OutInstruction,
OutPC=>OutPC_FD);
--------------------------------------------------------------------------------------
--counter
countt: counter port map(clk,counterIn,counterOut);
--------------------------------------------------------------------------------------
--control unit (d)
CU:  ControlUnit_V port map(clk=>clk ,
INT=> INT,
Reset => Reset ,
op_code => OutInstruction(4 downto 0),
Rdst =>OutInstruction(7 downto 5),
Rsrc=> OutInstruction(10 downto 8) ,
counterIn=>counterIn,
--outputs:
counterOut=>counterOut,
ALUop=> ALUop,
ALUsrc=> ALUsrc ,
BranchEN=> BranchEN,
StackEN=>StackEN ,
StackAddr=> StackAddr ,
regWrite=> WBsignalss(0) ,
regWrite2=>WBsignalss(1) ,
memTOreg=>memTOreg ,
OUTportEN=> OUTportEN ,
memRead=> memRead ,
memWrite => memWrite ,
CarryEN=>CarryEN ,
BrType=> BrType ,
WBdataSrc => WBdataSrc,
Reset1=> Reset1,
CallEn=> CallEn,
INT1=> INT1 ,
INT2=>INT2 ,
StallCU=> StallCU ,
F_Flush=> F_Flush ,
WrFlags=> WrFlags,
ChangePC => ChangePC,
MemSrcData=> MemSrcData);

ex_mem_wbSignals(7 downto 0)<=ALUsrc&ALUop&WrFlags&CarryEN&BrType&BranchEN;
ex_mem_wbSignals(15 downto 8)<="00"&memWrite&memRead&MemSrcData&StackAddr&StackEN;
ex_mem_wbSignals(19 downto 16)<='0'&memTOreg&regWrite2&regWrite;
ex_mem_wbSignals(31 downto 20)<= (others=>'0');


------------------Mux of signals ------------------------------------
Mcontrol: mux2  generic map(n) port map(in1=> ex_mem_wbSignals ,
in2=>x"00000000",
sel=>  D_Flush ,											 --D_Flush from haz unit ..
outMx =>  ex_mem_wbSignalsOutMux   );
------------------------------------------------------------------------------------	
--decoding unit
DEC_stage:  decodingpart generic map(n) port map(instr=>OutInstruction,
wb=>WBDATAA,
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
dataout1=> dataOut1   ,
dataout2=> dataOut2   ,
instout1=> instout1   ,
instout2=> instout2   ,
instout3=> instout3   ,
instout4=> instout4   ,
effectiveaddress=> effectiveaddressDec);
  
---------------------------------------------------------------------------------------------
--dec to execute buffer
DECtoEXE:decExBuffer generic map(n) port map(pcin=>PC_outDU,
instrin => instout1    ,
srcreg1in=> instout2   ,
srcreg2in=> instout3   ,
destregin=> instout4   ,
immvalin=> immValue,
effaddrin=> effectiveaddressDec   ,
datareg1in=> dataOut1 ,
datareg2in=> dataOut2 ,
exesignalin=> ex_mem_wbSignalsOutMux(7 downto 0), --mariam hena signals gayeen mn mux2*1 "control unit"
memsignalin=>  ex_mem_wbSignalsOutMux(15 downto 8) ,  --mariam "control unit"
wbsignalin=>  ex_mem_wbSignalsOutMux(19 downto 16) ,   --mariam "control unit"
clk=> clk,
flush=> Reset,
pcout=>OutPC_DE,
instrout=> instrOut   ,
srcreg1out=> srcreg1Out   ,
srcreg2out=> srcreg2Out   ,
destregout=> destregOut   ,
immvalout=> immvalueOut   ,
effaddrout=> effaddrOut  ,
datareg1out=>  datareg1Out  ,
datareg2out=>  datareg2Out  ,
exesignalout=> exesignalOut   , --this is 8 bits divided into many signals "control unit"
memsignalout=>  memsignalOut  , --this is 8 bits divided into many signals "control unit"
wbsignalout=>  wbsignalOut  )--this is 4 bits divided into many signals  "control unit"
;
----------------------------------------------------------------------------------------------
--EXECUTE STAGE
EXE_stage: EXECUTE generic map(n) port map(pcin=> OutPC_DE,
regfiledata1=>  datareg1Out   ,
ALUoutmem=>  aluOutput    , 
WBdata=>  WBDATAA   ,  
regfiledata2=>  datareg2Out   ,
immvaluein=>  immvalueOut   ,
effaddin=>  effaddrOut   ,
readdatafromMEM=>  ReadOutMem   , 
BRenable=> exesignalOut(0) , --one bit from exesignalout "control unit"
Rst=>Reset,
clk=> clk,
BRtype=> exesignalOut(2 downto 1) ,   --one bit from exesignalout "control unit"
forwardA=> "00",  											 --from forwardunit  
forwardB=> "00" ,  									 	   	 --from forwardunit  
carryenab=> exesignalOut(4 downto 3)   ,  --one bit from exesignalout "control unit"
Rdestin=>destregOut , 
Rdest2in=>srcreg1Out ,  
instr=> instrOut,
ALUOP=>  exesignalOut(6)  ,  --one bit from exesignalout "control unit"
wrflags=>  exesignalOut(5) ,   --one bit from exesignalout "control unit"				ALUsrc = exesignalOut(7) in ForwU
--outputs
flags=>   Flags  ,
pcout=> PC_outEU,
effaddout=> EffaddOut    ,
ALUout=> AluOut    ,
DATASWAP=>  DataSwap   ,
PCJMP=> PcJump    ,
BRANCH=>branchEx,
toOUTPORT=>  ToOutport   ,
--BRANCH IN FETCH STAGE
Rdestout=>  RdestOut   ,
Rdest2out=>   Rdest2Out  , 
BRTAKEN => BrEnExecute   );

-------------------------------------------------------------------------------------------------
---EXE TO MEM BUFFER
BUFFERextomem:bufferr  port map(pcin=>PC_outEU,
outflagsfrom0extendin=>  Flags     ,
effectiveaddressin=> EffaddOut     ,
ALUOUTin=>  AluOut    ,
DataSwapin=>  DataSwap   , 
Rdest2in=>  Rdest2Out     ,  --asdak te swap??
Rdestin =>  RdestOut    ,
clk=> clk,
flush=>Reset,
--changePC=> ChangePC    ,
inputWB=> wbsignalOut   , --dol input mn "control unit" ghaleban
inputMEM=>  memsignalOut   , --dol input mn "control unit" ghaleban
outMEM=>  OutMem   ,
outputWB=>  OutputWB  ,
pcout=>OutPC_EM,
outflagsfrom0extendout=> Outflagsfrom0extendout     ,
effectiveaddressout=>   EffectiveaddressOut   ,
ALUOUTout=>  AluOUTout   ,
DataSwapout=> DataSWAPOUT    ,
Rdest2out=> Rdest2OUTm    , 
Rdestout =>  RdestOUTm   );
---------------------------------------------------------------------------------------------------
----memory stage
mem_stagee:memorystage   generic map(n) port map(flags=>Outflagsfrom0extendout ,
pccall=>OutPC_EM ,
effectiveadr=> EffectiveaddressOut       ,
aluoutt=>  AluOUTout      ,
dataswapin=>  DataSWAPOUT       ,
rdestin1=>   RdestOUTm     ,
rdestin2=> Rdest2OUTm       ,
clk=> clk,
rst=>Reset,
stackenable=> OutMem(0) , --on bit gai mn outMem mn stage el ablha "control signal"
memsrcdata=>  OutMem(3 downto 2) ,  --on bit gai mn outMem mn stage el ablha "control signal"
stackaddersignal=>  OutMem(1)  ,  --on bit gai mn outMem mn stage el ablha "control signal"
memread=> OutMem(4) ,   --on bit gai mn outMem mn stage el ablha "control signal"
memwrite=>OutMem(5) ,   --on bit gai mn outMem mn stage el ablha "control signal"
--output
readdataout=> ReadOutMem,
dataswapout=> dataswapOutm ,
aluoutput=> aluOutput  ,
rdest1=>   R1     ,
rdest2=>    R2    );

------------------------------------------------------------------------------------------------------------
---buffer 
buff4 : buffer4  generic map(n) port map(readdata=> ReadOutMem   ,
dataswaps=>  dataswapOutm           ,
aluoutp=>    aluOutput        ,
reg1=>    R1        ,
reg2=>    R2        ,
towbsignal=>  OutputWB , --"control signals"
clk=>clk,
flush=> Reset ,
readdataout=>  ReadOutMemData          , ---from buffer to mux
dataswapsout=> wDataSwap           ,
 aluoutpout=>  AlUouttowb          ,   ---from buffer to mux
reg1out=>  wReg1          ,
reg2out=>   wReg2         ,
fromwbsignal=>   WBsignalss ); --"control signals" 

--------------------------------------------------------------------------------------------------------------
---WB stage
wb_stagee: mux2  generic map(n) port map(in1=>  ReadOutMemData   ,
in2=>  AlUouttowb     ,
sel=>WBsignalss(2) ,  --control signal
outMx =>  WBDATAA );

----------------------------------------------------------------------------------------------------------
end RISC_processorV_arch;