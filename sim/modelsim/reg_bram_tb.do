vlib work
vmap work

vcom -work work -93 -explicit ../../src/vhdl/hivek_pack.vhd
vcom -work work -93 -explicit ../../src/vhdl/auxiliary/reg_bram_altera.vhd
vcom -work work -93 -explicit ../../src/vhdl/auxiliary/reg_bram.vhd
vcom -work work -93 -explicit ../../bench/reg_bram_tb.vhd

vsim -t 1ns -lib work reg_bram_tb

add wave -noupdate -format Logic -radix binary /reg_bram_tb/clock
add wave -noupdate -format Logic -radix binary /reg_bram_tb/wren
add wave -noupdate -format Literal -radix binary /reg_bram_tb/wraddr
add wave -noupdate -format Literal -radix binary /reg_bram_tb/rdaddr
add wave -noupdate -format Literal -radix hexadecimal /reg_bram_tb/din
add wave -noupdate -format Literal -radix hexadecimal /reg_bram_tb/dout

view wave
run 500ns
