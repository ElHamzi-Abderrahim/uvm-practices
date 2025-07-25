`ifndef APB_SEQUENCE_BASE
    `define APB_SEQUENCE_BASE

class apb_sequence_base extends uvm_sequence #(.REQ(apb_item_drive));
  
    `uvm_declare_p_sequencer(apb_sequencer)
    `uvm_object_utils(apb_sequence_base)

    function new(string name="");
        super.new(name);
    endfunction : new
  
 	

endclass : apb_sequence_base

`endif
