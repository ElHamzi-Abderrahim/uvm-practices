`ifndef MD_RESET_HANDLER_SV
`define MD_RESET_HANDLER_SV

interface class md_reset_handler ;
    pure virtual function void handle_reset(uvm_phase phase) ;
endclass : md_reset_handler

`endif