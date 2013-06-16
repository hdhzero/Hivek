sim:
	ghdl -i ../src/vhdl/stages/writeback_stage.vhd
	ghdl -i ../src/vhdl/stages/instruction_fetch_stage.vhd
	ghdl -i ../src/vhdl/stages/instruction_expansion_stage.vhd
	ghdl -i ../src/vhdl/stages/instruction_decode_stage.vhd
	ghdl -i ../src/vhdl/stages/instruction_decode2_stage.vhd
	ghdl -i ../src/vhdl/stages/execution_stage.vhd
	ghdl -i ../src/vhdl/stages/execution2_stage.vhd
	ghdl -i ../src/vhdl/pipeline/pipeline.vhd
	ghdl -i ../src/vhdl/memory/memory_bram.vhd
	ghdl -i ../src/vhdl/memory/icache_selector.vhd
	ghdl -i ../src/vhdl/memory/icache_memory.vhd
	ghdl -i ../src/vhdl/memory/dual_memory_bram.vhd
	ghdl -i ../src/vhdl/memory/dcache_selector.vhd
	ghdl -i ../src/vhdl/memory/dcache_memory.vhd
	ghdl -i ../src/vhdl/auxiliary/register_bank/register_bank.vhd
	ghdl -i ../src/vhdl/auxiliary/register_bank/reg_bram.vhd
	ghdl -i ../src/vhdl/auxiliary/register_bank/reg_block.vhd
	ghdl -i ../src/vhdl/auxiliary/register_bank/bank_selector.vhd
	ghdl -i ../src/vhdl/auxiliary/predicate_bank/predicate_bank.vhd
	ghdl -i ../src/vhdl/auxiliary/operation_expander/operation_expander.vhd
	ghdl -i ../src/vhdl/auxiliary/operation_decoder/operation_decoder.vhd
	ghdl -i ../src/vhdl/auxiliary/alu/barrel_shifter.vhd
	ghdl -i ../src/vhdl/auxiliary/alu/alu_shifter.vhd
	ghdl -i ../src/vhdl/auxiliary/alu/alu.vhd
	ghdl -i ../src/vhdl/hivek_pkg.vhd
	ghdl -i ../src/vhdl/hivek.vhd
	ghdl -i vga_ram_address_decoder.vhd
	ghdl -i vga_control.vhd
	ghdl -i hivek_board.vhd
	ghdl -i hivek_board_tb.vhd
	ghdl -i button_handler.vhd
	ghdl -m hivek_board_tb

bench:
	ghdl -r hivek_board_tb --stop-time=7000ns --wave=hivek_board_tb.ghw


clean:
	rm -rf *.o *.cf *.ghw
