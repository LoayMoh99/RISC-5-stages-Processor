LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

Entity ControlUnit is
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
	MemSrcData : OUT std_logic_vector(1 downto 0)
);
end entity ControlUnit;

Architecture ControlUnit_arch of ControlUnit is

signal counter: unsigned(2 downto 0):="000";
signal compNormal: std_logic:='0';
signal sel: std_logic_vector(2 downto 0);--sel which counter works.. 

Begin
Process(clk,INT,Reset) is
begin
--reset
if Reset='1' then
	counter<="010";
	sel<="000";
--interrupt
elsif INT='1' then
	compNormal<='1';--comp normally the curr fetched instr..
	counter<="101";
	sel<="001";
--call
elsif op_code(4 downto 0)="10011" then
	counter<="010";
	sel<="001";
--ret
elsif op_code(4 downto 0)="11110" then
	counter<="011";
	sel<="011";
--rti
elsif op_code(4 downto 0)="11111" then
	counter<="011";
	sel<="100";
elsif counter="000" then
	sel<="111";
end if;
if rising_edge(clk) then
   if sel="000" then --reset
	compNormal<='0';
	if counter="010" then
		 StallCU<='1'; 
		 F_Flush<='1'; 
		 Reset1<='1'; 
		 Reset2<='0';

	MemSrcData <="10";
	CallEn <='0';
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="001" then
		 F_Flush<='1'; 
		 Reset1<='0'; 
		 Reset2<='1';
	MemSrcData <="10";
	StallCU<='0'; 
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	ChangePC<='0';
	else sel<="111";
	end if;

   elsif sel="001" then --int
	if counter="101" then
		 compNormal<='0';
	elsif counter="100" then
	compNormal<='0';
		 StallCU<='1';
		 F_Flush<='1'; 
		 INT1<='1'; 
		 INT2<='0';
	MemSrcData <="10";
	Reset1<='0'; 
	Reset2<='0';
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="011" then
	compNormal<='0';
		 F_Flush<='1'; 
		 INT1<='0'; 
		 INT2<='1';
	MemSrcData <="10";
	StallCU<='0'; 
	CallEn <='0';
	Reset1<='0'; 
	Reset2<='0';
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="010" then
	compNormal<='0';
		 F_Flush<='1'; 
		 Reset1<='0'; 
		 Reset2<='1';
	MemSrcData <="10";
	StallCU<='0'; 
	CallEn <='0';
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="001" then
	compNormal<='0';
		 F_Flush<='1'; 
		 Reset1<='0'; 
		 Reset2<='1';
	MemSrcData <="10";
	StallCU<='0'; 
	CallEn <='0';
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	ChangePC<='0';
	else sel<="111";
	end if;

    elsif sel="010" then --call
	compNormal<='0';
	if counter="001" then
		 StallCU<='1'; 
		 F_Flush<='1'; 
		 CallEn <='1';
		 StackEn<='1';--push pc
		 StackAddr<='0';
		 MemSrcData<="00"; --pc
		 memWrite<='1';
		 memRead<='0';
	Reset1<='0'; 
	Reset2<='0';
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	ChangePC<='0';
	else sel<="111";
	end if;

    elsif sel="011" then --ret
	compNormal<='0';
	if counter="011" then
		 StallCU<='1'; 
		 F_Flush<='1'; 
		 StackEn<='1'; --pop pc	 
		 StackAddr<='1';
		 MemSrcData<="00"; --pc
		 memRead<='1';
		 memWrite<='0';
	Reset1<='0'; 
	Reset2<='0';
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="010" then
		 StallCU<='1'; 
		 F_Flush<='1'; 	
	MemSrcData <="10";
	CallEn <='0';
	Reset1<='0'; 
	Reset2<='0';
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="001" then
		 StallCU<='1'; 
		 F_Flush<='0';
		 ChangePC<='1'; 	
	MemSrcData <="10";
	CallEn <='0';
	Reset1<='0'; 
	Reset2<='0';
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	else sel<="111";
	end if;

    elsif sel="100" then --rti
	compNormal<='0';
	if counter="011" then
		 StallCU<='1'; 
		 F_Flush<='1'; 
		 StackEn<='1'; --pop pc	
		 StackAddr<='1'; 
		 MemSrcData<="00"; --pc
		 memRead<='1';
		 memWrite<='0';
	Reset1<='0'; 
	Reset2<='0';
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="010" then
		 StallCU<='1'; 
		 F_Flush<='1'; 	
		 StackEn<='1'; --pop flags	
		 StackAddr<='1'; 
		 MemSrcData<="01"; --flags
		 memRead<='1';
		 memWrite<='0';
	Reset1<='0'; 
	Reset2<='0';
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="001" then
		 StallCU<='1'; 
		 F_Flush<='0';
		 ChangePC<='1'; 
		 CarryEn<="01";
		 WrFlags<='1';
	MemSrcData <="10";
	CallEn <='0';
	Reset1<='0'; 
	Reset2<='0';
	INT1<='0'; 
	INT2<='0';
	else sel<="111";
	end if;
   else 
	compNormal<='0';
   end if;

   if counter="000" or compNormal ='1' then
--bn clear all the special flags that is used by Special instr and events..
	MemSrcData <="10";
	StallCU<='0'; 
	F_Flush<='0';
	CallEn <='0';
	Reset1<='0'; 
	Reset2<='0';
	INT1<='0'; 
	INT2<='0';
	WrFlags<='0';
	ChangePC<='0';

	if compNormal='1' then 	counter<= to_unsigned((to_integer(counter))-1,3);
	end if;
--Here is the declaring of all the control signals by the op_code of the instructions..
	if op_code(4)='0' OR op_code(4 downto 0)="10000" then
		ALUop<='0';
	else 	ALUop<='1';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 2)="000" then
		ALUsrc<='0';
	else 	ALUsrc<='1';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 3)="00" OR op_code(4 downto 0)="01111" OR op_code(4 downto 1)="0100" OR op_code(4 downto 0)="11011"then
		CarryEN<="01";
	elsif op_code(4 downto 0)="01011" then
	 	CarryEN<="11";
	elsif op_code(4 downto 0)="01010" OR op_code(4 downto 2)="101" then
	 	CarryEN<="10";
	else CarryEN<="00";
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 0)="10100" then
		BrType<="00";
	elsif op_code(4 downto 0)="10101" then
		BrType<="01";
	elsif op_code(4 downto 0)="10111" then
		BrType<="11";
	else 	BrType<="10";
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 2)="101" then
		BranchEN<='1';
	else 	BranchEN<='0';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 1)="1110" then
		StackEN<='1';
	else 	StackEN<='0';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 0)="11100" then
		StackAddr<='0';
	else 	StackAddr<='1';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 0)="01110" then
		WBdataSrc<="01";
	elsif op_code(4 downto 0)="11010" then
		WBdataSrc<="10";
	else 	WBdataSrc<="00";
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 1)="0101" OR op_code(4 downto 2)="101" OR op_code(4 downto 0)="01100" OR op_code(4 downto 0)="10000" OR op_code(4 downto 0)="11001" OR op_code(4 downto 0)="11100" then
		regWrite<='0';
	else 	regWrite<='1';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 0)="00100" and Rdst/=Rsrc then
		regWrite2<='0';
	else 	regWrite2<='1';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 0)="11000" OR op_code(4 downto 0)="11101" then
		memTOreg<='0';
	else 	memTOreg<='1';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 0)="01100" then
		OUTportEN<='1';
	else 	OUTportEN<='0';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 0)="11000" OR op_code(4 downto 0)="11101" then
		memRead<='1';
	else 	memRead<='0';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 0)="11001" OR op_code(4 downto 0)="11100" then
		memWrite<='1';
	else 	memWrite<='0';
	end if;
   else counter<= to_unsigned((to_integer(counter))-1,3);
   end if;
----------------------------------------------------------------------------------
end if;
----------------------------------------------------------------------------------
end Process;

end ControlUnit_arch;
