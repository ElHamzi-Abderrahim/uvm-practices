`ifndef APB_ITEM_BASE_SV
`define APB_ITEM_BASE_SV

class apb_item_base extends uvm_sequence_item;
  
    `uvm_object_utils(apb_item_base)

`ifndef RANDOMIZATION_SUPPORTED
    // Direction of access from/to APB Slave
    apb_dir dir ; // APB_READ or APB_WRITE enum
    // Address to Read/Write from/to the APB Slave
    apb_addr address ;
    // DATA to Read/Write from/to the APB Slave
    apb_data data ;
`endif // `ifndef RANDOMIZATION_SUPPORTED

`ifdef RANDOMIZATION_SUPPORTED
    rand apb_dir dir ;
    rand apb_addr address ;
    rand apb_data data ;
`endif // `ifdef RANDOMIZATION_SUPPORTED


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

`endif // `ifndef APB_ITEM_BASE_SV
