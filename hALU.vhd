Library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;               -- Needed for shifts

Entity ALU is
generic(n: integer :=32);
port(
in1,in2: IN std_logic_vector (n-1 downto 0);

sel: IN std_logic_vector (4 downto 0);

outALU: OUT std_logic_vector (n-1 downto 0);
flagout: OUT std_logic_vector (3 downto 0)); ---zawdtha 3ashan output lel ccr
					--(0) ->Z-flag
					--(1) ->C-flag
					--(2) ->N-flag
end ALU;
 
ARCHITECTURE structALU of ALU is
COMPONENT my_Nadder IS
GENERIC(n:integer :=32);
PORT (a,b : IN  std_logic_vector(n-1 downto 0);
	cin : IN std_logic;
	cout : OUT std_logic;
	s: OUT std_logic_vector(n-1 downto 0));
END COMPONENT;
signal cinTemp,flagout2 :std_logic;
signal tempinSub : std_logic_vector(31 downto 0);
signal tempin : std_logic_vector(31 downto 0);
signal tempoutAlu :std_logic_vector(31 downto 0);
signal tempout :std_logic_vector(31 downto 0);
signal r_Unsigned_L,r_Unsigned_L2: unsigned(31 downto 0)    :=x"00000000";
signal r_Unsigned_R,r_Unsigned_R2: unsigned(31 downto 0)    :=x"00000000";
signal const1 :std_logic_vector(31 downto 0)	:=x"00000001";
signal integerImm : integer;
begin

cinTemp<='1' when sel ="00001" --sub
	   else '0';
tempin<= in2 when sel ="00000"  else  --add
	 not in2 when sel ="00001"  else  --sub
	 const1 when sel ="01000" else  --inc
	(Others => '1') when sel="01001" else   -- dec
        in2 when sel="11011" else --add imd  
	(Others => '0');
                          
u0: my_Nadder GENERIC MAP (n) port map (in1,tempin,cinTemp,flagout2,tempoutAlu);

integerImm <=to_integer(unsigned(in2(4 downto 0)));

r_Unsigned_L <= shift_left(unsigned(in1), integerImm-1); -- Left Shift
r_Unsigned_R <= shift_right(unsigned(in1), integerImm-1);  -- Right Shift

flagout(1)<= std_logic(r_Unsigned_L(31)) when sel ="00111" else
	     std_logic(r_Unsigned_R(0)) when sel ="00110" else
	     flagout2 when sel ="00000" else
	     flagout2 when sel ="00001" else
	     flagout2 when sel ="01000" else
	     flagout2 when sel ="01001" else
	     flagout2 when sel ="11011" else
	     '0';

r_Unsigned_L2 <= shift_left(r_Unsigned_L, 1); -- Left Shift
r_Unsigned_R2 <= shift_right(r_Unsigned_R, 1);  -- Right Shift

tempout<=(in1 and in2) when sel="00010" --and
	else (in1 or in2) when sel="00011"--or
	else (not in1) when sel="01111"-- not
	else  in1 when sel="00100"-- swap
	else std_logic_vector(r_Unsigned_R2) when sel="00110" --shr
	else std_logic_vector(r_Unsigned_L2) when sel="00111" --shl
	else in1 when sel ="01100" --to out port
	else in1 when sel ="11100" --push
	else in1 when sel ="11001" --store
	else tempoutAlu;
	

flagout(2)<= tempout(n-1); --set negative flag..
flagout(0)<='1' when tempout =(x"00000000") else '0'; --set zero flag..
flagout(3)<='0';
outALU<=tempout;




end structALU;
