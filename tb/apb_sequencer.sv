`ifndef APB_SEQUENCER_SV
`define APB_SEQUENCER_SV

class apb_sequencer extends uvm_sequencer #(.REQ(apb_item_drive));
    
    `uvm_component_utils(apb_sequencer)

    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction : new
  

endclass : apb_sequencer

`endif
