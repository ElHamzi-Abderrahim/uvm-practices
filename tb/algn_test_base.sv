`ifndef ALGN_TEST_BASE_SV
`define ALGN_TEST_BASE_SV

class algn_test_base extends uvm_test;
  `uvm_component_utils(algn_test_base)
	
  algn_env env ;
  
  function new (string name="algn_test_base", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = algn_env::type_id::create("env", this);
  endfunction : build_phase
  
  
  
endclass : algn_test_base

`endif

