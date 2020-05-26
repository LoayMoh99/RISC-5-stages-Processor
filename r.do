vsim -gui work.regsfile
# vsim -gui work.regsfile 
# Start time: 01:11:05 on May 25,2020
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.regsfile(struct)
# Loading work.decoder(dec)
# Loading work.registers(reg_arch)
# Loading work.mux4x1(archm)
# Loading work.mux4(archi)
add wave sim:/regsfile/*
force -freeze sim:/regsfile/ReadReg1 001 0
force -freeze sim:/regsfile/ReadReg2 000 0
force -freeze sim:/regsfile/rst 1 0

run
force -freeze sim:/regsfile/rst 0 0
force -freeze sim:/regsfile/RegWrite1 1 0
force -freeze sim:/regsfile/RegWrite2 0 0
force -freeze sim:/regsfile/WriteReg1 011 0
force -freeze sim:/regsfile/WriteData1 32'h00008888 0
force -freeze sim:/regsfile/clk 1 0, 0 {50 ps} -r 100
run
run
force -freeze sim:/regsfile/ReadReg1 011 0
run
force -freeze sim:/regsfile/RegWrite1 0 0
force -freeze sim:/regsfile/RegWrite2 1 0
force -freeze sim:/regsfile/WriteReg2 111 0
force -freeze sim:/regsfile/WriteData2 32'h0000FFFF 0
run
run
force -freeze sim:/regsfile/RegWrite2 0 0
force -freeze sim:/regsfile/ReadReg2 111 0
run
force -freeze sim:/regsfile/ReadReg2 111 0
force -freeze sim:/regsfile/RegWrite1 0 0
force -freeze sim:/regsfile/RegWrite2 1 0
force -freeze sim:/regsfile/WriteReg2 111 0
force -freeze sim:/regsfile/WriteData2 32'h0000F00F 0
run
force -freeze sim:/regsfile/RegWrite2 0 0
force -freeze sim:/regsfile/ReadReg1 111 0
force -freeze sim:/regsfile/ReadReg2 111 0
run
force -freeze sim:/regsfile/ReadReg1 011 0
run
force -freeze sim:/regsfile/ReadReg2 011 0
run
