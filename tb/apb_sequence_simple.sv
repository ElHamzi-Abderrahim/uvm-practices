`ifndef APB_SEQUENCE_SIMPLE
    `define APB_SEQUENCE_SIMPLE

class apb_sequence_simple extends apb_sequence_base;
  
    `uvm_object_utils(apb_sequence_simple)

    apb_item_drive item_drive ;
    // Randomize the item lusing the user defined randomize method:
    virtual function void randomize_user();
        item_drive.randomize_user();
    endfunction : randomize_user 
 

    function new(string name="");
        super.new(name);
        item_drive = apb_item_drive::type_id::create("item_drive");
    endfunction : new
    
    task body();
        // start_item(item_drive);
        // finish_item(item_drive);
        // `uvm_do(item_drive) : which uses randomize() method to randomize the fileds of the item.
        `uvm_send(item_drive)
    endtask : body
 	

endclass

`endif
