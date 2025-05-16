
`ifndef ALGN_TEST_REG_ACCESS_SV
`define ALGN_TEST_REG_ACCESS_SV

class algn_test_reg_access extends algn_test_base;
  
  `uvm_component_utils(algn_test_reg_access)
  
  function new(string name = "algn_test_reg_access", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  
endclass

`endif