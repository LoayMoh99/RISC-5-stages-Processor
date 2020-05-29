vsim -gui work.memorystage
mem load -i {C:/Users/Otrebor Azilab/Desktop/Arch Project/dataMem.mem} -format binary /memorystage/dat/Mem
add wave sim:/memorystage/*
force -freeze sim:/memorystage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/memorystage/flags 32'h0000000F 0
force -freeze sim:/memorystage/pccall 32'h00000001 0
force -freeze sim:/memorystage/effectiveadr 32'h00000000 0
force -freeze sim:/memorystage/aluoutt 32'h00000001 0
force -freeze sim:/memorystage/dataswapin 32'h00000001 0
force -freeze sim:/memorystage/rdestin1 001 0
force -freeze sim:/memorystage/rdestin2 011 0
force -freeze sim:/memorystage/stackenable 0 0
force -freeze sim:/memorystage/rst 1 0
force -freeze sim:/memorystage/memsrcdata 10 0
force -freeze sim:/memorystage/stackaddersignal 0 0
force -freeze sim:/memorystage/memread 1 0
force -freeze sim:/memorystage/memwrite 0 0
run
force -freeze sim:/memorystage/rst 0 0
run 
run
force -freeze sim:/memorystage/stackenable 1 0
run
run
force -freeze sim:/memorystage/stackaddersignal 1 0
run
run