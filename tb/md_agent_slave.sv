`ifndef MD_AGENT_SLAVE_SV
`define MD_AGENT_SLAVE_SV

class md_agent_slave#(int unsigned DATA_WIDTH = 32) extends md_agent#(DATA_WIDTH) ;

    `uvm_component_param_utils(md_agent_slave#(DATA_WIDTH))

    function new (string name="", uvm_component parent);
        super.new(name, parent);
        
        md_agent_config#(DATA_WIDTH)::type_id::set_inst_override(md_agent_config_slave#(DATA_WIDTH)::get_type(), "agent_config", this) ; // Override the the agent created with the name "agent_config" under this agent to the agent_config_slave.
        // Calling it in the constructor will force (::type_id::create(...)) in agent build_phase to return the overrided type 
    
    endfunction : new
    
endclass : md_agent_slave
`endif