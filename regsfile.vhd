Library ieee;
use ieee.std_logic_1164.all;

Entity regsfile is
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
end regsfile;

architecture struct of regsfile is
component mux4 is
Generic(n:integer :=32);
 port (q1:IN std_logic_vector (n-1 downto 0); q2: IN std_logic_vector (n-1 downto 0);
                q3: IN std_logic_vector (n-1 downto 0); q4: IN std_logic_vector (n-1 downto 0);
                 q5:IN std_logic_vector (n-1 downto 0); q6: IN std_logic_vector (n-1 downto 0);
                q7: IN std_logic_vector (n-1 downto 0); q8: IN std_logic_vector (n-1 downto 0);
                selmux: IN std_logic_vector (2 downto 0); m: out std_logic_vector (n-1 downto 0));

end component;



component decoder IS
PORT( enable: IN std_logic; in1:IN std_logic_vector(2 downto 0);
out1:out std_logic_vector(7 downto 0));

end component;

component Loayregister is
Generic(n:integer :=32);
port (
Rin:in std_logic_vector(n-1 downto 0);
clk,rst,en:in std_logic;
Rout:out std_logic_vector(n-1 downto 0));

end component;

component LoayregisterNoCLK is
Generic(n:integer :=32);
port (
Rin:in std_logic_vector(n-1 downto 0);
clk,rst,en:in std_logic;
Rout:out std_logic_vector(n-1 downto 0));

end component;
component Mux4x1 is
generic(n:integer :=32);
port(
in1,in2,in3,in4: IN std_logic_vector(n-1 downto 0);
sel: IN std_logic_vector(1 downto 0);
outMx : out std_logic_vector(n-1 downto 0));
end component;
--Signals
Signal temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8: std_logic_vector(n-1 downto 0) :=x"00000000";--from mux4*1
Signal temp11,temp21,temp31,temp41,temp51,temp61,temp71,temp81: std_logic_vector(n-1 downto 0);
Signal temp12,temp22,temp32,temp42,temp52,temp62,temp72,temp82: std_logic_vector(n-1 downto 0);
Signal rr1,rr2,rr3,rr4,rr5,rr6,rr7,rr8: std_logic_vector(n-1 downto 0);
Signal wEn1,wEn2: std_logic_vector(7 downto 0); --From decoder to write registers
--Signal sel: std_logic_vector(1 downto 0);
Begin
--Write on the Rising edge --
--for RegisterWriteData1
d1: decoder port map(RegWrite1,WriteReg1,wEn1); 
wr1: Loayregister generic map(n) port map(WriteData1,clk,rst,wEn1(0),temp11);
wr2: Loayregister generic map(n) port map(WriteData1,clk,rst,wEn1(1),temp21);
wr3: Loayregister generic map(n) port map(WriteData1,clk,rst,wEn1(2),temp31);
wr4: Loayregister generic map(n) port map(WriteData1,clk,rst,wEn1(3),temp41);
wr5: Loayregister generic map(n) port map(WriteData1,clk,rst,wEn1(4),temp51);
wr6: Loayregister generic map(n) port map(WriteData1,clk,rst,wEn1(5),temp61);
wr7: Loayregister generic map(n) port map(WriteData1,clk,rst,wEn1(6),temp71);
wr8: Loayregister generic map(n) port map(WriteData1,clk,rst,wEn1(7),temp81);
--for RegisterWriteData2
d2: decoder port map(RegWrite2,WriteReg2,wEn2); 
wwr1: Loayregister generic map(n) port map(WriteData2,clk,rst,wEn2(0),temp12);
wwr2: Loayregister generic map(n) port map(WriteData2,clk,rst,wEn2(1),temp22);
wwr3: Loayregister generic map(n) port map(WriteData2,clk,rst,wEn2(2),temp32);
wwr4: Loayregister generic map(n) port map(WriteData2,clk,rst,wEn2(3),temp42);
wwr5: Loayregister generic map(n) port map(WriteData2,clk,rst,wEn2(4),temp52);
wwr6: Loayregister generic map(n) port map(WriteData2,clk,rst,wEn2(5),temp62);
wwr7: Loayregister generic map(n) port map(WriteData2,clk,rst,wEn2(6),temp72);
wwr8: Loayregister generic map(n) port map(WriteData2,clk,rst,wEn2(7),temp82);
-----------------------------------------------------------------------
--sel<= (wEn2(0)or wEn2(1) or wEn2(2)or wEn2(3) or wEn2(4)or wEn2(5) or wEn2(6)or wEn2(7))&(wEn1(0)or wEn1(1) or wEn1(2)or wEn1(3) or wEn1(4)or wEn1(5) or wEn1(6)or wEn1(7));

temp1<= temp11 when wEn1(0)='1' else
	temp12 when wEn2(0)='1' else
	temp1;

temp2<= temp21 when wEn1(1)='1' else
	temp22 when wEn2(1)='1' else
	temp2;

temp3<= temp31 when wEn1(2)='1' else
	temp32 when wEn2(2)='1' else
	temp3;

temp4<= temp41 when wEn1(3)='1' else
	temp42 when wEn2(3)='1' else
	temp4;

temp5<= temp51 when wEn1(4)='1' else
	temp52 when wEn2(4)='1' else
	temp5;

temp6<= temp61 when wEn1(5)='1' else
	temp62 when wEn2(5)='1' else
	temp6;

temp7<= temp71 when wEn1(6)='1' else
	temp72 when wEn2(6)='1' else
	temp7;

temp8<= temp81 when wEn1(7)='1' else
	temp82 when wEn2(7)='1' else
	temp8;
-----------------------------------------------------------------------

--RegisterRead Important Note "they will read according to which write enable is activated","Enable here always 1 because they will read all and multiplixer will choose which one to out"
rrr1: LoayregisterNoCLK generic map(n) port map(temp1,clk,rst,'1',rr1);
rrr2: LoayregisterNoCLK generic map(n) port map(temp2,clk,rst,'1',rr2);
rrr3: LoayregisterNoCLK generic map(n) port map(temp3,clk,rst,'1',rr3);
rrr4: LoayregisterNoCLK generic map(n) port map(temp4,clk,rst,'1',rr4);
rrr5: LoayregisterNoCLK generic map(n) port map(temp5,clk,rst,'1',rr5);
rrr6: LoayregisterNoCLK generic map(n) port map(temp6,clk,rst,'1',rr6);
rrr7: LoayregisterNoCLK generic map(n) port map(temp7,clk,rst,'1',rr7);
rrr8: LoayregisterNoCLK generic map(n) port map(temp8,clk,rst,'1',rr8);
---------------------------------------------------------------------
DataOut1<=rr1 when ReadReg1="000" else
	  rr2 when ReadReg1="001" else
	  rr3 when ReadReg1="010" else
	  rr4 when ReadReg1="011" else
	  rr5 when ReadReg1="100" else
	  rr6 when ReadReg1="101" else
	  rr7 when ReadReg1="110" else
 	  rr8 when ReadReg1="111" ;

DataOut2<=rr1 when ReadReg2="000" else
	  rr2 when ReadReg2="001" else
	  rr3 when ReadReg2="010" else
	  rr4 when ReadReg2="011" else
	  rr5 when ReadReg2="100" else
	  rr6 when ReadReg2="101" else
	  rr7 when ReadReg2="110" else
 	  rr8 when ReadReg2="111" ;
--------------------------------------------------------------------------
END struct;
