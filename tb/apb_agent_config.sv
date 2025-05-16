`ifndef APB_AGENT_CONFIG_SV
  	`define APB_AGENT_CONFIG_SV
	
	class apb_agent_config extends uvm_component;
      
      `uvm_component_utils(apb_agent_config)
      
      local apb_vif vif ;
      
      function new(string name="", uvm_component parent=null);
        super.new(name, parent);
      endfunction
      
      // Getter for the APB virtual interface:
      virtual function apb_vif get_vif();
        return vif;
      endfunction
      
      // Setter for the APB virtual interface:
      virtual function void set_vif(apb_vif value);
        if(vif == null) begin
          vif =  value;
        end
        else begin
          `uvm_fatal("ALGORITHM ISSUE", "Trying to set the virtual interface more than once.")
        end
      endfunction
      
      
      // Checking if the vif is configured when starting the simulation:    
      virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        
        if(get_vif == null) begin
          `uvm_fatal("ALGORITHM ISSUE", "The APB virtual interface is not configured at [start of simulation] phase.")
        end
        else begin
          `uvm_info("APB CONFIG", "The APB virtual interface is configured at [start of simulation] phase.", UVM_LOW)
        end
        
      endfunction
      
                          
                          
    endclass
	
	
`endif