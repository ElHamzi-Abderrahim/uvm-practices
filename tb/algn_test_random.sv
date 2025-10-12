`ifndef ALGN_TEST_RANDOM_SV
`define ALGN_TEST_RANDOM_SV

class algn_test_random extends algn_test_base;
  
  	`uvm_component_utils(algn_test_random)
  
	function new(string name = "", uvm_component parent);
		super.new(name, parent);
	endfunction : new
  
	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this, "TEST_DONE");
		`uvm_info("DUBUG", "Start of test", UVM_LOW)

		#(100ns); 
		
		repeat(4) begin
			md_sequence_simple_master seq_simple = md_sequence_simple_master::type_id::create("seq_simple") ;
    
            seq_simple.set_sequencer(env.md_agent_rx.sequencer) ;

			$display("Trying to randomize the item... \n") ;

            `ifndef RANDOMIZATION_SUPPORTED
			seq_simple.randomize_user();
			`endif // `ifndef RANDOMIZATION_SUPPORTED    
            
            `ifdef RANDOMIZATION_SUPPORTED
            void'(seq_simple.randomize()) ;
            `endif // `ifdef RANDOMIZATION_SUPPORTED

			$display("After randomizing the item... \n") ;
			seq_simple.start(env.md_agent_rx.sequencer) ;
		end 

		#(100ns) ;

		`uvm_info("DUBUG", "End of test", UVM_LOW)

		phase.drop_objection(this, "TEST_DONE");
	endtask : run_phase

  
endclass : algn_test_random


`endif