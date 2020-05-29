vsim -gui work.fu_fd
add wave sim:/fu_fd/*
mem load -i {C:/Users/Otrebor Azilab/Desktop/Arch Project/instrMem.mem} -format binary /fu_fd/fu/memory/InstMem
force -freeze sim:/fu_fd/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fu_fd/StallCU 1 0
force -freeze sim:/fu_fd/StallHU 0 0
force -freeze sim:/fu_fd/Call 0 0
force -freeze sim:/fu_fd/Int1 0 0
force -freeze sim:/fu_fd/Int2 0 0
force -freeze sim:/fu_fd/Reset 1 0
force -freeze sim:/fu_fd/Flush 0 0
force -freeze sim:/fu_fd/Reset1 0 0
force -freeze sim:/fu_fd/Branch 32'h0000000C 0
force -freeze sim:/fu_fd/PoppedPC 32'h00000004 0
force -freeze sim:/fu_fd/PCsrc 0 0
force -freeze sim:/fu_fd/ChangePC 0 0
force -freeze sim:/fu_fd/callRdst 32'h00000011 0
run
force -freeze sim:/fu_fd/StallCU 0 0
force -freeze sim:/fu_fd/Reset 0 0
run
run
run
run
run
force -freeze sim:/fu_fd/PCsrc 1 0
run
force -freeze sim:/fu_fd/PCsrc 0 0
force -freeze sim:/fu_fd/Flush 1 0
force -freeze sim:/fu_fd/StallCU 1 0
run
force -freeze sim:/fu_fd/Flush 0 0
force -freeze sim:/fu_fd/StallCU 0 0
run