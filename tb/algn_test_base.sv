`ifndef ALGN_TEST_BASE_SV
`define ALGN_TEST_BASE_SV

class algn_test_base extends uvm_test;
  `uvm_component_utils(algn_test_base)
	
  algn_env env ;
  
  function new (string name="algn_test_base", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = algn_env::type_id::create("env", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this, "TEST DONE");
    `uvm_info("DUBUG", "Start of test", UVM_LOW)
    
    #100; 
    
    `uvm_info("DUBUG", "End of test", UVM_LOW)

    phase.drop_objection(this, "TEST_DONE");
  endtask
  
endclass

`endif

