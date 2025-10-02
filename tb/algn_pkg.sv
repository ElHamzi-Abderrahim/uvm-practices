`ifndef ALGN_PKG_SV
`define ALGN_PKG_SV

	`include "uvm_macros.svh"
	`include "apb_pkg.sv"
    `include "md_pkg.sv"
    package algn_pkg;
        import uvm_pkg::* ;
		import apb_pkg::* ;
        import md_pkg::* ;
        `include "algn_env.sv"
		
    endpackage

`endif // `ifndef ALGN_PKG_SV
