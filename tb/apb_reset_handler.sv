`ifndef APB_RESET_HANDLER_SV
`define APB_RESET_HANDLER_SV

interface class apb_reset_handler;
    
    // handling reset function
    pure virtual function void handle_reset(uvm_phase phase) ; 
 	
endclass : apb_reset_handler

`endif // `ifndef APB_RESET_HANDLER_SV
