`ifndef APB_SEQUENCE_RANDOM
`define APB_SEQUENCE_RANDOM

class apb_sequence_random extends apb_sequence_base;
  
    `uvm_object_utils(apb_sequence_random)
    
    // apb_item_drive item_drive ; // to be replaced with : rand apb_item_drive item_drive;
    
`ifndef APB_SEQUENCE_RANDOM
    int unsigned num_items ;     
`endif // `ifndef RANDOMIZATION_SUPPORTED                

`ifdef APB_SEQUENCE_RANDOM 
    rand int unsigned num_items;
    constraint num_items_default {
        soft num_items inside {[1:10]}; 
    }
`endif // `ifdef RANDOMIZATION_SUPPORTED                

    function new(string name="");
        super.new(name);
    endfunction : new


`ifndef RANDOMIZATION_SUPPORTED
    // Randomize the item using the user defined randomize method:
    virtual function void randomize_user();
        // Randomize sequence field:
        this.num_items  = apb_addr'($urandom_range(1, 10)) ;
    endfunction : randomize_user 
`endif // `ifndef RANDOMIZATION_SUPPORTED      


    task body();
        for(int i = 0; i < this.num_items; i++)begin
            apb_sequence_simple seq_simple = apb_sequence_simple::type_id::create("seq_simple") ;

            // Randomize the item fields:
`ifndef RANDOMIZATION_SUPPORTED
            seq_simple.randomize_user(); // to be replaced with: 
`endif // `ifndef RANDOMIZATION_SUPPORTED                

`ifdef RANDOMIZATION_SUPPORTED
            `void(seq_simple.randomize());
`endif // `ifdef RANDOMIZATION_SUPPORTED                
            
            seq_simple.start(m_sequencer, this); 
        end
    endtask : body
 	
 	

endclass

`endif // `ifndef APB_SEQUENCE_RANDOM_SV
