`ifndef MD_AGENT_CONFIG_SV
`define MD_AGENT_CONFIG_SV

class md_agent_config#(int unsigned DATA_WIDTH = 32) extends uvm_component ;
    
	`uvm_component_param_utils(md_agent_config#(DATA_WIDTH))
    
    typedef virtual md_if#(DATA_WIDTH) md_vif ; // defined here because it's dependent on the DATA_WIDTH

    // Virtual Interface
	local md_vif vif ;
	
	// Active/Passive control
	uvm_active_passive_enum active_passive ;

	// Switch to enable the checks
	local bit has_checks ;

	// Switch to enable the coverage
	local bit has_coverage ;


	function new (string name="", uvm_component parent);
		super.new(name, parent) ;

		active_passive  = UVM_ACTIVE ;
		has_checks      = 1 ;
		has_coverage    = 1 ;
	endfunction : new

	virtual task run_phase (uvm_phase phase);
		forever begin
			// If the has_checks field has changed
			@(vif.has_checks) ; 
			// Make sure it has not changed outside MD agent config
			if(vif.has_checks != get_has_checks()) begin
				`uvm_error("ALGORITHM ISSUE", $sformatf("Can not change \'has_checks\' from MD interface directly - use %0s.set_has_checks()", get_full_name() ) )
			end
		end
	endtask


	// Setter for the MD virtual interface:
	virtual function void set_vif(md_vif value); // To make sure the setting of vif is done just once.
		if(vif == null) begin
			vif =  value;
			set_has_checks(get_has_checks()) ;
		end
		else begin
			`uvm_fatal("ALGORITHM ISSUE", "Trying to set the virtual interface more than once.")
		end
	endfunction : set_vif
	
	// Getter for the MD virtual interface:
	virtual function md_vif get_vif();
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


	// Setter for has_coverage field
	virtual function void set_has_coverage(bit value);
		has_coverage = value ;
	endfunction : set_has_coverage

	// Getter for has_checks field
	virtual function bit get_has_coverage();
		return has_coverage ;
	endfunction : get_has_coverage


	// Detecting the start of reset:
	virtual task wait_reset_start();
		if(vif.reset_n !== 0) begin
			@(negedge vif.reset_n) ; // asserting the reset is Asynchronous
		end
	endtask: wait_reset_start
    
	// Detecting the end of reset:
	virtual task wait_reset_end();
		while(vif.reset_n == 0) begin
			@(posedge vif.clk) ; // de-asserting the reset is Synchronous
		end
	endtask: wait_reset_end                      




endclass : md_agent_config


`endif