Library ieee;
use ieee.std_logic_1164.all;

Entity buffer2 is
Generic(n:integer :=3);
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
end buffer2;

ARCHITECTURE reg_arrch of buffer2 is
component Loayregister is
Generic(n:integer :=32);
port (
Rin:in std_logic_vector(n-1 downto 0);
clk,rst,en:in std_logic;
Rout:out std_logic_vector(n-1 downto 0));
end component;

Signal enable:std_logic;
Begin

p: Loayregister generic map(32) port map(pcin,clk,flush,'1',pcout);
im: Loayregister generic map(32) port map(immvalin,clk,flush,'1',immvalout);
ef: Loayregister generic map(32) port map(effaddrin,clk,flush,'1',effaddrout);
dr: Loayregister generic map(32) port map(datareg1in,clk,flush,'1',datareg1out);
dr2: Loayregister generic map(32) port map(datareg2in,clk,flush,'1',datareg2out);
ins: Loayregister  generic map(4) port map(instrin,clk,flush,'1',instrout);
sr1: Loayregister generic map(3) port map(srcreg1in,clk,flush,'1',srcreg1out);
sr2: Loayregister generic map(3) port map(srcreg2in,clk,flush,'1',srcreg2out);
dst: Loayregister generic map(3) port map(destregin,clk,flush,'1',destregout);
cu1: Loayregister generic map(8) port map(exesignalin,clk,flush,'1',exesignalout);
cu2: Loayregister generic map(8) port map(memsignalin,clk,flush,'1',memsignalout);
cu3: Loayregister generic map(4) port map(wbsignalin,clk,flush,'1',wbsignalout);
End reg_arrch;