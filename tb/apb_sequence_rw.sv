`ifndef APB_SEQUENCE_RW
`define APB_SEQUENCE_RW

class apb_sequence_rw extends apb_sequence_base;
  
    `uvm_object_utils(apb_sequence_rw)
   
  apb_item_drive item_drive;

`ifndef RANDOMIZATION_SUPPORTED
    
    apb_addr addr ;             
    apb_data rw_data ;
`endif // `ifndef RANDOMIZATION_SUPPORTED    

`ifdef RANDOMIZATION_SUPPORTED
    rand apb_addr addr ;
    rand apb_data rw_data;
`endif // `ifdef RANDOMIZATION_SUPPORTED  


    function new(string name="");
        super.new(name);
`ifndef RANDOMIZATION_SUPPORTED
        item_drive = apb_item_drive::type_id::create("item_drive") ;
`endif // `ifndef RANDOMIZATION_SUPPORTED            
    endfunction : new


`ifndef RANDOMIZATION_SUPPORTED
    // Randomize the item using the user defined randomize method:
    virtual function void randomize_user();
        // Randomize the item when randomizing the sequence:
        item_drive.randomize_user();
        // Randomize sequence fields:
        this.addr             = apb_addr'($urandom()) ; 
        this.rw_data          = apb_data'($urandom()) ;
    endfunction : randomize_user 
`endif // `ifndef RANDOMIZATION_SUPPORTED



    task body();
`ifndef RANDOMIZATION_SUPPORTED
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
`endif // `ifndef RANDOMIZATION_SUPPORTED
`ifdef RANDOMIZATION_SUPPORTED
        //       cfs_apb_item_drv item = cfs_apb_item_drv::type_id::create("item");
        //       void'(item.randomize() with {
        //         dir  == CFS_APB_READ;
        //         //Pay attention to the "local::" in order to avoid name confusion
        //         addr == local::addr;
        //       });
        //       start_item(item);
        //       finish_item(item);
            
        //       void'(item.randomize() with {
        //         dir  == CFS_APB_WRITE;
        //         //Pay attention to the "local::" in order to avoid name confusion
        //         addr == local::addr;
        //         data == wr_data;
        //       });
        //       start_item(item);
        //       finish_item(item);
        // The above ^ code can be replaced with `uvm_do macros
        // NOTE: `uvm_do_with is not supported in Modelsim because it uses "randomize()" method [see code of `uvm_do_with macro].
        `uvm_do_with(item_drive,{
            dir == APB_READ;
            addr == local::addr;
        });
      `uvm_do_with(item_drive, {
            dir  == APB_WRITE;
            addr == local::addr;
            data == rw_data;
        });
`endif // `ifdef RANDOMIZATION_SUPPORTED    
    endtask : body
 	

endclass : apb_sequence_rw

`endif //  `ifndef APB_SEQUENCE_RW
