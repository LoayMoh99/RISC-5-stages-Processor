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
	Reset1,CallEn,INT1,INT2,StallCU,F_Flush,WrFlags,ChangePC : OUT std_logic;
	MemSrcData : OUT std_logic_vector(1 downto 0)
);
end entity ControlUnit;

Architecture ControlUnit_arch of ControlUnit is


signal counter: unsigned(2 downto 0):="000";
signal compNormal: std_logic_vector(1 downto 0):="00";
signal currFetchIsMem: std_logic:='0'; --0-> not mem or 1->mem
signal sel: std_logic_vector(2 downto 0);--sel which counter works.. 

Begin
Process(clk,INT,Reset,op_code(4 downto 0)) is
begin
if rising_edge(clk) then
	if counter/="000" then
		counter<= to_unsigned((to_integer(counter))-1,3);
	end if;
end if;

--reset
if Reset='1' then
	counter<="010";
	sel<="000";
--interrupt
elsif INT='1' then
	compNormal<="11";--comp normally the curr fetched instr..
	counter<="101";
	--INT1<='1';
	sel<="001";
--call
elsif op_code(4 downto 0)="10011" then
   if counter/= "001" then
	counter<="001";
	sel<="010";
   end if;
--ret
elsif op_code(4 downto 0)="11110" then
   if counter/= "011" then
	counter<="100";
	sel<="011";
   end if;
--rti
elsif op_code(4 downto 0)="11111" then
   if counter/= "011" then
	counter<="100";
	sel<="100";
   end if;
elsif counter="000" then
	sel<="111";
end if;
------ReseT------
   if sel="000" then --reset
	--BranchEN<='0';regWrite<='0';regWrite2<='0';OUTportEN<='0';memRead<='0';memWrite<='0';StackEN<='0';
	--CarryEN<="00";WBdataSrc <="00";
	compNormal<="00";
	if counter="010" then
		StallCU<='1'; 
		F_Flush<='1'; 
		Reset1<='0'; 
	MemSrcData <="10";
	CallEn <='0';
	INT1<='0'; 
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="001" then
		StallCU<='0'; 
		F_Flush<='0'; 
		Reset1<='1'; 
	MemSrcData <="10";
	CallEn <='0';
	INT1<='0'; 
	WrFlags<='0';
	ChangePC<='0';
	else sel<="111";
	end if;
----------INT-----------
   elsif sel="001" then --int
	--BranchEN<='0';regWrite<='0';regWrite2<='0';OUTportEN<='0';
	--CarryEN<="00";WBdataSrc <="00";
	if counter="101" then --pc to be pushed in FD buffer
		 compNormal<="11";
		 INT1<='1';
		 INT2<='0'; 
		if op_code(4 downto 1)="1110" or op_code(4 downto 1)="1100"  then
			currFetchIsMem<='1';
		else 	currFetchIsMem<='0';
		end if;
	--memRead<='0';memWrite<='0';StackEN<='0';
	elsif counter="100" then --pc to be pushed in DE buffer
	compNormal<="00";
		 StallCU<='1';
		 F_Flush<='1'; 
		 INT1<='0';
		 INT2<='1'; 
	MemSrcData <="10";
	Reset1<='0'; 
	WrFlags<='0';
	ChangePC<='0';
	--memRead<='0';memWrite<='0';StackEN<='0';
	-----------
	elsif counter="011" then
		if currFetchIsMem='1' then
			StallCU<='1'; 
		else 	
			--push flags
			StallCU<='0'; 
			MemSrcData <="01";
		 	StackEn<='1'; --push flags	 
		 	StackAddr<='0';
		 	memWrite<='1';
		 	memRead<='0';
		end if;
	compNormal<="00";
	INT1<='0';
	INT2<='0'; 
	F_Flush<='0'; --
	CallEn <='0';
	Reset1<='0'; 
	WrFlags<='0';
	ChangePC<='0';
	-------------
	elsif counter="010" then
		if currFetchIsMem='1' then
			--push flags
			StallCU<='0'; 
			MemSrcData <="01";
		 	StackEn<='1'; --push flags	 
		 	StackAddr<='0';
		 	memWrite<='1';
		 	memRead<='0';

		else 	
			--push pc
			StallCU<='0'; 
			MemSrcData <="00";
		 	StackEn<='1'; --push pc	 
		 	StackAddr<='0';
		 	memWrite<='1';
		 	memRead<='0';
		end if;
	compNormal<="00";
	F_Flush<='0'; 
	INT1<='0'; 
	INT2<='0'; 
	CallEn <='0';
 	Reset1<='0'; 
	WrFlags<='0';
	ChangePC<='0';
	------------
	elsif counter="001" then
		if currFetchIsMem='1' then
			--push pc
			StallCU<='0'; 
			MemSrcData <="00";
		 	StackEn<='1'; --push pc	 
		 	StackAddr<='0';
		 	memWrite<='1';
		 	memRead<='0';
			compNormal<="00";
		else 	
			compNormal<="10";
			--memRead<='0';memWrite<='0';StackEN<='0';
		end if;
	F_Flush<='0'; 
	INT1<='0'; 
	INT2<='0'; 
	CallEn <='0';
 	Reset1<='0'; 
	WrFlags<='0';
	ChangePC<='0';
	else sel<="111";
	end if;
--------CALL-------------
    elsif sel="010" then --call
	--BranchEN<='0';regWrite<='0';regWrite2<='0';OUTportEN<='0';
	--CarryEN<="00";WBdataSrc <="00";
	--compNormal<="00";
	if counter="001" then
		 StallCU<='1'; 
		 F_Flush<='0'; 
		 StackEn<='1';--push pc
		 StackAddr<='0';
		 MemSrcData<="00"; --pc
		 memWrite<='1';
		 memRead<='0';
	Reset1<='0'; 
	INT1<='0'; 
	INT2<='0';  
	WrFlags<='0';
	ChangePC<='0';
	CallEn <='1';
--	elsif counter="001" then
--		 StallCU<='0'; 
--		 CallEn <='0';
--		 F_Flush<='1'; 
--		 StackEn<='0';
--	Reset1<='0'; 
--	INT1<='0'; 
--	INT2<='0';  
--	WrFlags<='0';
--	ChangePC<='0';
	else 	sel<="111";
		StallCU<='0';
	end if;
---------RET-------------
    elsif sel="011" then --ret
	--BranchEN<='0';regWrite<='0';regWrite2<='0';OUTportEN<='0';
	--CarryEN<="00";WBdataSrc <="00";
	compNormal<="00";
	if counter="100" then
		 StallCU<='1'; 
		 F_Flush<='1'; 
		 StackEn<='1'; --pop pc	 
		 StackAddr<='1';
		 MemSrcData<="00"; --pc
		 memRead<='1';
		 memWrite<='0';
	Reset1<='0'; 
	INT1<='0';
	INT2<='0';   
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="011" then
		 StallCU<='1'; 
		 F_Flush<='1'; 	
	MemSrcData <="10";
	CallEn <='0';
	Reset1<='0'; 
	INT1<='0';
	INT2<='0';   
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="010" then
		 StallCU<='1'; 
		 F_Flush<='1';
		 ChangePC<='1'; 	
	MemSrcData <="10";
	CallEn <='0';
	Reset1<='0'; 
	INT1<='0';
	INT2<='0';   
	WrFlags<='0';
	elsif counter="001" then
		 StallCU<='1'; 
		 F_Flush<='0';
		 ChangePC<='1'; 	
	MemSrcData <="10";
	CallEn <='0';
	Reset1<='0'; 
	INT1<='0';
	INT2<='0';   
	WrFlags<='0';
	else sel<="111";
	end if;
----------RTI--------------
    elsif sel="100" then --rti
	--BranchEN<='0';regWrite<='0';regWrite2<='0';OUTportEN<='0';
	--CarryEN<="00";WBdataSrc <="00";
	compNormal<="00";
	if counter="100" then
		 StallCU<='1'; 
		 F_Flush<='1'; 
		 StackEn<='1'; --pop pc	
		 StackAddr<='1'; 
		 MemSrcData<="00"; --pc
		 memRead<='1';
		 memWrite<='0';
	Reset1<='0'; 
	INT1<='0';
	INT2<='0';   
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="011" then
		 StallCU<='1'; 
		 F_Flush<='1'; 	
		 StackEn<='1'; --pop flags	
		 StackAddr<='1'; 
		 MemSrcData<="01"; --flags
		 memRead<='1';
		 memWrite<='0';
	Reset1<='0'; 
	INT1<='0';
	INT2<='0';   
	WrFlags<='0';
	ChangePC<='0';
	elsif counter="010" then
		 StallCU<='1'; 
		 F_Flush<='1';
		 ChangePC<='1'; 
		 CarryEn<="01";
		 WrFlags<='1';
	MemSrcData <="10";
	CallEn <='0';
	Reset1<='0'; 
	INT1<='0';
	INT2<='0';   
	elsif counter="001" then
		 StallCU<='1'; 
		 F_Flush<='0';
		 ChangePC<='1'; 	
	MemSrcData <="10";
	CallEn <='0';
	Reset1<='0'; 
	INT1<='0';
	INT2<='0';   
	WrFlags<='0';
	else sel<="111";
	end if;
   else 
	compNormal<="00";
   end if;

   if counter="000" or compNormal(1) ='1' then
--bn clear all the special signals that is used by Special instr and events..
	StallCU<='0'; 
	F_Flush<='0';
	CallEn <='0';
	Reset1<='0'; 
	WrFlags<='0';
	ChangePC<='0';
 MemSrcData <="10";

	if compNormal(1)='0' then 	
	 	INT1<='0';
		INT2<='0'; 
	end if;
--Here is the declaring of all the control signals by the op_code of the instructions..
	if op_code(4)='0' OR op_code(4 downto 0)="10000" OR op_code(4 downto 0)="11001" OR op_code(4 downto 0)="11100"then
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
	if (op_code(4 downto 1)="0101" OR op_code(4 downto 2)="101" OR op_code(4 downto 0)="01100" OR op_code(4 downto 0)="10000" OR op_code(4 downto 0)="11001" OR op_code(4 downto 0)="11100") then
		regWrite<='0';
	else 	regWrite<='1';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 0)="00100" and Rdst/=Rsrc then
		regWrite2<='1';
	else 	regWrite2<='0';
	end if;
----------------------------------------------------------------------------------
	if (op_code(4 downto 0)="11000" OR op_code(4 downto 0)="11101") then
		memTOreg<='0';
		memRead<='1';
	else 	
		memTOreg<='1';
		memRead<='0';
	end if;
----------------------------------------------------------------------------------
	if op_code(4 downto 0)="01100" then
		OUTportEN<='1';
	else 	OUTportEN<='0';
	end if;
----------------------------------------------------------------------------------
	if (op_code(4 downto 0)="11001" OR op_code(4 downto 0)="11100") then
		memWrite<='1';
		--MemSrcData <="11";
	else 	--MemSrcData <="10";
		memWrite<='0';
	end if;
   end if;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
end Process;

end ControlUnit_arch;
