Library ieee;
use ieee.std_logic_1164.all;

Entity bufferr is
port( pcin: in std_logic_vector(31 downto 0);
     outflagsfrom0extendin: in std_logic_vector(31 downto 0);
    effectiveaddressin,ALUOUTin,DataSwapin: in std_logic_vector(31 downto 0);
    Rdest2in,Rdestin :in std_logic_vector(2 downto 0);
inportIN: in std_logic_vector(31 downto 0);
immIN: in std_logic_vector(31 downto 0);
 -------------------------------------------------------------------------------------------------
clk: in std_logic;
flush: in std_logic; 
--stall: in std_logic;
--changePC: out std_logic;
--------------------------------------------------------
--signal from MEM
--RegWrite ===>outmem(0)
--stackAddress ===> outmem(1) 
--MEMRead ===> outmem(2)
--MEMWrite ===> outmem(3)   
--stackEnable ===>outmem(4)
--------------------------------------------------------------
inputWB:in std_logic_vector(5 downto 0);
inputMEM:in std_logic_vector(7 downto 0);
outMEM:out std_logic_vector(7 downto 0);
outputWB:out std_logic_vector(5 downto 0);
--------------------------------------------------------------------------------------------
pcout: OUT std_logic_vector(31 downto 0);
outflagsfrom0extendout: OUT std_logic_vector(31 downto 0);
effectiveaddressout,ALUOUTout,DataSwapout: OUT std_logic_vector(31 downto 0);
inportOUT: out std_logic_vector(31 downto 0);
immOUT: out std_logic_vector(31 downto 0);
Rdest2out,Rdestout :out std_logic_vector(2 downto 0));
end bufferr;


ARCHITECTURE bufferarch of bufferr is
component LoayregisterFalling is
Generic(n:integer :=8);
port (
Rin:in std_logic_vector(n-1 downto 0);
clk,rst,en:in std_logic;
Rout:out std_logic_vector(n-1 downto 0));
end component;
--------------------------------------------------------------
Signal enable:std_logic :='1';
----------------------------------------------------------------
Begin


pc: LoayregisterFalling GENERIC MAP(32) port map(pcin,clk,flush,enable,pcout);
outflags: LoayregisterFalling GENERIC MAP(32) port map( outflagsfrom0extendin,clk,flush,enable, outflagsfrom0extendout);
Eadd: LoayregisterFalling GENERIC MAP(32) port map( effectiveaddressin,clk,flush,enable, effectiveaddressout);
ALUU: LoayregisterFalling GENERIC MAP(32) port map( ALUOUTin,clk,flush,enable, ALUOUTout);
RDESS2: LoayregisterFalling GENERIC MAP(3) port map( Rdest2in,clk,flush,enable, Rdest2out);
RDESS1: LoayregisterFalling GENERIC MAP(3) port map( Rdestin,clk,flush,enable, Rdestout);
SWAP: LoayregisterFalling GENERIC MAP(32) port map(DataSwapin,clk,flush,enable, DataSwapout);
mem: LoayregisterFalling GENERIC MAP(8) port map(inputMEM,clk,flush,enable, outMEM);
WB:LoayregisterFalling GENERIC MAP(6) port map(inputWB,clk,flush,enable, outputWB);
inport: LoayregisterFalling generic map(32) port map(inportIN,clk,flush,'1',inportOUT);
immVal: LoayregisterFalling generic map(32) port map(immIN,clk,flush,'1',immOUT);

end bufferarch;
