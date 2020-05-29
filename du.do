vsim -gui work.decodingpart
add wave sim:/decodingpart/*
force -freeze sim:/decodingpart/instr 00000000000000000000000100000001 0
force -freeze sim:/decodingpart/wb 32'h00000007 0
force -freeze sim:/decodingpart/inport 32'h01111111 0
force -freeze sim:/decodingpart/wbdatasrc 00 0
force -freeze sim:/decodingpart/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/decodingpart/rstsignal 1 0
run
force -freeze sim:/decodingpart/rstsignal 0 0
run
force -freeze sim:/decodingpart/wreg1 001 0
force -freeze sim:/decodingpart/rwsignal1 1 0
force -freeze sim:/decodingpart/rwsignal2 0 0
run
force -freeze sim:/decodingpart/rwsignal1 0 0
run
force -freeze sim:/decodingpart/wreg2 000 0
force -freeze sim:/decodingpart/wdata2 32'h0000000F 0
force -freeze sim:/decodingpart/rwsignal2 1 0
run
force -freeze sim:/decodingpart/rwsignal2 0 0
run
run
run
run
force -freeze sim:/decodingpart/wbdatasrc 01 0
force -freeze sim:/decodingpart/wreg1 001 0
force -freeze sim:/decodingpart/rwsignal1 1 0
force -freeze sim:/decodingpart/rwsignal2 0 0
run
force -freeze sim:/decodingpart/rwsignal1 0 0
run
run