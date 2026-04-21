`ifndef MD_MONITOR_SV
`define MD_MONITOR_SV

class md_monitor#(int unsigned DATA_WIDTH=32) extends uvm_monitor implements md_reset_handler;

    `uvm_component_param_utils(md_monitor#(DATA_WIDTH))

    typedef virtual md_if#(DATA_WIDTH) md_vif ;

    uvm_analysis_port #(md_item_monitor) md_output_port ;

    // Pointer to agent configuration
    md_agent_config agent_config ;

    // Process for collect_transactions() task 
    protected process process_collect_transactions ; 

    function new(string name="", uvm_component parent);
        super.new(name, parent);
        md_output_port = new("md_output_port", this) ;
    endfunction:new


    virtual task wait_reset_end() ;
        agent_config.wait_reset_end(); 
    endtask : wait_reset_end 


    virtual task run_phase(uvm_phase phase);
        forever begin
            fork
                begin
                    wait_reset_end() ;
                    collect_transactions();
                    disable fork ;
                end             
            join
        end
    endtask : run_phase


    protected virtual task collect_transactions();
        fork 
            begin
                process_collect_transactions = process::self() ; 
                forever begin
                    collect_transaction();
                end
            end 
        join 
    endtask : collect_transactions


    protected virtual task collect_transaction();
        // Get vif pointer
        md_vif vif = agent_config.get_vif() ; 

        md_item_monitor item = md_item_monitor::type_id::create("item") ;

        int unsigned data_width_in_bytes = DATA_WIDTH/8 ;

        // Monitoring the trasnaction //
        
        // Detect the beginnig of the transaction (rising_edge(valid)+sample_delay_start_tr)
        #(agent_config.get_sample_delay_start_tr()) ;

        while(vif.valid !== 1) begin
            @(posedge vif.clk) ;
            item.prev_item_delay++ ;
            #(agent_config.get_sample_delay_start_tr()) ;
        end

        // Monitor the data and offset
        item.offset = vif.offset ;
        
        for(int i =0; i<vif.size; i++) begin 
            item.data.push_back( (vif.data >> ((item.offset + i)*8)) & 8'hff ) ;
        end
        
        item.length = 1 ;

        void'(begin_tr(item));

        md_output_port.write(item) ;

        @(posedge vif.clk) ;

        while(vif.ready !== 1'b1) begin
            @(posedge vif.clk) ;
            item.length++ ;
        end

        item.response = md_response'(vif.err);

        end_tr(item) ;

        md_output_port.write(item) ;

        $display("[DEBUG] %0s ", $sformatf("Monitored item \"%0s\" item: %0s", item.get_full_name(),item.convert2string()));

    endtask : collect_transaction
    


    virtual function void handle_reset(uvm_phase phase) ; 
        if(process_collect_transactions != null) begin
            process_collect_transactions.kill() ;

            process_collect_transactions = null ;
        
        end
    endfunction: handle_reset


endclass : md_monitor

`endif // `ifndef MD_MONITOR_SV
