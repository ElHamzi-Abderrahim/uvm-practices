`ifndef APB_DRIVER
`define APB_DRIVER

class apb_driver extends uvm_driver #(.REQ(apb_item_drive));
  
    `uvm_component_utils(apb_driver)

    virtual apb_if vif ;


    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction:new

    function void build_phase (uvm_phase phase); 
        super.build_phase(phase);
    endfunction:build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            apb_item_drive apb_d_item ;
            // Get next data item from sequencer (blocking until item is provided by the sequences running on the sequencer):
            seq_item_port.get_next_item(apb_d_item);

            $display("[DEBUG] %0s ", $sformatf("Driving \"%0s\" item: %0s", apb_d_item.get_full_name(),apb_d_item.convert2string()));
            // Execute the item:
            drive_item(apb_d_item);

            seq_item_port.item_done();
        end
    endtask : run_phase

    task drive_item(input apb_item_drive item);
        // driving logic of the item
        // $display("Hello from item driver");
    endtask : drive_item
  
 	
endclass : apb_driver

`endif
