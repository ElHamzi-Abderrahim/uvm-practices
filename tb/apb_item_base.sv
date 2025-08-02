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
    
    virtual function string convert2string() ;
        string result = $sformatf("dir: %0s, addr: %0x", dir.name(), address) ;
        
        if(dir == APB_WRITE)begin
            result = $sformatf("%0s, data: %0x", result, data) ;
        end
        
        return result ;
    endfunction : convert2string
  
endclass : apb_item_base

`endif