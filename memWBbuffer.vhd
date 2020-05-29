Library ieee;
use ieee.std_logic_1164.all;

Entity buffer4 is 
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

end buffer4;

ARCHITECTURE regarrch of buffer4 is
component LoayregisterFalling is
Generic(n:integer :=32);
port (
Rin:in std_logic_vector(n-1 downto 0);
clk,rst,en:in std_logic;
Rout:out std_logic_vector(n-1 downto 0));
end component;

Begin

u1: LoayregisterFalling generic map(32) port map(readdata,clk,flush,'1',readdataout);
u2: LoayregisterFalling generic map(32) port map(dataswaps,clk,flush,'1',dataswapsout);
u3: LoayregisterFalling generic map(32) port map(aluoutp,clk,flush,'1',aluoutpout);
m1: LoayregisterFalling generic map(3) port map(reg1,clk,flush,'1',reg1out);
m2: LoayregisterFalling generic map(3) port map(reg2,clk,flush,'1',reg2out);
cc1: LoayregisterFalling generic map(4) port map(towbsignal,clk,flush,'1',fromwbsignal);
End regarrch; 