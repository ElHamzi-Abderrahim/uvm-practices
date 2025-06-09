`ifndef APB_ITEM_DRIVE_SV
`define APB_ITEM_DRIVE_SV

class apb_item_drive extends apb_item_base;
  
    `uvm_object_utils(apb_item_drive)

    // rand apb_dir dir ;
    apb_dir dir ;

    apb_addr address ;

    apb_data data ;

    int unsigned pre_drive_delay ;

    int unsigned post_drive_delay ;

    // Randomizing the fields:



    constraint pre_drive_delay_default {
        soft pre_drive_delay <= 5 ;
    }
    
    constraint post_drive_delay_default {
        soft post_drive_delay <= 5 ;
    }

    function new(string name="apb_item_drive");
        super.new(name);
    endfunction
  
    // Alternative solution for randomizing object fields, due to the need of license for 
    // randomization features in the free version of modelsim.
    virtual function void randomize_manually();
        this.dir                 = apb_dir'($urandom_range(0, 1)) ; 
        this.address             = apb_addr'($urandom()) ; 
        this.data                = apb_data'($urandom()) ; 
        this.pre_drive_delay     = $urandom_range(0, 5) ; 
        this.post_drive_delay    = $urandom_range(0, 5) ; 
        // $display("dir: %0x, address: %0x, data: %0x, pre_dr_delay: %0x, post_dr_delay: %0x", this.dir, this.address, this.data, this.pre_drive_delay, this.post_drive_delay);
    endfunction
    
    
    virtual function string convert2string() ;
        string result = $sformatf("dir: %0s, addr: %0x", dir.name(), address) ;

        if(dir == APB_WRITE)begin
            result = $sformatf("%0s, data: %0x", result, data) ;
        end

        result = $sformatf("%0s, pre_drive_delay: %0d, post_drive_delay: %0d", 
                            result, pre_drive_delay, post_drive_delay) ;

        // $display("inside string result: %s", result) ;
        return result ;
    endfunction

endclass

`endif