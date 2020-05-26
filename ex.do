vsim work.alu -gn=32
add wave -position insertpoint  \
sim:/alu/n \
sim:/alu/in1 \
sim:/alu/in2 \
sim:/alu/sel \
sim:/alu/outALU \
sim:/alu/flagout \
sim:/alu/tempinSub \
sim:/alu/tempin \
sim:/alu/tempout \
sim:/alu/r_Unsigned_L \
sim:/alu/r_Unsigned_R \
sim:/alu/const1 \
sim:/alu/integerImm
force -freeze sim:/alu/integerImm 20'h00000 0
force -freeze sim:/alu/integerImm 0000000000 0
force -freeze sim:/alu/in1 32'h00011 0
force -freeze sim:/alu/in2 32'h00001 0
force -freeze sim:/alu/sel 0000 0
run