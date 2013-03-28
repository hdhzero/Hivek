vlib work
vmap work

vcom -work work -93 -explicit ../../src/vhdl/hivek_pack.vhd
vcom -work work -93 -explicit ../../src/vhdl/alu.vhd
vcom -work work -93 -explicit ../../src/vhdl/verify_flags.vhd
vcom -work work -93 -explicit ../../src/vhdl/execution_stage.vhd
vcom -work work -93 -explicit ../../bench/execution_stage_tb.vhd

vsim -t 1ns -lib work execution_stage_tb

add wave -noupdate -format Logic -radix binary /execution_stage_tb/clock
add wave -noupdate -format Logic -radix binary /execution_stage_tb/reset
add wave -noupdate -format Literal -radix hexadecimal /execution_stage_tb/sh_ex
add wave -noupdate -format Literal -radix hexadecimal /execution_stage_tb/ex_mem

add wave -noupdate -format Logic -radix binary /execution_stage_tb/execution_stage_u/rz

add wave -noupdate -format Logic -radix binary /execution_stage_tb/execution_stage_u/rn

add wave -noupdate -format Logic -radix binary /execution_stage_tb/execution_stage_u/rc

add wave -noupdate -format Logic -radix binary /execution_stage_tb/execution_stage_u/ro

view wave
run 1us
