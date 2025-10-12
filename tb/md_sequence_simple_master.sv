`ifndef MD_SEQUENCE_SIMPLE_MASTER_SV
`define MD_SEQUENCE_SIMPLE_MASTER_SV

class md_sequence_simple_master extends md_sequence_base#(md_item_drv_master) ;

    `uvm_object_utils(md_sequence_simple_master)

    `ifdef RANDOMIZATION_SUPPORTED
        rand md_item_drv_master  item ;
        
        constraint item_hard {
            item.data.size() > 0 ;
            item.data.size() <= p_sequencer.get_data_width() / 8;
            item.data.size() + item.offset() <= p_sequencer.get_data_width() / 8 ;
        }
    `endif // `ifdef RANDOMIZATION_SUPPORTED
    
    `ifndef RANDOMIZATION_SUPPORTED
        md_item_drv_master  item ;

        local int unsigned size_d; 
        local bit [7:0] data_rnd; 
        local int i ; 

        virtual function void randomize_user();
            item.randomize_user() ;

            size_d  = $urandom_range(1 , p_sequencer.get_data_width() / 8 ) ;
            $display("SEQ SIMPLE: Randomized data size : %0d", size_d) ;

            item.offset = $urandom_range(0 , ((p_sequencer.get_data_width()/8)-size_d )) ; 
            // <=> item.data.size() + item.offset() <= p_sequencer.get_data_width() / 8 ;
            $display("SEQ SIMPLE: Randomized offset : %0d", item.offset) ;
            
            item.data = {} ;
            for(i =0; i<size_d; i++) begin
                data_rnd = $urandom() ;
                item.data.push_front(data_rnd) ;
            end // for

            $display("SEQ SIMPLE: Randomized data    : %p", item.data) ;
        endfunction : randomize_user
    `endif // `ifndef RANDOMIZATION_SUPPORTED

    
    function new(string name="");
        super.new(name) ;
        
        item = md_item_drv_master::type_id::create("item") ;
        
        `ifdef RANDOMIZATION_SUPPORTED
        // Deactivate the item constraints:
        item.data_default.constraint_mode(0) ;
        item.data_hard.constraint_mode(0) ;
        `endif // `ifdef RANDOMIZATION_SUPPORTED
    endfunction : new

    virtual task body() ;
        $display("At start of body() of the sequence_simple_master \n") ;

        `ifdef RANDOMIZATION_SUPPORTED
        start_item(item);
        finish_item(item);
        `endif // `ifdef RANDOMIZATION_SUPPORTED         

        `ifndef RANDOMIZATION_SUPPORTED
        `uvm_send(item)
        `endif // `ifndef RANDOMIZATION_SUPPORTED 

        $display("At the end of the body() of the sequence_simple_master \n") ;

    endtask : body


endclass 


`endif