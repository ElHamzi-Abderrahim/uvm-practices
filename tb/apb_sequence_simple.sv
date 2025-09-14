`ifndef APB_SEQUENCE_SIMPLE
`define APB_SEQUENCE_SIMPLE

class apb_sequence_simple extends apb_sequence_base;
  
    `uvm_object_utils(apb_sequence_simple)
  
`ifdef RANDOMIZATION_SUPPORTED
    rand apb_item_drive item_drive ;
`endif // `ifdef RANDOMIZATION_SUPPORTED                
  
`ifndef RANDOMIZATION_SUPPORTED
    apb_item_drive item_drive ;
`endif // `ifndef RANDOMIZATION_SUPPORTED                

    function new(string name="");
        super.new(name);
        item_drive = apb_item_drive::type_id::create("item_drive");
    endfunction : new
    
`ifndef RANDOMIZATION_SUPPORTED
    // Randomize the item using the user defined randomize method:
    virtual function void randomize_user();
        item_drive.randomize_user();
    endfunction : randomize_user 
`endif // `ifndef RANDOMIZATION_SUPPORTED                
    
    
    
    task body();
        `ifdef RANDOMIZATION_SUPPORTED
        start_item(item_drive);
        finish_item(item_drive);
        `endif // `ifdef RANDOMIZATION_SUPPORTED         

        `ifndef RANDOMIZATION_SUPPORTED
        `uvm_send(item_drive)
        `endif // `ifndef RANDOMIZATION_SUPPORTED                        
    endtask : body
 	

endclass

`endif // `ifndef APB_SEQUENCE_SIMPLE
