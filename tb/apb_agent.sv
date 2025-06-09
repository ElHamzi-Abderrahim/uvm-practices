`ifndef APB_AGENT_SV
  	`define APB_AGENT_SV
	
	class apb_agent extends uvm_agent;
      
      `uvm_component_utils(apb_agent) 
      
      apb_agent_config agent_config ; // Handler of the configuration class.
      
      function new(string name = "", uvm_component parent);
        super.new(name, parent);
      endfunction
      
      virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_config = apb_agent_config::type_id::create("agent_config", this);
      endfunction
      
        	
      virtual function void connect_phase(uvm_phase phase);
        apb_vif vif ;
        super.connect_phase(phase);

        /*
        static function bit get( uvm_component cntxt, string inst_name, string field_name, inout T value)
            Get the value for field_name in inst_name, using component cntxt as the starting search point. 
            inst_name is an explicit instance name relative to cntxt 
                and may be an empty string if the cntxt is the instance that the configuration object applies to. 
            field_name is the specific field in the scope that is being searched for.
        */
        if(uvm_config_db#(apb_vif)::get(this, "", "vif", vif) == 0 ) begin
          `uvm_fatal("APB_NO_VIF", "Couldn't get the APB virtual interface from the database.")
        end
        else begin  // if the virtual interface is retrieved succufully from db -> vif.
          agent_config.set_vif(vif);
        end

      endfunction
  
      
            
      
	endclass
	

`endif