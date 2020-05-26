LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


Entity memorystage is
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

end entity memorystage;

ARCHITECTURE archmm of memorystage is
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
component Mem IS
PORT(clk,we,re : IN std_logic; 
address : IN  std_logic_vector(31 DOWNTO 0);
dataIn  : IN  std_logic_vector(31 DOWNTO 0);
dataOut : OUT std_logic_vector(31 DOWNTO 0));
end component;

component stadder is
generic(n:integer :=32);
port(
inp1: IN std_logic_vector(n-1 downto 0);
--inp2: IN std_logic_vector(1 downto 0);
sel: IN std_logic;
outst : out std_logic_vector(n-1 downto 0));
end component;

Signal wd,adr: std_logic_vector(31 downto 0);
Signal sp: std_logic_vector(31 downto 0):=x"00001111";

Begin
mm1: Mux4x1 generic map(n) port map(pccall,flags,aluoutt,aluoutt,memsrcdata,wd); --out to data memory
ss: stadder generic map(n) port map(sp,stackaddersignal,sp);
mm2: mux2 generic map(n) port map(effectiveadr,sp,stackenable,adr);
dat: Mem port map(clk,memwrite,memread,adr,wd,readdataout);
dataswapout<=dataswapin;
aluoutput<=aluoutt;
rdest1<=rdestin1;
rdest2<=rdestin2;
End archmm;