`ifndef MD_ITEM_DRV_MASTER_SV
`define MD_ITEM_DRV_MASTER_SV

class md_item_drv_master extends md_item_drv;
    
    `uvm_object_utils(md_item_drv_master)

    `ifndef RANDOMIZATION_SUPPORTED
    // Pre Drive delay
    int unsigned pre_drive_delay ;
    
    // Post Drive delay
    int unsigned post_drive_delay ;

    // Data driven by the Master
    bit[7:0] data[$] ;

    // Offset of the driven Data
    int unsigned offset ;
    `endif // `ifndef RANDOMIZATION_SUPPORTED


    `ifdef RANDOMIZATION_SUPPORTED
    rand int unsigned pre_drive_delay ;
    rand int unsigned post_drive_delay ;
    rand bit[7:0] data[$] ;
    rand int unsigned offset ;
    `endif // `ifdef RANDOMIZATION_SUPPORTED

    `ifdef RANDOMIZATION_SUPPORTED
    rand int unsigned pre_drive_delay ;
    rand int unsigned post_drive_delay ;

    constraint pre_drive_delay_default {
        soft pre_drive_delay <= 5 ;
    }
    
    constraint post_drive_delay_default {
        soft post_drive_delay <= 5 ;
    }

    constraint data_default {
        soft data.size() == 1 ;
    }

    constraint data_hard {
        data.size > 1 ;
    }

    constraint offset_default {
        soft offset == 1 ;
    }
    `endif // `ifdef RANDOMIZATION_SUPPORTED

    `ifndef RANDOMIZATION_SUPPORTED
    local int unsigned size_d; 
    local bit [7:0] data_rnd; 
    local int i ; 

    virtual function void randomize_user();
        this.offset           = 1 ; 
        this.pre_drive_delay  = $urandom_range(0, 5) ; 
        this.post_drive_delay = $urandom_range(0, 5) ; 

        // Randomize the size of data to mimic "data.size > 1 ;"
        size_d  = $urandom_range(1, 20) ;
        
        $display("ITEM DRIVE: Randomized data size : %0d", size_d) ;
        $display("ITEM DRIVE: Randomized offset    : %0d", offset) ;

        // Randomize each byte of the data queue
        for(i =0; i<size_d; i++) begin
            data_rnd = $urandom() ;
            data.push_front(data_rnd) ;
        end // for
        
        $display("ITEM DRIVE: Randomized data    : %p", data) ;

    endfunction : randomize_user
    
    `endif // `ifndef RANDOMIZATION_SUPPORTED    



    function new(string name="" );
        super.new(name) ;
    endfunction : new

    virtual function string convert2string();
        string data_as_string = "{" ;
        
        foreach(data[idx]) begin
            data_as_string = $sformatf("%0s'h%02x%0s", data_as_string, data[idx], idx == data.size()-1 ? "" : ", ") ;
        end

        data_as_string = $sformatf("%0s }", data_as_string) ;
        
        return $sformatf("data: %0s, offset: %0d, pre_drive_delay: %0d, post_drive_delay: %0d", data_as_string, offset, pre_drive_delay, post_drive_delay) ;
    endfunction : convert2string

endclass : md_item_drv_master

`endif