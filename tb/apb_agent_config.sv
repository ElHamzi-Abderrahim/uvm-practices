`ifndef APB_AGENT_CONFIG_SV
`define APB_AGENT_CONFIG_SV
	
class apb_agent_config extends uvm_component;
	
	`uvm_component_utils(apb_agent_config)
	
	// Virtual Interface
	local apb_vif vif ;
	
	// Active/Passive control
	uvm_active_passive_enum active_passive ;

	// Switch to enable the checks
	local bit has_checks ;

	// Number of clock cycles after which the APB trasnfer is considered stuck
	local int unsigned stuck_threshold ;

	// Switch to enable the coverage
	local bit has_coverage ;
	
	function new(string name="", uvm_component parent=null);
		super.new(name, parent);
		active_passive  = UVM_ACTIVE ;
		has_checks      = 1 ;
		stuck_threshold = 1000 ;
		has_coverage    = 1 ;
	endfunction : new
	
	// Setter for the APB virtual interface:
	virtual function void set_vif(apb_vif value); // To make sure the setting of vif is done just once.
		if(vif == null) begin
			vif =  value;
			set_has_checks(get_has_checks()) ;
		end
		else begin
			`uvm_fatal("ALGORITHM ISSUE", "Trying to set the virtual interface more than once.")
		end
	endfunction : set_vif
	
	// Getter for the APB virtual interface:
	virtual function apb_vif get_vif();
		return vif;
	endfunction : get_vif


	// Setter of the Agent type: 
	virtual function void set_active_passive(uvm_active_passive_enum value);
		active_passive = value;
	endfunction : set_active_passive
	
	// Getter of the Agent type:
	virtual function uvm_active_passive_enum get_active_passive();
		return active_passive ;
	endfunction : get_active_passive


	// Setter for has_checks field
	virtual function void set_has_checks(bit value);
		has_checks = value ;

		if(vif != null) begin
			vif.has_checks = has_checks ;
		end
	endfunction : set_has_checks

	// Getter for has_checks field
	virtual function bit get_has_checks();
		return has_checks ;
	endfunction : get_has_checks


	// Setter for stuck_threshold field
	virtual function void set_stuck_threshold(int unsigned value);
		if(value <= 2) begin
			`uvm_error("ALGORITHM ISSUE", $sformatf("Tried to set stuck_threshold to value %0d but the minimum length of an APB tranfer is 2", value))
		end
		stuck_threshold = value ;
	endfunction : set_stuck_threshold

	// Getter for has_checks field
	virtual function int unsigned get_stuck_threshold();
		return stuck_threshold ;
	endfunction : get_stuck_threshold


	// Setter for has_coverage field
	virtual function void set_has_coverage(bit value);
		has_coverage = value ;
	endfunction : set_has_coverage

	// Getter for has_checks field
	virtual function bit get_has_coverage();
		return has_coverage ;
	endfunction : get_has_coverage


	// Checking if the vif is configured when starting the simulation:    
	virtual function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		
		if(get_vif == null) begin
			`uvm_fatal("ALGORITHM ISSUE", "The APB virtual interface is not configured at \"start of simulation\" phase.")
		end
		else begin
			`uvm_info("APB CONFIG", "The APB virtual interface is configured at \"start of simulation\" phase.", UVM_LOW)
		end
	endfunction : start_of_simulation_phase
      

	virtual task run_phase(uvm_phase phase);
		forever begin
			// If the has_checks field has changed
			@(vif.has_checks) ; 

			// Make sure it has not changed outside APB agent config
			if(vif.has_checks != get_has_checks()) begin
				`uvm_error("ALGORITHM ISSUE", $sformatf("Can not change \'has_checks\' from APB interface directly - use %0s.set_has_checks()", get_full_name() ) )
			end
		end
	endtask

	// Detecting the start of reset:
	virtual task wait_reset_start();
		if(vif.presetn !== 0) begin
			@(negedge vif.presetn) ; // asserting the reset is Asynchronous
		end
	endtask: wait_reset_start
    
	// Detecting the end of reset:
	virtual task wait_reset_end();
		while(vif.presetn == 0) begin
			@(posedge vif.pclk) ; // de-asserting the reset is Synchronous
		end
	endtask: wait_reset_end                      

	
endclass : apb_agent_config
	
	
`endif // `ifndef APB_AGENT_CONFIG_SV