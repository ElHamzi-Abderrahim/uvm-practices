`ifndef APB_ITEM_MONITOR_SV
`define APB_ITEM_MONITOR_SV

class apb_item_monitor extends apb_item_base;
  
    `uvm_object_utils(apb_item_monitor)

    apb_response    response ;
    int unsigned    prev_item_delay ;
    int unsigned    length ;

    function new(string name="apb_item_monitor");
        super.new(name);
    endfunction : new

    virtual function string convert2string() ;
        string result = super.convert2string() ;

        result = $sformatf("%0s, response: %0s, length: %0d, prev_item_delay: %0d.", 
                            result, response.name(),  length , prev_item_delay) ;

        return result ;
    endfunction : convert2string
  

endclass : apb_item_monitor

`endif