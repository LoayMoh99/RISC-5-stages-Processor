vsim -gui work.risc_processor_v
add wave -position insertpoint  \
sim:/risc_processor_v/clk
add wave -position insertpoint  \
sim:/risc_processor_v/INT \
sim:/risc_processor_v/Reset \
sim:/risc_processor_v/INport \
sim:/risc_processor_v/OUTport
add wave -position insertpoint  \
sim:/risc_processor_v/Instructionbits \
sim:/risc_processor_v/PC \
sim:/risc_processor_v/OutInstruction \
sim:/risc_processor_v/OutPC_FD \
sim:/risc_processor_v/PC_outDU \
sim:/risc_processor_v/OutPC_DE \
sim:/risc_processor_v/PC_outEU \
sim:/risc_processor_v/OutPC_EM
add wave -position insertpoint  \
sim:/risc_processor_v/dataOut1 \
sim:/risc_processor_v/dataOut2
add wave -position insertpoint sim:/risc_processor/CU/*
add wave -position insertpoint  \
sim:/risc_processor_v/AluOut
add wave -position insertpoint  \
sim:/risc_processor_v/ReadOutMemData \
sim:/risc_processor_v/AlUouttowb \
sim:/risc_processor_v/WBDATAA
force -freeze sim:/risc_processor_v/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/risc_processor_v/INT 0 0
force -freeze sim:/risc_processor_v/Reset 1 0
force -freeze sim:/risc_processor_v/INport 32'h00004444 0
mem load -i {C:/Users/Otrebor Azilab/Desktop/Arch Project/instrMem.mem} -format binary /risc_processor_v/fu/memory/InstMem
mem load -i {C:/Users/Otrebor Azilab/Desktop/Arch Project/dataMem.mem} -format binary /risc_processor_v/mem_stagee/dat/Mem
run
force -freeze sim:/risc_processor_v/Reset 0 0
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