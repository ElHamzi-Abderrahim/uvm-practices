`ifndef ALGN_ENV_SV
`define ALGN_ENV_SV

class algn_env#(int unsigned MD_DATA_WIDTH = 32) extends uvm_env;
  
    `uvm_component_param_utils(algn_env#(MD_DATA_WIDTH))
    
    // APB Agent handler
  	apb_agent apb_agent_h ; 

    // MD Agent TX handler
    md_agent_master#(MD_DATA_WIDTH) md_agent_rx ;

    // MD Agent RX handler
    md_agent_slave#(MD_DATA_WIDTH) md_agent_tx ;


    function new(string name="algn_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction
  
 	virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        apb_agent_h = apb_agent::type_id::create("apb_agent_h", this);

        md_agent_rx = md_agent_master#(MD_DATA_WIDTH)::type_id::create("md_agent_rx", this);
        md_agent_tx = md_agent_slave#(MD_DATA_WIDTH)::type_id::create("md_agent_tx", this);
        
    endfunction

endclass

`endif // `ifndef ALGN_ENV_SV





