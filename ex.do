vsim -gui work.execute
add wave sim:/execute/*
force -freeze sim:/execute/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/execute/pcin 32'h00000005 0
force -freeze sim:/execute/regfiledata1 32'h00005555 0
force -freeze sim:/execute/ALUoutmem 32'h00001111 0
force -freeze sim:/execute/WBdata 32'h00009999 0
force -freeze sim:/execute/regfiledata2 32'h00005557 0
force -freeze sim:/execute/immvaluein 32'h00000000 0
force -freeze sim:/execute/effaddin 32'h00000999 0
force -freeze sim:/execute/readdatafromMEM 32'h00005533 0
force -freeze sim:/execute/BRenable 0 0
force -freeze sim:/execute/Rst 1 0
force -freeze sim:/execute/BRtype 11 0
force -freeze sim:/execute/forwardA 00 0
force -freeze sim:/execute/forwardB 00 0
force -freeze sim:/execute/carryenab 01 0
force -freeze sim:/execute/Rdestin 001 0
force -freeze sim:/execute/Rdest2in 111 0
force -freeze sim:/execute/instr 0000 0
force -freeze sim:/execute/ALUOP 0 0
force -freeze sim:/execute/wrflags 0 0
run
force -freeze sim:/execute/Rst 0 0
force -freeze sim:/execute/instr 0001 0
run
force -freeze sim:/execute/instr 0010 0
run
force -freeze sim:/execute/instr 0011 0
run
force -freeze sim:/execute/instr 0101 0
run
