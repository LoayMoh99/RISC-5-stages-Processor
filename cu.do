vsim -gui work.controlunit
add wave sim:/controlunit/*
force -freeze sim:/controlunit/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/controlunit/INT 0 0
force -freeze sim:/controlunit/Reset 0 0
force -freeze sim:/controlunit/op_code 00000 0
run
run
run
force -freeze sim:/controlunit/Reset 1 0
run
run
force -freeze sim:/controlunit/Reset 0 0
run
run
run
force -freeze sim:/controlunit/INT 1 0
force -freeze sim:/controlunit/op_code 00111 0
run
force -freeze sim:/controlunit/INT 0 0
run
run
run