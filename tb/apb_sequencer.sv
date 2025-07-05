`ifndef APB_SEQUENCER
`define APB_SEQUENCER

class apb_sequencer extends uvm_sequencer #(.REQ(apb_item_drive));
    
    `uvm_component_utils(apb_sequencer)

    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction : new
  

endclass : apb_sequencer

`endif
