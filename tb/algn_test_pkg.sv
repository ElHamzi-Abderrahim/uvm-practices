`ifndef ALGN_TEST_PKG_SV
`define ALGN_TEST_PKG_SV

	`include "uvm_macros.svh"
	`include "algn_pkg.sv"

    package algn_test_pkg;
        import uvm_pkg::* ;
        import algn_pkg::*;
        import apb_pkg::* ;

		`include "algn_test_base.sv"
        `include "algn_test_reg_access.sv"
    endpackage

`endif // `ifndef ALGN_TEST_PKG_SV
