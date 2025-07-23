`ifndef APB_ITEM_BASE_SV
`define APB_ITEM_BASE_SV

class apb_item_base extends uvm_sequence_item;
  
    `uvm_object_utils(apb_item_base)

    // rand apb_dir dir ;
    apb_dir dir ;

    apb_addr address ;

    apb_data data ;

    function new(string name="apb_item_base");
        super.new(name);
    endfunction
  
endclass : apb_item_base

`endif