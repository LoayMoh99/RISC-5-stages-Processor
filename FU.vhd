Library ieee;
use ieee.std_logic_1164.all;

Entity forwardingUnit is
port(
--------------------------------
--Inputs------------------------
DErsrc1 : IN std_logic_vector (2 downto 0); 
DErsrc2 : IN std_logic_vector (2 downto 0);
EMrdst: IN std_logic_vector (2 downto 0);
MWrdst: IN std_logic_vector (2 downto 0);
EMrdst2: IN std_logic_vector (2 downto 0);
MWrdst2: IN std_logic_vector (2 downto 0);
EMregWr:IN std_logic ;
MWregWr:IN std_logic ;
EMregWr2:IN std_logic ;
MWregWr2:IN std_logic ;
ALUsrc:IN std_logic;
clk: IN std_logic;
-------------------------------------------
--outputs----------------------------------
forwardA: OUT std_logic_vector (1 downto 0);
forwardB: OUT std_logic_vector (1 downto 0)
);
END forwardingUnit;

--------------------------------------------------------------
ARCHITECTURE STRUCTfu of forwardingUnit is
begin
    
forwardA<="11" when (( MWregWr='1') and ( EMrdst<=DErsrc1 ) and (MWrdst<=DErsrc1 )) else
          "10" when  (    (EMregWr='1') and (EMrdst<=DErsrc1)       )               else
          "11" when   (   (MWregWr='1') and  (MWrdst<=DErsrc1 )   )                 else
         "00" when   (ALUsrc='1')                                                  else
         "11"  when   (( MWregWr2='1') and ( EMrdst2<=DErsrc1 ) and (MWrdst2<=DErsrc1 )) else
         "10" when   (    (EMregWr2='1') and (EMrdst2<=DErsrc1)       ) else
         "11" when     (   (MWregWr2='1') and  (MWrdst2<=DErsrc1 )   ) else
        "00" ;
          
  ------------------------------------------------------------------------------------------------
 
 forwardB<= "11"  when   (  ( MWregWr='1') and ( EMrdst<=DErsrc2 ) and (MWrdst<=DErsrc2 )) else
            "10"  when     (      (EMregWr='1') and      (EMrdst<=DErsrc2)            )     else
            "11"   when  (   (MWregWr='1') and  (MWrdst<=DErsrc2 )   )                   else
            "00"   when  (ALUsrc='1')            else
            "11" when   (  ( MWregWr2='1') and ( EMrdst2<=DErsrc2 ) and (MWrdst2<=DErsrc2 )) else
            "10"    when    (      (EMregWr2='1') and      (EMrdst2<=DErsrc2)            )   else
            "11"    when  (   (MWregWr2='1') and  (MWrdst2<=DErsrc2 )   )                    else
            "00"    ;
          
          
          
    
  
end STRUCTfu;