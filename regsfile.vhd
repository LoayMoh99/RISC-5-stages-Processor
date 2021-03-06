LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


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

TYPE Reg_type IS ARRAY(0 TO 7) OF std_logic_vector(n-1 DOWNTO 0);
SIGNAL Reg : Reg_type ;
BEGIN
PROCESS(clk) IS
BEGIN
		IF rst='1' then
			Reg(0)<=x"00000000";
			Reg(1)<=x"00000000";
			Reg(2)<=x"00000000";
			Reg(3)<=x"00000000";
			Reg(4)<=x"00000000";
			Reg(5)<=x"00000000";
			Reg(6)<=x"00000000";
			Reg(7)<=x"00000000";
		ELSIF rising_edge(clk) THEN  
			IF RegWrite1 = '1' THEN
				Reg(to_integer(unsigned(WriteReg1))) <= WriteData1;
			END IF;
			IF RegWrite2 = '1' THEN
				Reg(to_integer(unsigned(WriteReg2))) <= WriteData2;
			END IF;
		END IF;
                
END PROCESS;
                        DataOut1<= Reg(to_integer(unsigned(ReadReg1)));
                        DataOut2<= Reg(to_integer(unsigned(ReadReg2)));
END struct;
