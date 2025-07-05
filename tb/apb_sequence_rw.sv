`ifndef APB_SEQUENCE_RW
    `define APB_SEQUENCE_RW

class apb_sequence_rw extends apb_sequence_base;
  
    `uvm_object_utils(apb_sequence_rw)
    
    apb_item_drive item_drive ; // to be replaced with : rand apb_item_drive item_drive;
    apb_addr addr ;             // to be replaced with : rand apb_addr addr;
    apb_data rw_data ;          // to be replaced with : rand apb_data rw_data;
    
    function new(string name="");
        super.new(name);
        item_drive = apb_item_drive::type_id::create("item_drive") ;
    endfunction : new

    // Randomize the item using the user defined randomize method:
    virtual function void randomize_user();
        // Randomize the item when randomizing the sequence:
        item_drive.randomize_user();
        // Randomize sequence fields:
        this.addr             = apb_addr'($urandom()) ; 
        this.rw_data          = apb_data'($urandom()) ;
    endfunction : randomize_user 

    task body();
        // Overwrite the randomized fields to be constrained:
        item_drive.dir        = APB_READ ;
        item_drive.address    = this.addr ;
        start_item(item_drive);
        finish_item(item_drive);

        // Overwrite the randomized fields to be constrained:
        item_drive.dir        = APB_WRITE ;
        item_drive.address    = this.addr ;
        item_drive.data       = this.rw_data ; 
        start_item(item_drive);
        finish_item(item_drive);

        /*
        Can be replaced with: 
            apb_item_drive item_drive;
            `uvm_do_with(item_drive,{ // Not supported in Modelsim because it uses "randomize()" method [see code of `uvm_do_with macro].
                dir == APB_READ;
                addr == local::addr;
            })
        */

    endtask : body
 	

endclass : apb_sequence_rw

`endif
