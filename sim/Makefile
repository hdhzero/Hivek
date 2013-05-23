# project directories
# update project_dir to the folder where your files are
PROJECT_DIR = /home/hdhzero/projetos/Hivek

# do not modify below unless you know what you are doing
SRC_DIR     = $(PROJECT_DIR)/src
BENCH_DIR   = $(PROJECT_DIR)/bench
SIM_DIR     = $(PROJECT_DIR)/sim
WORK_DIR    = $(SIM_DIR)/work

# simulator used: modelsim or ghdl
sim         = modelsim
SIMULATOR   = $(sim)

TESTBENCH = none
RUNTIME = 100
FILES = none

# on the two ifeq below, update the paths for your modelsim
# and/or ghdl
# for modelsim wave visualization, use vcd2vliw
ifeq ("$(SIMULATOR)", "modelsim")
    MKLIB  = vlib
    MAP    = vmap WORK
    COM    = vcom -work $(WORK_DIR) -93 -explicit 
    SIM    = vsim -c
    COM_FLAGS =
    SIM0_FLAGS = -do "add list *; run $(RUNTIME); write list counter.lst ;quit -sim; quit" -wlf $(TESTBENCH).wlf 
#-do "vcd file $(TESTBENCH).vcd; vcd add /$(TESTBENCH)/*; run $(RUNTIME)ns; quit -sim; quit"
    SIM1_FLAGS = 
endif

ifeq ("$(SIMULATOR)", "ghdl")
    MKLIB  = mkdir 
    MAP    = echo work directory created at
    COM    = ghdl -a --workdir=$(WORK_DIR)
    SIM    = ghdl --elab-run
    COM_FLAGS =
    SIM0_FLAGS = --workdir=$(WORK_DIR)
    SIM1_FLAGS = --stop-time=$(RUNTIME)ns --wave=$(TESTBENCH).ghw
endif

define \n


endef

###############################
## File related stuff
## - files to be compiled
## - waves to be added
###############################


# barrel shifter related stuff
BARREL_SHIFTER_FILES = $(SRC_DIR)/vhdl/hivek_pkg.vhd \
    $(SRC_DIR)/vhdl/auxiliary/alu/barrel_shifter.vhd \
    $(BENCH_DIR)/auxiliary/alu/barrel_shifter_tb.vhd

BARREL_SHIFTER_TB = barrel_shifter_tb

barrel_shifter_tb: TESTBENCH = $(BARREL_SHIFTER_TB)
barrel_shifter_tb: RUNTIME   = 500
barrel_shifter_tb: FILES     = $(BARREL_SHIFTER_FILES)
barrel_shifter_tb:
	$(MKLIB) $(WORK_DIR)
	$(MAP) $(WORK_DIR)
	$(foreach file, $(FILES), $(COM) $(file); ${\n})
	$(SIM) $(SIM0_FLAGS) $(TESTBENCH) $(SIM1_FLAGS)

# alu
ALU_FILES = $(SRC_DIR)/vhdl/hivek_pkg.vhd \
    $(SRC_DIR)/vhdl/auxiliary/alu/alu.vhd \
    $(BENCH_DIR)/auxiliary/alu/alu_tb.vhd

ALU_TB = alu_tb

alu_tb: TESTBENCH = $(ALU_TB)
alu_tb: RUNTIME = 500
alu_tb: FILES = $(ALU_FILES)
alu_tb:
	$(MKLIB) $(WORK_DIR)
	$(MAP) $(WORK_DIR)
	$(foreach file, $(FILES), $(COM) $(file); ${\n})
	$(SIM) $(SIM0_FLAGS) $(TESTBENCH) $(SIM1_FLAGS)

# alu shifter
ALU_SHIFTER_FILES = $(SRC_DIR)/vhdl/hivek_pkg.vhd \
    $(SRC_DIR)/vhdl/auxiliary/alu/alu.vhd \
    $(SRC_DIR)/vhdl/auxiliary/alu/barrel_shifter.vhd \
    $(SRC_DIR)/vhdl/auxiliary/alu/alu_shifter.vhd \
    $(BENCH_DIR)/auxiliary/alu/alu_shifter_tb.vhd

ALU_SHIFTER_TB = alu_shifter_tb

alu_shifter_tb: TESTBENCH = $(ALU_SHIFTER_TB)
alu_shifter_tb: RUNTIME = 500
alu_shifter_tb: FILES = $(ALU_SHIFTER_FILES)
alu_shifter_tb:
	$(MKLIB) $(WORK_DIR)
	$(MAP) $(WORK_DIR)
	$(foreach file, $(FILES), $(COM) $(file); ${\n})
	$(SIM) $(SIM0_FLAGS) $(TESTBENCH) $(SIM1_FLAGS)
  
# predicate_bank
PREDICATE_BANK_FILES = $(SRC_DIR)/vhdl/hivek_pkg.vhd \
    $(SRC_DIR)/vhdl/auxiliary/predicate_bank/predicate_bank.vhd \
    $(BENCH_DIR)/auxiliary/predicate_bank/predicate_bank_tb.vhd

PREDICATE_BANK_TB = predicate_bank_tb

predicate_bank_tb: TESTBENCH = $(PREDICATE_BANK_TB)
predicate_bank_tb: RUNTIME = 500
predicate_bank_tb: FILES = $(PREDICATE_BANK_FILES)
predicate_bank_tb:
	$(MKLIB) $(WORK_DIR)
	$(MAP) $(WORK_DIR)
	$(foreach file, $(FILES), $(COM) $(file); ${\n})
	$(SIM) $(SIM0_FLAGS) $(TESTBENCH) $(SIM1_FLAGS)


# register bank
REGISTER_BANK_FILES = $(SRC_DIR)/vhdl/hivek_pkg.vhd \
    $(SRC_DIR)/vhdl/auxiliary/register_bank/bank_selector.vhd \
    $(SRC_DIR)/vhdl/auxiliary/register_bank/reg_bram.vhd \
    $(SRC_DIR)/vhdl/auxiliary/register_bank/reg_block.vhd \
    $(SRC_DIR)/vhdl/auxiliary/register_bank/register_bank.vhd \
    $(BENCH_DIR)/auxiliary/register_bank/register_bank_tb.vhd

    #$(SRC_DIR)/vhdl/auxiliary/register_bank/reg_bram_altera.vhd 
REGISTER_BANK_TB = register_bank_tb

register_bank_tb: TESTBENCH = $(REGISTER_BANK_TB)
register_bank_tb: RUNTIME   = 500
register_bank_tb: FILES     = $(REGISTER_BANK_FILES)
register_bank_tb:
	$(MKLIB) $(WORK_DIR)
	$(MAP) $(WORK_DIR)
	$(foreach file, $(FILES), $(COM) $(file); ${\n})
	$(SIM) $(SIM0_FLAGS) $(TESTBENCH) $(SIM1_FLAGS)


########################
## hivek_tb
########################

HIVEK_TOP_FILES = $(SRC_DIR)/vhdl/hivek_pkg.vhd \
    $(SRC_DIR)/vhdl/memory/memory_bram.vhd \
    $(SRC_DIR)/vhdl/memory/dual_memory_bram.vhd \
    $(SRC_DIR)/vhdl/memory/icache_memory.vhd \
    $(SRC_DIR)/vhdl/memory/dcache_memory.vhd \
    $(SRC_DIR)/vhdl/memory/icache_selector.vhd \
    $(SRC_DIR)/vhdl/memory/dcache_selector.vhd \
    $(SRC_DIR)/vhdl/auxiliary/register_bank/bank_selector.vhd \
    $(SRC_DIR)/vhdl/auxiliary/register_bank/reg_bram.vhd \
    $(SRC_DIR)/vhdl/auxiliary/register_bank/reg_block.vhd \
    $(SRC_DIR)/vhdl/auxiliary/register_bank/register_bank.vhd \
	$(SRC_DIR)/vhdl/auxiliary/operation_decoder/operation_decoder.vhd \
    $(SRC_DIR)/vhdl/stages/instruction_fetch_stage.vhd \
    $(SRC_DIR)/vhdl/stages/instruction_expansion_stage.vhd \
    $(SRC_DIR)/vhdl/stages/instruction_decode_stage.vhd \
    $(SRC_DIR)/vhdl/stages/instruction_decode2_stage.vhd \
    $(SRC_DIR)/vhdl/stages/execution_stage.vhd \
    $(SRC_DIR)/vhdl/stages/execution2_stage.vhd \
    $(SRC_DIR)/vhdl/stages/writeback_stage.vhd \
    $(SRC_DIR)/vhdl/pipeline/pipeline.vhd \
    $(SRC_DIR)/vhdl/hivek.vhd \
    $(BENCH_DIR)/hivek_tb.vhd

HIVEK_TOP_TB = hivek_tb

hivek_tb: TESTBENCH = $(HIVEK_TOP_TB)
hivek_tb: RUNTIME = 500
hivek_tb: FILES = $(HIVEK_TOP_FILES)
hivek_tb:
	$(MKLIB) $(WORK_DIR)
	$(MAP) $(WORK_DIR)
	$(foreach file, $(FILES), $(COM) $(file); ${\n})
	$(SIM) $(SIM0_FLAGS) $(TESTBENCH) $(SIM1_FLAGS)

TESTBENCHS = $(BARREL_SHIFTER_TB) $(ALU_TB) $(ALU_SHIFTER_TB) $(REGISTER_BANK_TB) \
    $(PREDICATE_BANK_TB) $(HIVEK_TOP_TB)

clean:
	rm -rf *.ini
	rm -rf $(WORK_DIR)
	rm -rf *.wlf
	rm -rf *.vcd
	rm -rf *.ghw
	rm -rf transcript
	rm -rf *.o
	rm -rf *.cf
	rm -rf $(TESTBENCHS)
