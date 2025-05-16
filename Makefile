# Makefile for SystemVerilog simulation

info:
	@echo "all      : Clean, Compile and Simulate the project."
	@echo "compile  : compile the project."
	@echo "simulate : simulate the project using ModelSim."
	@echo "           GUI=<1|0> 1: with GUI, 0: without GUI."
	@echo "clean    : clean work directory."


# UVM Related variables:
UVM_HOME	= /home/osboxes/uvm-1.2
UVM_SRC		= /home/osboxes/uvm-1.2/src
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

compile: 
	@echo "Compiling the design and testbench..."
	export QUESTA=1
	vlib $(WORK_DIR)
	vmap work $(WORK_DIR)
	vlog 	$(UVM_PKG) $(DPI_SRC) $(TB_TOP) \
			+acc -work $(WORK_DIR) \
			+incdir+$(UVM_SRC) \
			+incdir+$(RTL_DIR) \
			+incdir+$(TB_DIR)

simulate: 
	@echo "Running Simulation..."
	vsim 	testbench \
			$(VSIM_MODE) \
			+UVM_TESTNAME=algn_test_reg_access \
			-do "set gui_mode $(GUI); run -all;"

clean: 
	@echo "Cleaning work direcory..."
	rm -rf $(WORK_DIR) transcript vsim.wlf

