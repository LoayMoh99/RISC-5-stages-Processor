vsim -gui work.regsfile
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
force -freeze sim:/regsfile/ReadReg1 011 0
force -freeze sim:/regsfile/RegWrite1 0 0
run
force -freeze sim:/regsfile/WriteReg2 111 0
force -freeze sim:/regsfile/WriteData2 32'h0000FFFF 0
force -freeze sim:/regsfile/RegWrite2 1 0
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
