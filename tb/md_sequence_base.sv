`ifndef MD_SEQUENCE_BASE_SV
`define MD_SEQUENCE_BASE_SV

class md_sequence_base#(type ITEM_DRIVE = md_item_drv) extends uvm_sequence#(.REQ(ITEM_DRIVE)) ;

    `uvm_object_param_utils(md_sequence_base#(ITEM_DRIVE))

    `uvm_declare_p_sequencer(md_sequencer#(ITEM_DRIVE))

    function new(string name="");
        super.new(name) ;
    endfunction : new

endclass 


`endif