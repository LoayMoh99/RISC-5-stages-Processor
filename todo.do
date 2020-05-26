vsim work.ccrregister -gn=32
add wave -position insertpoint  \
sim:/ccrregister/inflags \
sim:/ccrregister/clkk \
sim:/ccrregister/rstt \
sim:/ccrregister/carryenable \
sim:/ccrregister/branchtype \
sim:/ccrregister/outflags 
force -freeze sim:/ccrregister/inflags 0100 0
force -freeze sim:/ccrregister/clkk 0 0, 1 {50 ps} -r 100
force -freeze sim:/ccrregister/rstt 0 0
force -freeze sim:/ccrregister/carryenable 01 0
force -freeze sim:/ccrregister/branchtype 00 0
run
run
run
#reserve elvalue eladema
force -freeze sim:/ccrregister/carryenable 00 0
run
run
#set carry => 11xx
force -freeze sim:/ccrregister/carryenable 11 0
run
#reserve elvalue eladema 
force -freeze sim:/ccrregister/carryenable 10 0
force -freeze sim:/ccrregister/branchtype 00 0
run
# clear zero flag => 1xx0
force -freeze sim:/ccrregister/carryenable 10 0
force -freeze sim:/ccrregister/branchtype 01 0
run
# clear carry flag =>10xx
force -freeze sim:/ccrregister/carryenable 10 0
force -freeze sim:/ccrregister/branchtype 10 0
run
# clear neg flag => 1x0x
force -freeze sim:/ccrregister/carryenable 10 0
force -freeze sim:/ccrregister/branchtype 11 0
run