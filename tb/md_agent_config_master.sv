`ifndef MD_AGENT_CONFIG_MASTER_SV
`define MD_AGENT_CONFIG_MASTER_SV

class md_agent_config_master#(int unsigned DATA_WIDTH = 32) extends md_agent_config#(DATA_WIDTH) ;
    
    `uvm_component_param_utils(md_agent_config_master#(DATA_WIDTH))

    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction : new


endclass : md_agent_config_master

`endif