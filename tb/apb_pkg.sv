`ifndef APB_PKG_SV
	`define APB_PKG_SV

	`include "uvm_macros.svh"
	`include "apb_if.sv"

	package apb_pkg;
		import uvm_pkg::* ;
		`include "apb_types.sv"
		`include "apb_agent_config.sv"
		`include "apb_agent.sv"
		`include "apb_item_base.sv"
		`include "apb_item_drive.sv"
	
	endpackage 



`endif

