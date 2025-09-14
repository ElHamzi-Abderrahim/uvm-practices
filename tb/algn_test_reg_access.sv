
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

		#(100ns); 
		fork
			begin
				apb_vif vif = env.apb_agent_h.agent_config.get_vif();

				repeat (5) begin
					@(posedge vif.psel);
				end

				#(10ns) ;

				vif.presetn <= 0 ;

				repeat(4) begin
					@(posedge vif.pclk) ;
				end

				vif.presetn <= 1 ;
			end

			begin
				apb_sequence_simple apb_seq_simple = apb_sequence_simple::type_id::create("apb_seq_simple") ;

`ifndef RANDOMIZATION_SUPPORTED
				apb_seq_simple.randomize_user() ;
				apb_seq_simple.item_drive.address = 'h0 ;
				apb_seq_simple.item_drive.dir     = APB_WRITE ;
				apb_seq_simple.item_drive.data    = 'h11 ;
`endif // `ifndef RANDOMIZATION_SUPPORTED      

`ifdef RANDOMIZATION_SUPPORTED
				void'(apb_seq_simple.randomize() with {
					item_drive.address == 'h0;
					item_drive.dir  == APB_WRITE;
					item_drive.data == 'h0011;
				});
`endif // `ifdef RANDOMIZATION_SUPPORTED                
				apb_seq_simple.start(env.apb_agent_h.apb_sequencer_h) ;
			end

			begin
				apb_sequence_rw apb_seq_rw = apb_sequence_rw::type_id::create("apb_seq_rw") ;

`ifndef RANDOMIZATION_SUPPORTED
				apb_seq_rw.randomize_user();
				apb_seq_rw.addr = 'hc ;
`endif // `ifndef RANDOMIZATION_SUPPORTED    

`ifdef RANDOMIZATION_SUPPORTED		
				void'(apb_seq_rw.randomize() with {
					addr == 'hC;
				});
`endif // `ifdef RANDOMIZATION_SUPPORTED                				
				apb_seq_rw.start(env.apb_agent_h.apb_sequencer_h) ;
			end


			begin
				apb_sequence_random apb_seq_rnd = apb_sequence_random::type_id::create("apb_seq_rnd") ;
`ifndef RANDOMIZATION_SUPPORTED
				apb_seq_rnd.randomize_user();
				apb_seq_rnd.num_items = 5 ;
`endif // `ifndef RANDOMIZATION_SUPPORTED    
`ifdef RANDOMIZATION_SUPPORTED		
				 void'(apb_seq_rnd.randomize() with {
					num_items == 5;
				});
`endif // `ifdef RANDOMIZATION_SUPPORTED        

				apb_seq_rnd.start(env.apb_agent_h.apb_sequencer_h) ;
			end

		join // END OF FORK STATEMENT

		begin
			apb_sequence_random apb_seq_rnd = apb_sequence_random::type_id::create("apb_seq_rnd") ;
`ifndef RANDOMIZATION_SUPPORTED
			apb_seq_rnd.randomize_user();
`endif // `ifndef RANDOMIZATION_SUPPORTED    
			apb_seq_rnd.num_items = 5 ;
			apb_seq_rnd.start(env.apb_agent_h.apb_sequencer_h) ;
		end 

		#(100ns) ;

		`uvm_info("DUBUG", "End of test", UVM_LOW)

		phase.drop_objection(this, "TEST_DONE");
	endtask : run_phase

  
endclass : algn_test_reg_access

`endif // `ifndef ALGN_TEST_REG_ACCESS_SV