`ifndef APB_SEQUENCE_RANDOM
`define APB_SEQUENCE_RANDOM

class apb_sequence_random extends apb_sequence_base;
  
    `uvm_object_utils(apb_sequence_random)
    
    // apb_item_drive item_drive ; // to be replaced with : rand apb_item_drive item_drive;
    int unsigned num_item ;     // to be replaced with: rand int unsigned num_item;

    function new(string name="");
        super.new(name);
    endfunction : new

    // Randomize the item using the user defined randomize method:
    virtual function void randomize_user();
        // Randomize sequence fields:
        this.num_item  = apb_addr'($urandom_range(1, 10)) ;
    endfunction : randomize_user 
  
    task body();
        for(int i = 0; i < this.num_item; i++)begin
            apb_sequence_simple seq_simple = apb_sequence_simple::type_id::create("seq_simple") ;
            // Randomize the item fields:
            seq_simple.randomize_user(); // to be replaced with: `void(seq_simple.randomize());
            seq_simple.start(m_sequencer, this); 
        end
    endtask : body
 	
 	

endclass

`endif
