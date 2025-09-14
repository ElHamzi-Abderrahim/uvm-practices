`ifndef APB_DRIVER_SV
`define APB_DRIVER_SV

class apb_driver extends uvm_driver #(.REQ(apb_item_drive)) implements apb_reset_handler;

    `uvm_component_utils(apb_driver)

    // Pointer to agent configuration
    apb_agent_config    agent_config ;
    
    // apb_item_drive      apb_d_item ;

    // Process for drive_transaction() task 
    protected process process_drive_transactions ;


    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction:new

    function void build_phase (uvm_phase phase); 
        super.build_phase(phase);
    endfunction:build_phase

    virtual task wait_reset_end() ;
        agent_config.wait_reset_end(); 
    endtask : wait_reset_end 
 	

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

    protected virtual task drive_transactions();
        fork
            begin
                process_drive_transactions = process::self() ;

                forever begin
                    apb_item_drive      apb_d_item ;

                    seq_item_port.get_next_item(apb_d_item);
                    drive_transaction(apb_d_item);
                    seq_item_port.item_done();
                end 
            end
        join    
    endtask : drive_transactions


    protected virtual task drive_transaction(input apb_item_drive item);
        apb_vif vif = agent_config.get_vif() ;
        $display("[DEBUG] %0s ", $sformatf("Driving \"%0s\" item: %0s", item.get_full_name(),item.convert2string()));

        // Wait for a pre-drive delay
        for(int i=0; i<item.pre_drive_delay; i++) begin
            @(posedge vif.pclk) ;
        end

        // Driving APB transaction
        vif.psel    <= 1'b1 ;
        vif.pwrite  <= bit'(item.dir) ;
        vif.paddr   <= item.address  ;

        if(item.dir == APB_WRITE) begin
            vif.pwdata <= item.data ;
        end

        // Wait for one clock cycle before driving penable
        @(posedge vif.pclk) ;
        vif.penable <= 1'b1 ;

        // Wait for one clock cycle before checkint pready is high
        @(posedge vif.pclk) ;

        // Wait for pready (end of the transfer)
        while(vif.pready !== 1'b1) begin
            @(posedge vif.pclk) ;
        end

        // Initialize the signals to their initail values after the end of the transaction
        vif.psel    <= 0 ;
        vif.penable <= 0 ;
        vif.pwrite  <= 0 ;
        vif.paddr   <= '0 ;
        vif.pwdata  <= '0 ;

        // Wait for post drive delay
        for(int i=0; i<item.post_drive_delay; i++) begin
            @(posedge vif.pclk) ;
        end

    endtask : drive_transaction

    // Funtion to handle reset:
    virtual function void handle_reset(uvm_phase phase) ; 
        apb_vif vif = agent_config.get_vif() ;

        if(process_drive_transactions != null) begin
            process_drive_transactions.kill() ; 

            process_drive_transactions = null ;
        end

        // Signals initialization:
        vif.psel    <= 0 ;
        vif.penable <= 0 ;
        vif.pwrite  <= 0 ;
        vif.paddr   <= '0 ;
        vif.pwdata  <= '0 ;      

    endfunction : handle_reset


endclass : apb_driver

`endif // `ifndef APB_DRIVER_SV
