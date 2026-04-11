`ifndef MD_DRIVER_BASE_SV
`define MD_DRIVER_BASE_SV


class md_driver#(type ITEM_DRIVE = md_item_drv) extends uvm_driver#(.REQ(ITEM_DRIVE)) implements md_reset_handler ;
    

    // Pointer to MD agent config
    md_agent_config agent_config ;

    // Process for drive_transaction() task 
    protected process process_drive_transactions ;

    `uvm_component_param_utils(md_driver#(ITEM_DRIVE))
    
    function new(string name="", uvm_component parent);
        super.new(name, parent) ;
    endfunction : new



    virtual task run_phase(uvm_phase phase);
        forever begin
            fork
                begin 
                    wait_reset_end() ;
                    drive_transactions();   
                    disable fork ;
                end
            join
        end
    endtask : run_phase


    // Empty taskt to be overrided in md_driver_slave and md_driver_master
    protected virtual task drive_transaction(ITEM_DRIVE item);
        // Empty
        `uvm_fatal("ALGORITHM_ISSUE", "Implement drive_transaction()") 
    endtask : drive_transaction

    protected virtual task drive_transactions();
        fork
            begin
                process_drive_transactions = process::self() ;
                forever begin
                    ITEM_DRIVE  md_d_item ;
                    // $display("%0t :[DEBUG] DRIVER: Waiting to get the next item... \n", $time);
                    seq_item_port.get_next_item(md_d_item);
                    // $display("%0t :[DEBUG] DRIVER: Driver got the next item... \n", $time);
                    drive_transaction(md_d_item);
                    seq_item_port.item_done();
                end 
            end
        join    
    endtask : drive_transactions


    protected virtual task wait_reset_end() ;
        agent_config.wait_reset_end(); 
    endtask : wait_reset_end 


    // Funtion to handle reset:
    virtual function void handle_reset(uvm_phase phase) ; 
        // $display("[DEBUG] DRIVER: begin handle_reset().");
        if(process_drive_transactions != null) begin
            process_drive_transactions.kill() ; 
            process_drive_transactions = null ;
        end
        // $display("[DEBUG] DRIVER: end handle_reset().");        
    endfunction : handle_reset


endclass : md_driver

`endif