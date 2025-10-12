`ifndef MD_DRIVER_SLAVE_SV
`define MD_DRIVER_SLAVE_SV


class md_driver_master#(int unsigned DATA_WIDTH = 32) extends md_driver#(.ITEM_DRV(md_item_drv_slave))  ;
    
    `uvm_component_param_utils(md_driver_master)

    // Defining the type based on the DATA_WIDTH param
    typedef virtual md_if#(`ALIGN_TEST_DATA_WIDTH) md_vif ;


    function new(string name="", uvm_componenet parent);
        super.new(name, parent) ;
    endfunction : new


    function void build_phase (uvm_phase phase); 
        super.build_phase(phase);
    endfunction:build_phase


    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase) ;
    endtask : run_phase


    virtual task drive_transactions();
        super.drive_transactions(); 
    endtask : drive_transactions


    // Empty taskt to be overrided in md_driver_slave and md_driver_master
    virtual task drive_transaction(input ITEM_DRV item);
        
    endtask : drive_transaction


endclass : md_driver_master

`endif