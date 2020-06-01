vsim -gui work.risc_processor
add wave -position insertpoint  \
sim:/risc_processor/clk
add wave -position insertpoint  \
sim:/risc_processor/INT \
sim:/risc_processor/Reset \
sim:/risc_processor/INport \
sim:/risc_processor/OUTport
add wave -position insertpoint  \
sim:/risc_processor/Instructionbits \
sim:/risc_processor/PC \
sim:/risc_processor/OutInstruction \
sim:/risc_processor/OutPC_FD \
sim:/risc_processor/PC_outDU \
sim:/risc_processor/OutPC_DE \
sim:/risc_processor/PC_outEU \
sim:/risc_processor/OutPC_EM
add wave -position insertpoint  \
sim:/risc_processor/dataOut1 \
sim:/risc_processor/dataOut2
add wave -position insertpoint  \
sim:/risc_processor/AluOut
add wave -position insertpoint  \
sim:/risc_processor/ReadOutMemData \
sim:/risc_processor/AlUouttowb \
sim:/risc_processor/WBDATAA
add wave -position insertpoint  \
sim:/risc_processor/ReadOutMem	\
sim:/risc_processor/OutMem
add wave -position insertpoint  \
sim:/risc_processor/mem_stagee/ss/inSP \
sim:/risc_processor/mem_stagee/ss/outSP
add wave -position insertpoint sim:/risc_processor/CU/*
force -freeze sim:/risc_processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/risc_processor/INT 0 0
force -freeze sim:/risc_processor/Reset 1 0
mem load -i {C:/Users/Otrebor Azilab/Desktop/Arch Project/GinstrMem.mem} -format binary /risc_processor/fu/memory/InstMem
mem load -i {C:/Users/Otrebor Azilab/Desktop/Arch Project/dataMem.mem} -format binary /risc_processor/mem_stagee/dat/Mem
run
force -freeze sim:/risc_processor/Reset 0 0
run
run
force -freeze sim:/risc_processor/INport 32'h0CDAFE19 0
run
force -freeze sim:/risc_processor/INport 32'h0000FFFF 0
run
force -freeze sim:/risc_processor/INport 32'h0000F320  0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run