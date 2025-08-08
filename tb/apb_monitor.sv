`ifndef APB_MONITOR_SV
`define APB_MONITOR_SV

class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    uvm_analysis_port #(apb_item_monitor) apb_analysis_port ;

    // Pointer to agent configuration
    apb_agent_config agent_config ;
    
    function new(string name="", uvm_component parent);
        super.new(name, parent);
        apb_analysis_port = new("apb_analysis_port", this) ;
    endfunction:new


    virtual task run_phase(uvm_phase phase);
        collect_transactions();
    endtask : run_phase

    protected virtual task collect_transactions();
        forever begin
            collect_transaction();
        end
    endtask : collect_transactions


    protected virtual task collect_transaction();
        // Get vif pointer
        apb_vif vif = agent_config.get_vif() ; 
        
        apb_item_monitor item = apb_item_monitor::type_id::create("item") ;
        
        int unsigned count_cyc_prv ;
     
        // Monitoring the trasnaction:

        count_cyc_prv = 0 ;

        while (vif.psel !== 1) begin
            @(posedge vif.pclk) ;
            item.prev_item_delay++ ;
        end
        
        // Monitor the address
        item.address = vif.paddr ;
        item.dir = apb_dir'(vif.pwrite) ;

        // Check if read/write operation
        if (item.dir == APB_WRITE) begin
            item.data   = vif.pwdata ;
        end // if pwrite
        else begin
            item.data   = vif.prdata ;
        end // else

        item.length = 1 ;

        @(posedge vif.pclk) ;
        item.length++;

        // Waiting for pready to be asserted by the APB Slave
        while(vif.pready !== 1'b1) begin
            @(posedge vif.pclk) ;
            item.length++;
            
            // Checker for stucked transaction
            if(agent_config.get_has_checks()) begin
                if(item.length >= agent_config.get_stuck_threshold()) begin
                    `uvm_error("PROTOCOL ERROR", $sformatf("APB transfer reached the stuck threshold limit of %0d clock cycles", item.length) )
                end
            end
        end // while

        // The APB Slave response
        item.response = apb_response'(vif.pslverr) ;

        apb_analysis_port.write(item) ;

        $display("[DEBUG] %0s ", $sformatf("Monitored item \"%0s\" item: %0s", item.get_full_name(),item.convert2string()));
        @(posedge vif.pclk) ;

    endtask : collect_transaction
  
endclass : apb_monitor

`endif
