`ifndef MD_DRIVER_MASTER_SV
`define MD_DRIVER_MASTER_SV


class md_driver_master#(int unsigned DATA_WIDTH = 32) extends md_driver#(.ITEM_DRIVE(md_item_drv_master))  ;
    
    `uvm_component_param_utils(md_driver_master#(DATA_WIDTH))

    // Defining the type based on the DATA_WIDTH param
    typedef virtual md_if#(DATA_WIDTH) md_vif ;

    function new(string name="", uvm_component parent);
        super.new(name, parent) ;
    endfunction : new


    virtual task drive_transaction(md_item_drv_master item);
        md_vif vif = agent_config.get_vif() ;

        int unsigned data_width_in_bytes = DATA_WIDTH / 8 ;

        $display("[DEBUG] MD_DRIVER_MASTER %0s ", $sformatf("Driving \"%0s\" item: %0s", item.get_full_name(),item.convert2string()));

        if(item.offset + item.data.size() > data_width_in_bytes ) begin
            `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Trying to drive an item with offset %0d and %0d bytes, but the width of the data bus, in bytes is %0d", 
                        item.offset, item.data.size(), data_width_in_bytes ))
        end


        /***************************************/
        /*     Driving the item to the bus     */

        // Wait for predrive delay
        for(int i=0; i<item.pre_drive_delay; i++) begin
            @(posedge vif.clk) ;
        end

        vif.valid <= '1 ;

        // Aligning data on the offset
        begin
            bit[DATA_WIDTH-1: 0] data = 0 ;
            
            foreach(item.data[idx]) begin
                bit[DATA_WIDTH-1: 0] temp = item.data[idx] << ((item.offset + idx) * 8) ;
                data = data | temp ;
            end

            vif.data <= data ;
        end

        vif.offset <= item.offset ;
        vif.size   <= item.data.size() ;

        @(posedge vif.clk) ;

        // Wait for ready signal
        while (vif.ready !== 1) begin
            @(posedge vif.clk) ;
        end

        // Clear signal after the end of the transaction
        vif.valid  <= 0 ;
        vif.data   <= '0 ;
        vif.size   <= '0 ;
        vif.offset <= '0 ;

        // Wait for post drive delay
        for(int i=0; i<item.post_drive_delay; i++) begin
            @(posedge vif.clk) ;
        end
    endtask : drive_transaction

    
    virtual function void handle_reset(uvm_phase phase) ;
        md_vif vif = agent_config.get_vif() ;
        super.handle_reset(phase) ;
        
        vif.valid  <= 0 ;
        vif.data   <= '0 ;
        vif.size   <= '0 ;
        vif.offset <= '0 ;
    endfunction

endclass : md_driver_master

`endif
