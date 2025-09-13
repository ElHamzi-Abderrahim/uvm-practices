`ifndef APB_AGENT_SV
`define APB_AGENT_SV
	
class apb_agent extends uvm_agent implements apb_reset_handler;
	
	`uvm_component_utils(apb_agent)

	// configuration class Handler.
	apb_agent_config 	agent_config ;	

	// APB sequencer Handler.	
	apb_sequencer 		apb_sequencer_h;

	// APB driver Handler.
	apb_driver 			apb_driver_h;	

	// APB monitor Handler.
	apb_monitor			apb_monitor_h;	

	// APB coverage Handler.
	apb_coverage    	apb_coverage_h;	


	function new(string name = "", uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent_config = apb_agent_config::type_id::create("agent_config", this);
		apb_monitor_h   = apb_monitor::type_id::create("apb_monitor_h", this);

		if(agent_config.active_passive == UVM_ACTIVE) begin
			apb_sequencer_h = apb_sequencer::type_id::create("apb_sequencer_h", this);
			apb_driver_h    = apb_driver::type_id::create("apb_driver_h", this);
		end

		if(agent_config.get_has_coverage() == 1) begin
			apb_coverage_h  = apb_coverage::type_id::create("apb_coverage_h", this); 
		end

	endfunction : build_phase
	
		
	virtual function void connect_phase(uvm_phase phase);
		apb_vif vif ;
		super.connect_phase(phase);
		/*
		static function bit get( uvm_component cntxt, string inst_name, string field_name, inout T value)
			Get the value for field_name in inst_name, using component cntxt as the starting search point. 
			inst_name is an explicit instance name relative to cntxt and may be an empty string if the cntxt is  
						the instance that the configuration object applies to. 
			field_name is the specific field in the scope that is being searched for. [UVM-CRM]
		*/
		if( (uvm_config_db#(apb_vif)::get(this, "", "vif", vif)) == 0 ) begin
			`uvm_fatal("APB_NO_VIF", "Couldn't get the APB virtual interface from the database.")
		end
		else begin  // if the virtual interface is retrieved succufully (get methode returned '1' ) from db -> vif.
			agent_config.set_vif(vif);
		end

		// Pass the pointer of agent config to the monitor
		apb_monitor_h.agent_config = agent_config ;
		
		// Connecting the Driver and Sequencer if the Agent is in ACTIVE mode:
		if(agent_config.get_active_passive() == UVM_ACTIVE) begin
			apb_driver_h.seq_item_port.connect(apb_sequencer_h.seq_item_export);
			
			// Pass the pointer of agent config to the driver
			apb_driver_h.agent_config = agent_config ;
		end

		// Connecting Monitor to Coverage component if the Agent has coverage:
		if(agent_config.get_has_coverage() == 1) begin
			// apb_monitor_h.apb_analysis_port.connect(apb_coverage_h.apb_analysis_export) ; // for (+ Methode-1)
			apb_monitor_h.apb_analysis_port.connect(apb_coverage_h.port_item) ; // for (+ Methode-2)
			apb_coverage_h.agent_config = agent_config ;

		end

	endfunction : connect_phase


	virtual function void handle_reset(uvm_phase phase);
		uvm_component children[$] ;
		
		get_children(children) ;

		foreach (children[idx]) begin
			apb_reset_handler reset_handler ;
			
			if($cast(reset_handler, children[$])) begin
				reset_handler.handle_reset(phase) ;
			end 

		end
	endfunction: handle_reset


	// Reset handling:
	virtual task wait_reset_start();
		agent_config.wait_reset_start() ;
	endtask: wait_reset_start
    
	virtual task wait_reset_end();
		agent_config.wait_reset_end() ;
	endtask: wait_reset_end


	virtual task run_phase(uvm_phase phase) ;
		forever begin
			wait_reset_start(); 
			handle_reset(phase) ;
			wait_reset_end() ;
		end
	endtask : run_phase    
	
endclass : apb_agent
	
`endif // `ifndef APB_AGENT_SV