
`ifndef ALGN_TEST_REG_ACCESS_SV
`define ALGN_TEST_REG_ACCESS_SV

class algn_test_reg_access extends algn_test_base;
  
  `uvm_component_utils(algn_test_reg_access)
  
  function new(string name = "algn_test_reg_access", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this, "TEST_DONE");
    `uvm_info("DUBUG", "Start of test", UVM_LOW)
    
    #100; 

    for(int i=0; i<10; i++)begin
      apb_item_drive item_drive = apb_item_drive::type_id::create("item_drive") ;
      item_drive.randomize_manually();
      
      // `uvm_info("DEBUG", $sformatf("[%0d] item: %0s", i, item_drive.convert2string()), "UVM_LOW")
      $display("[DEBUG] %0s ", $sformatf("[%0d] item: %0s", i, item_drive.convert2string()));
    end

    `uvm_info("DUBUG", "End of test", UVM_LOW)

    phase.drop_objection(this, "TEST_DONE");
  endtask

  
endclass

`endif