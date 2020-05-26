vsim -gui work.fetchunit
add wave sim:/fetchunit/*
mem load -i {C:/Users/Otrebor Azilab/Desktop/ArchReso/FU/instrMem.mem} -format binary /fetchunit/memory/InstMem
force -freeze sim:/fetchunit/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fetchunit/Flush 0 0
force -freeze sim:/fetchunit/StallCU 0 0
force -freeze sim:/fetchunit/StallHU 0 0
force -freeze sim:/fetchunit/Call 0 0
force -freeze sim:/fetchunit/Int1 0 0
force -freeze sim:/fetchunit/Reset1 0 0
force -freeze sim:/fetchunit/Int2 0 0
force -freeze sim:/fetchunit/Reset2 0 0
force -freeze sim:/fetchunit/FirstThreeBitodOPcode 000 0
force -freeze sim:/fetchunit/Branch 32'h00000011 0
force -freeze sim:/fetchunit/PoppedPC 32'h00000004 0
force -freeze sim:/fetchunit/PCsrc 0 0
force -freeze sim:/fetchunit/ChangePC 0 0
force -freeze sim:/fetchunit/callRdst 32'h00000011 0
run
run
run