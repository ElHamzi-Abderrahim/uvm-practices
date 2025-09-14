`ifndef APB_ITEM_DRIVE_SV
`define APB_ITEM_DRIVE_SV

class apb_item_drive extends apb_item_base;
  
    `uvm_object_utils(apb_item_drive)


    `ifndef RANDOMIZATION_SUPPORTED
    // Pre drive delay 
    int unsigned pre_drive_delay ;
    // Post drive delay
    int unsigned post_drive_delay ;
    `endif // `ifndef RANDOMIZATION_SUPPORTED

    `ifdef RANDOMIZATION_SUPPORTED
    rand int unsigned pre_drive_delay ;
    rand int unsigned post_drive_delay ;

    constraint pre_drive_delay_default {
        soft pre_drive_delay <= 5 ;
    }
    
    constraint post_drive_delay_default {
        soft post_drive_delay <= 5 ;
    }
    `endif // `ifdef RANDOMIZATION_SUPPORTED



    function new(string name="apb_item_drive");
        super.new(name);
    endfunction : new
  


    `ifndef RANDOMIZATION_SUPPORTED
    // Alternative solution for randomizing object fields, due to the need of license for 
    // randomization features in the free version of modelsim.
    virtual function void randomize_user();
        this.dir                 = apb_dir'($urandom_range(0, 1)) ; // apb_addr'(value): to caste the width of the value to width of apb_dir.
        this.address             = apb_addr'($urandom()) ; 
        this.data                = apb_data'($urandom()) ; 
        this.pre_drive_delay     = $urandom_range(0, 5) ; 
        this.post_drive_delay    = $urandom_range(0, 5) ; 
        // $display("dir: %0x, address: %0x, data: %0x, pre_dr_delay: %0x, post_dr_delay: %0x", this.dir, this.address, this.data, this.pre_drive_delay, this.post_drive_delay);
    endfunction : randomize_user
    `endif // `ifndef RANDOMIZATION_SUPPORTED    
    


    virtual function string convert2string() ;
        string result = super.convert2string() ;

        result = $sformatf("%0s, pre_drive_delay: %0d, post_drive_delay: %0d", 
                            result, pre_drive_delay, post_drive_delay) ;

        return result ;
    endfunction : convert2string

endclass

`endif // `ifndef APB_ITEM_DRIVE_SV