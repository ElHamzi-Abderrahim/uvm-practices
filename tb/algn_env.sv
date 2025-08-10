`ifndef ALGN_ENV_SV
`define ALGN_ENV_SV

class algn_env extends uvm_env;
  
    `uvm_component_utils(algn_env)
  
  	apb_agent apb_agent_h ; // APB Agent handle

    function new(string name="algn_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction
  
 	virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        apb_agent_h = apb_agent::type_id::create("apb_agent_h", this);
    endfunction

endclass

`endif // `ifndef ALGN_ENV_SV





