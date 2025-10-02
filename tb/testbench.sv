 /*
   Date    		: 1st of May, 2025
   Author  		: Abderrahim EL HAMZI.
   Project 		: UVM-course Personal Practice.  
   Description	: This Project is a part of UVM course practice (on Udemy), for which a DUT is already provided by the course instructor.
   File    		: TestBench of  DUT to be verified using UVM.
   
*/

// Macros for the supported features by the Simulator:
// `define RANDOMIZATION_SUPPORTED
// `define ASSERTIONS_SUPPORTED
// `define COVERAGE_SUPPORTED

`include "design.sv"
`include "algn_test_pkg.sv"

`timescale 1ns/1ps



module testbench();
      
  	import uvm_pkg::* ;
  	import algn_test_pkg::* ;
  
  	/* Local Parameters: */
  	localparam 	TB_FIFO_DEPTH = 8;
  
  	/* Signals Declaration: */
    
  	// Clock and Reset:
  	reg tb_clk ;
  	reg tb_resetn;
    	
    // Interrupt interface:
	reg tb_irq;
  
  
  	/* Instance of APB interface: */
  	apb_if apb_if_inst (.pclk(tb_clk));	 // It's a system-verilog static element, so we need to instantiate it tb not inside the agent.
	
	/* Instance of MD RX interface: */
	md_if#(`ALIGN_TEST_DATA_WIDTH) md_rx_if(.clk(clk)) ;
  	
	/* Instance of MD RX interface: */
	md_if#(`ALIGN_TEST_DATA_WIDTH) md_tx_if(.clk(clk)) ;

	/* Connecting reset signals */
  	assign md_rx_if.reset_n = apb_if_inst.presetn ;
  	assign md_tx_if.reset_n = apb_if_inst.presetn ;

    /* DUT (Data Aligner) Instantiation: */
    cfs_aligner 
  		#(.ALGN_DATA_WIDTH	(`ALIGN_TEST_DATA_WIDTH),
          .FIFO_DEPTH		(TB_FIFO_DEPTH) 
         )
  	dut(
        .clk			(tb_clk),
      	.reset_n		(apb_if_inst.presetn),
      	.paddr			(apb_if_inst.paddr),
      	.pwrite			(apb_if_inst.pwrite),
      	.psel			(apb_if_inst.psel),
      	.penable		(apb_if_inst.penable),
      	.pwdata			(apb_if_inst.pwdata),
      	.pready			(apb_if_inst.pready),
      	.prdata			(apb_if_inst.prdata),
      	.pslverr		(apb_if_inst.pslverr),

        .md_rx_valid	(md_rx_if.valid),
        .md_rx_data		(md_rx_if.data),
        .md_rx_offset	(md_rx_if.offset),
        .md_rx_size		(md_rx_if.size),
        .md_rx_ready	(md_rx_if.ready),
        .md_rx_err		(md_rx_if.err),
		
        .md_tx_valid	(md_tx_if.valid),
        .md_tx_data		(md_tx_if.data),
        .md_tx_offset	(md_tx_if.offset),
        .md_tx_size		(md_tx_if.size),
        .md_tx_ready	(md_tx_if.ready),
        .md_tx_err		(md_tx_if.err),
        .irq			(tb_irq)
    );


  
    /* Clock generator: */
    initial tb_clk = 0 ;
    always #10ns tb_clk = ~tb_clk; // clock persiod = 20 ns.


    /* Reset generator: */
    initial begin
        apb_if_inst.presetn = 1;
      	#3ns ;
        apb_if_inst.presetn = 0;
      	#30ns ;
        apb_if_inst.presetn = 1;
    end

  
  	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
		/* uvm_config_db#(T)::set(uvm_component cntxt, string inst_name, string field_name, T value)
		 	uvm_config_db: is a UVM calss.
			T	 		: is the type of data to be putted in the DataBase.
			Description : Create a new or update an existing configuration setting for field_name in inst_name from cntxt. The setting is made at cntxt. 
					If cntxt is null then inst_name provides the complete scope information of the setting. 
					field_name is the target field. Both inst_name and field_name may be glob style or regular expression style expressions.
							Examples: uvm_config_db#(int)::set(this, "env.apb_agent", "bus_width", 64) called in uvm_test.
									  (Key,value) are ("bus_width", 64) which are accessible by apb_agent instanciated inside env relative to uvm_test (this).
							Note	: - testbench is not a uvm_component => cntxt = null => full scope information should be provided by inst_name.
									  - inst_name can be env.* if we want all component under "env" to have access to ("bus_width", 64)
									  - If for the same key is putted in the db in multiple contexts but with different values (e.g set(this, "env.apb_agent", "bus_width", 64) and set(null, "base_test.env.apb_agent", "bus_width", 32) )
										+ Case-1: If get is called in Build Phase -> the returned value will be the one putted in db by the component that has the higher context (e.g testbench -> value=32).
										+ Case-2: If get is called in Run   Phase -> the returned value will be the putted in the db by the last putted one in db (e.g base_test -> 64).
										[Ref. UVM-CRM/page-199].
		*/				
		uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top.env.apb_agent_h", "vif", apb_if_inst); // Store in DB a pointer to the APB interface (virtual interface).
		
		uvm_config_db#(virtual md_if#(`ALIGN_TEST_DATA_WIDTH))::set(null, "uvm_test_top.env.md_rx_agent_h", "vif", md_rx_if); 

		uvm_config_db#(virtual md_if#(`ALIGN_TEST_DATA_WIDTH))::set(null, "uvm_test_top.env.md_tx_agent_h", "vif", md_tx_if); 

		
		run_test("");	// Test name will be passed using simulator arguments passing.

    end
  
endmodule




