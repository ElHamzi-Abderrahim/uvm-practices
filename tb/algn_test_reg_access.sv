
`ifndef ALGN_TEST_REG_ACCESS_SV
	`define ALGN_TEST_REG_ACCESS_SV

class algn_test_reg_access extends algn_test_base;
  
  	`uvm_component_utils(algn_test_reg_access)
  
	function new(string name = "algn_test_reg_access", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new
  
	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this, "TEST_DONE");
		`uvm_info("DUBUG", "Start of test", UVM_LOW)
		
		#100; 
		fork
			begin
				apb_sequence_simple apb_seq_simple = apb_sequence_simple::type_id::create("apb_seq_simple") ;
				apb_seq_simple.randomize_user() ;
				apb_seq_simple.item_drive.address = 'h0 ;
				apb_seq_simple.item_drive.dir     = APB_WRITE ;
				apb_seq_simple.item_drive.data    = 'h11 ;
				apb_seq_simple.start(env.apb_agent_h.apb_sequencer_h) ;
			end

			begin
				apb_sequence_rw apb_seq_rw = apb_sequence_rw::type_id::create("apb_seq_rw") ;
				apb_seq_rw.randomize_user();
				apb_seq_rw.addr = 'hc ;
				apb_seq_rw.start(env.apb_agent_h.apb_sequencer_h) ;
			end

			begin
				apb_sequence_random apb_seq_rnd = apb_sequence_random::type_id::create("apb_seq_rnd") ;
				apb_seq_rnd.randomize_user();
				apb_seq_rnd.num_item = 5 ;
				apb_seq_rnd.start(env.apb_agent_h.apb_sequencer_h) ;
			end
		join

		for(int i=0; i<10; i++) begin
			apb_item_drive item_drive = apb_item_drive::type_id::create("item_drive") ;
			item_drive.randomize_user();
			// `uvm_info("DEBUG", $sformatf("[%0d] item: %0s", i, item_drive.convert2string()), "UVM_LOW")
			$display("[DEBUG] %0s ", $sformatf("[%0d] item: %0s", i, item_drive.convert2string()));
		end

		`uvm_info("DUBUG", "End of test", UVM_LOW)

		phase.drop_objection(this, "TEST_DONE");
	endtask : run_phase

  
endclass : algn_test_reg_access

`endif