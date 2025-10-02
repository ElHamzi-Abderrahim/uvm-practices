`ifndef MD_AGENT_CONFIG_SLAVE_SV
`define MD_AGENT_CONFIG_SLAVE_SV

class md_agent_config_slave#(int unsigned DATA_WIDTH = 32) extends md_agent_config#(DATA_WIDTH) ;
    
    `uvm_component_param_utils(md_agent_config_slave#(DATA_WIDTH))

    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction : new


endclass : md_agent_config_slave

`endif