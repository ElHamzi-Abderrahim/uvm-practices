`ifndef MD_ITEM_BASE_SV
`define MD_ITEM_BASE_SV

class md_item_base extends uvm_sequence_item;
    
    `uvm_object_utils(md_item_base)

    function new(string name="" );
        super.new(name) ;
    endfunction : new

endclass : md_item_base

`endif