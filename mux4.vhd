Library ieee;
Use ieee.std_logic_1164.all;

entity mux4 is
Generic(n:integer :=32);
 port (q1:IN std_logic_vector (n-1 downto 0); q2: IN std_logic_vector (n-1 downto 0);
                q3: IN std_logic_vector (n-1 downto 0); q4: IN std_logic_vector (n-1 downto 0);
                 q5:IN std_logic_vector (n-1 downto 0); q6: IN std_logic_vector (n-1 downto 0);
                q7: IN std_logic_vector (n-1 downto 0); q8: IN std_logic_vector (n-1 downto 0);
                selmux: IN std_logic_vector (2 downto 0); m: out std_logic_vector (n-1 downto 0));
end entity mux4;





architecture archi of mux4 is
begin
process (q1,q2,q3,Selmux(0),Selmux(1),Selmux(2)) is
begin

if (selmux="000") then m <= q1;
elsif  (selmux="001") then m <= q2;
elsif (selmux="010") then m<= q3;
elsif (selmux="011" ) then m <= q4;
elsif (selmux="100") then m<= q5;
elsif (selmux="101") then m<= q6; 
elsif (selmux="110") then m<= q7;
else m<= q8;
end if;
end process;
end archi;

 
