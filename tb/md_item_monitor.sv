`ifndef MD_ITEM_MONITOR_SV
`define MD_ITEM_MONITOR_SV

class md_item_monitor extends md_item_base;
    
    `uvm_object_utils(md_item_monitor)

    // Delay between current transaction and the previous one
    int unsigned prev_item_delay ;
    
    // Length of the current transaction (in cycles)
    int unsigned length ;

    // Data of the current transaction
    bit[7:0] data[$] ;

    // Offset of the data
    int unsigned offset ;

    // Transaction response
    md_response response ;


    function new(string name="" );
        super.new(name) ;
    endfunction : new


    virtual function string convert2string();
        string data_as_string = "{" ;
        
        foreach(data[idx]) begin
            data_as_string = $sformatf("%0s'h%02x%0s", data_as_string, data[idx], idx == data.size()-1 ? "" : ", ") ;
        end

        data_as_string = $sformatf("%0s }", data_as_string) ;

        return $sformatf("[%0t..%0s] data: %0s, offset: %0d, response: %0s, length: %0d, prev_item_delay: %0d",
                          get_begin_time(),
                          is_active() ? "" : $sformatf("%0t", get_end_time()),
                          data_as_string, offset, response.name(), length, prev_item_delay
                        ) ;

    endfunction: convert2string        


endclass : md_item_monitor

`endif