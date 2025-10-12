`ifndef MD_AGENT_SV
`define MD_AGENT_SV

class md_agent#(int unsigned DATA_WIDTH = 32, type ITEM_DRIVE = md_item_drv) extends uvm_component implements md_reset_handler ;
    
    `uvm_component_param_utils(md_agent#(DATA_WIDTH, ITEM_DRIVE))

    typedef virtual md_if#(DATA_WIDTH) md_vif ; // defined here because it's dependent on the DATA_WIDTH

	// Agent config handler
    md_agent_config#(DATA_WIDTH) agent_config ;

	// MD driver handler
	md_driver#(ITEM_DRIVE) driver ;

	// Sequencer handler
	md_sequencer#(ITEM_DRIVE) sequencer ;


    function new(string name="", uvm_component parent) ;
        super.new(name, parent) ;
    endfunction : new 


    virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent_config = md_agent_config#(DATA_WIDTH)::type_id::create("agent_config", this);

		if(agent_config.get_active_passive() == UVM_ACTIVE) begin
			sequencer = md_sequencer#(ITEM_DRIVE)::type_id::create("sequencer", this) ;
			driver    = md_driver#(ITEM_DRIVE)::type_id::create("driver", this) ;
		end

	endfunction : build_phase
	
		
	virtual function void connect_phase(uvm_phase phase);
		md_vif vif ;
		super.connect_phase(phase);
		
        if( (uvm_config_db#(md_vif)::get(this, "", "vif", vif)) == 0 ) begin
			`uvm_fatal("MD_NO_VIF", "Couldn't get the MD virtual interface from the database.")
		end
		else begin  // if the virtual interface is retrieved succufully (get methode returned '1' ) from db -> vif.
			agent_config.set_vif(vif);
		end

		if(agent_config.get_active_passive() == UVM_ACTIVE) begin
			driver.seq_item_port.connect(sequencer.seq_item_export) ;
			driver.agent_config = agent_config ;
		end
	
	endfunction : connect_phase


	virtual function void handle_reset(uvm_phase phase);
		uvm_component children[$] ;
		
		get_children(children) ;
		foreach (children[idx]) begin
			md_reset_handler reset_handler ;
			
			// Call handle reset of each child that implemenets the md_reset_handler interface.
			if($cast(reset_handler, children[idx])) begin
				reset_handler.handle_reset(phase) ;
			end 
		end
	endfunction : handle_reset


	// Reset handling:
	virtual task wait_reset_start();
		agent_config.wait_reset_start() ;
	endtask : wait_reset_start
    
	virtual task wait_reset_end();
		agent_config.wait_reset_end() ;
	endtask : wait_reset_end


	virtual task run_phase(uvm_phase phase) ;
		forever begin
			wait_reset_start(); 
			handle_reset(phase) ;
			wait_reset_end() ;
		end
	endtask : run_phase    


endclass : md_agent


`endif