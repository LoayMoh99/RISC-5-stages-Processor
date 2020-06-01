# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
in R2        #R2=0CDAFE19 add 0CDAFE19 in R2 /// 00000000 010 01110   1
in R3        #R3=FFFF                       ///  00000000 011 01110    1
in R4        #R4=F320                       ///  00000000 100 01110   3
LDM R1,F5    #R1=F5                         ///  0000000000000111 1010100000111010     3
----
PUSH R1      #SP=7FC, M[7FE, 7FF] = F5      ///  0000000100011100  5
PUSH R2      #SP=7FA,M[7FC, 7FD]=0CDAFE19   ///  0000001000011100  6
-?
POP R1       #SP=7FC,R1=0CDAFE19            ///  0000000000111101--7
POP R2       #SP=7FE,R2=F5                  ///  0000000001011101  8
----*3
STD R2,200   #M[200, 201]=F5                ///  0000000000010000 0000001000011001  --9
STD R1,202   #M[202, 203]=0CDAFE19          ///  0000000000100000 0010000100011001--10

LDD R3,202   #R3=0CDAFE19                   //   0000000000010000 0001000001111000
LDD R4,200   #R4=F5                          //   0000000000010000 0000000010011000
