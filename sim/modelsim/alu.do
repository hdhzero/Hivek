vlib work
vmap work

vcom -work work -93 -explicit ../../src/vhdl/hivek_pack.vhd
vcom -work work -93 -explicit ../../src/vhdl/alu.vhd
vcom -work work -93 -explicit ../../bench/alu_tb.vhd

vsim -t 1ns -lib work alu_tb

add wave -noupdate -format Logic -radix binary /alu_tb/alu_op
add wave -noupdate -format Logic -radix binary /alu_tb/cin
add wave -noupdate -format Literal -radix hexadecimal /alu_tb/op_a
add wave -noupdate -format Literal -radix hexadecimal /alu_tb/op_b
add wave -noupdate -format Literal -radix hexadecimal /alu_tb/res
add wave -noupdate -format Logic -radix binary /alu_tb/z_flag
add wave -noupdate -format Logic -radix binary /alu_tb/c_flag
add wave -noupdate -format Logic -radix binary /alu_tb/n_flag
add wave -noupdate -format Logic -radix binary /alu_tb/o_flag

view wave
run 1us
