# Makefile for SystemVerilog simulation

info:
	@echo "all      : Clean, Compile and Simulate the project."
	@echo "compile  : compile the project."
	@echo "simulate : simulate the project using ModelSim."
	@echo "           GUI=<1|0> 1: with GUI, 0: without GUI."
	@echo "clean    : clean work directory."


# UVM Related variables:
UVM_HOME	= $(HOME)/uvm-1.2
UVM_SRC		= $(HOME)/uvm-1.2/src
UVM_PKG		= $(UVM_SRC)/uvm_pkg.sv
DPI_SRC 	= $(UVM_HOME)/src/dpi/uvm_dpi.cc

# Directrories variables:
RTL_DIR 	= rtl
TB_DIR 		= tb
SIM_DIR 	= sim
WORK_DIR	= work

# Design files:
RTL_TOP 	= $(RTL_DIR)/design.sv
TB_TOP	 	= $(TB_DIR)/testbench.sv

# Simulation mode is defaulted without graphical user interface:
GUI ?= 0 

# Simulate with or without graphical user interface:
ifeq ($(GUI), 1) # Run with GUI:
	VSIM_MODE = -gui

else # Run without GUI; 
	VSIM_MODE = -c 
endif

.PHONY: info all compile simulate clean

all: clean compile simulate

compile: clean
	@echo "Compiling the design and testbench..."
	export QUESTA=1
	vlib $(WORK_DIR)
	vmap work $(WORK_DIR)
	vlog 	$(UVM_PKG) $(DPI_SRC) $(TB_TOP) \
			+acc -work $(WORK_DIR) \
			+incdir+$(UVM_SRC) \
			+incdir+$(RTL_DIR) \
			+incdir+$(TB_DIR)

simulate: clean compile
	@echo "Running Simulation..."
	vsim 	testbench \
			$(VSIM_MODE) \
			+UVM_TESTNAME=algn_test_reg_access \
			+UVM_MAX_QUIT_COUNT=1 \
			-do "set gui_mode $(GUI); \
			add wave -position insertpoint  \
				sim:/testbench/dut/clk \
				sim:/testbench/dut/reset_n \
				sim:/testbench/dut/psel \
				sim:/testbench/dut/penable \
				sim:/testbench/dut/paddr \
				sim:/testbench/dut/pwrite \
				sim:/testbench/dut/prdata \
				sim:/testbench/dut/pwdata \
				sim:/testbench/dut/pready \
				sim:/testbench/dut/pslverr ; \
			run -all;"

clean: 
	@echo "Cleaning work direcory..."
	rm -rf $(WORK_DIR) transcript vsim.wlf

