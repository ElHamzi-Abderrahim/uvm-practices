`ifndef APB_COVERAGE_SV
`define APB_COVERAGE_SV

// + Methode-2: MACRO to create an implementation port with a name "uvm_analysis_imp" postfixed with "_item" => "uvm_analysis_imp_item"  
`uvm_analysis_imp_decl(_item)

virtual class apb_cover_index_wrapper_base extends uvm_component ;
    // This class is defined as virtual (=> cannot be instanciated), 
    //  which will be used to iterate through its childrens (apb_cover_index_wrapper instances)    
    
    function new (string name="", uvm_component parent);
        super.new(name, parent) ;
    endfunction : new

    // Pure virtual functions: 
    pure virtual function void sample(int unsigned value) ;
    pure virtual function string coverage2string() ;

endclass : apb_cover_index_wrapper_base


`ifdef COVERAGE_SUPPORTED
class apb_cover_index_wrapper  #(int unsigned MAX_VALUE_PLUS_1 = 16) extends apb_cover_index_wrapper_base ;
    
    `uvm_component_param_utils(apb_cover_index_wrapper  #(MAX_VALUE_PLUS_1) ) 


    covergroup cover_index with function sample (int unsigned value);
        option.per_instance = 1 ;

        index : coverpoint value {
            option.comment = "Index";
            // Bins
            bins values[MAX_VALUE_PLUS_1] = {[0:MAX_VALUE_PLUS_1-1]} ;
        }
    endgroup


    function new(string name = "", uvm_component parent);
        super.new(name, parent) ;

        cover_index = new() ;
        cover_index.set_inst_name($sformatf("%s_%s", get_full_name(), "Cover Index")) ;
    endfunction : new
 
    
    virtual function void sample(int unsigned value);
        cover_index.sample(value) ;
    endfunction : sample


    virtual function string coverage2string();
        string result = {
            $sformatf("\n cover_index      :  %03.2f %%", cover_index.get_inst_coverage()) ,
            $sformatf("\n   - index        :  %03.2f %%", cover_index.index.get_inst_coverage())
        } ;

        return result ;
    endfunction : coverage2string

endclass : apb_cover_index_wrapper 

`endif // `ifdef COVERAGE_SUPPORTED



class apb_coverage extends uvm_component ;

    `uvm_component_utils(apb_coverage) 

    // Port for reveiving the collected item
    // + Methode-1: Analysis export TLM Handler to capture the broadcasted transaction by "uvm_analysis_port", in our case the TLM-port of apb_monitor
    // uvm_analysis_imp #(apb_item_monitor, apb_coverage) apb_analysis_export; 

    // + Methode-2: Port for receiving the collected item 
    uvm_analysis_imp_item #(apb_item_monitor, apb_coverage) port_item ;

    apb_agent_config agent_config ;

`ifdef COVERAGE_SUPPORTED
    
    // Wrapper over the coverage group covering the inidices of the PADDR signal 
    // for the bits of PADDR that has been 0
    apb_cover_index_wrapper#(`APB_MAX_ADDRESS_WIDTH) wrap_cov_addr_0 ;
    
    // Wrapper over the coverage group covering the inidices of the PADDR signal 
    // for the bits of PADDR that has been 1
    apb_cover_index_wrapper#(`APB_MAX_ADDRESS_WIDTH) wrap_cov_addr_1 ;
    
    
    // Wrapper over the coverage group covering the inidices of the PWDATA signal 
    // for the bits of PWDATA that has been 0
    apb_cover_index_wrapper#(`APB_MAX_DATA_WIDTH) wrap_cov_wr_data_0 ;
    
    // Wrapper over the coverage group covering the inidices of the PWDATA signal 
    // for the bits of PWDATA that has been 1
    apb_cover_index_wrapper#(`APB_MAX_DATA_WIDTH) wrap_cov_wr_data_1 ;
    
    
    // Wrapper over the coverage group covering the inidices of the PRDATA signal 
    // for the bits of PRDATA that has been 0
    apb_cover_index_wrapper#(`APB_MAX_DATA_WIDTH) wrap_cov_rd_data_0 ;
    
    // Wrapper over the coverage group covering the inidices of the PRDATA signal 
    // for the bits of PRDATA that has been 1
    apb_cover_index_wrapper#(`APB_MAX_DATA_WIDTH) wrap_cov_rd_data_1 ;
    

    // EXPECTED ERRORS when using the free version of ModelSim, due to Coverage functionalities that are not supported
    covergroup cover_item with function sample(apb_item_monitor item);
        option.per_instance = 1 ;

        direction : coverpoint item.dir {
            option.comment = "Direction of the APB access" ;
        }

        response : coverpoint item.response {
            option.comment = "Response of the APB access" ;
        }

        
        length : coverpoint item.length {
            option.comment = "Length of the APB access" ;

            // Bins
            bins length_eq_2      = {2} ;
            bins length_le_10[8]  = {[3:10]} ;
            bins length_gt_10     = {[11:$]} ;
        }

        
        prev_item_delay : coverpoint item.prev_item_delay {
            option.comment = "Delay between two consecutive APB accesses" ;

            // Bins
            bins back2back      = {0} ;
            bins delay_le_5[5]  = {[1:5]} ;
            bins dealy_gt_6     = {[6:$]} ;
        }


        response_x_direction : cross response, direction ;


        trans_direction : coverpoint item.dir{
            option.comment = "Transition of APB direction" ;
            bins direction_trans[] = (APB_WRITE, APB_READ => APB_WRITE, APB_READ) ;
        }        
    
    endgroup // cover_item


    covergroup cover_reset with function sample(bit psel);
        option.per_instance = 1 ;

        access_ongoing : coverpoint psel {
            option.comment = "An APB access was ongoing at reset" ;
        }
    endgroup // cover_reset

`endif // `ifdef COVERAGE_SUPPORTED


    function new(string name="", uvm_component parent);
        super.new(name, parent);

`ifdef COVERAGE_SUPPORTED
        cover_item  = new();
        cover_item.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_item")) ;
        
        cover_reset = new();
        cover_reset.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_reset")) ;
`endif // COVERAGE_SUPPORTED

        // apb_analysis_export = new("apb_analysis_export", this) ;
        port_item = new("port_item", this) ;

    endfunction : new

`ifdef COVERAGE_SUPPORTED
    // NOTE: This is function is used to show coverage persentage when using EDAPlayground Platform for simulation.
    virtual function string coverage2string();
        string result = {
            $sformatf("\n cover_item     :  %03.2f %%", cover_item.get_inst_coverage()) ,
            $sformatf("\n   - direction             :  %03.2f %%", cover_item.direction.get_inst_coverage()),
          $sformatf("\n   - response              :  %03.2f %%", cover_item.response.get_inst_coverage()),
            $sformatf("\n   - length                :  %03.2f %%", cover_item.length.get_inst_coverage()),
            $sformatf("\n   - prev_item_delay       :  %03.2f %%", cover_item.prev_item_delay.get_inst_coverage()),
            $sformatf("\n   - response_x_direction  :  %03.2f %%", cover_item.response_x_direction.get_inst_coverage()),
            $sformatf("\n"),
            $sformatf("\n cover_re       :  %03.2f %%", cover_reset.get_inst_coverage()),
            $sformatf("\n   - access_ongoing       :  %03.2f %%", cover_reset.access_ongoing.get_inst_coverage())
        } ;

        // Create a queue of children
        uvm_component children[$] ;

        // Get queue of all children instantiated under current component (apb_coverage component), not nested
        get_children(children) ; 


        foreach(children[indx]) begin
            apb_cover_index_wrapper_base wrapper ;
            // NOTE: WITHOUT the base class "apb_...index_wrapper_base", it will be difficult to iterate through 
            //       all the "apb_.._index_wrapper" instances, due to each of them is craeted with a paramter  
            //       which leads a completely different class type from one to another, and in order to iterate 
            //       through them it is needed to cite all combinations of these instances 
            // Solution: Is to create parent class that is not parametrized and extend from it that parametrized
            //       class.
            // REF: https://verificationacademy.com/forums/t/casting-to-a-parametrized-type-with-different-parameter-values/28831/2
            //       > dave_59 answer.
            
            if($cast(wrapper, children[indx])) begin
                result = $sformatf("%0s\n\nChild component: %0s%0s", result, wrapper.get_name(), wrapper.coverage2string() ) ;
            end
        end // foreach

        return result ;
    
    endfunction : coverage2string


`endif // `ifdef COVERAGE_SUPPORTED



    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase) ;
`ifdef COVERAGE_SUPPORTED
        wrap_cov_addr_0         = apb_cover_index_wrapper#(`APB_MAX_ADDRESS_WIDTH)::type_id::create("wrap_cov_addr_0", this);
        wrap_cov_addr_1         = apb_cover_index_wrapper#(`APB_MAX_ADDRESS_WIDTH)::type_id::create("wrap_cov_addr_1", this);
        wrap_cov_wr_data_0      = apb_cover_index_wrapper#(`APB_MAX_DATA_WIDTH)::type_id::create("wrap_cov_wr_data_0", this);
        wrap_cov_wr_data_1      = apb_cover_index_wrapper#(`APB_MAX_DATA_WIDTH)::type_id::create("wrap_cov_wr_data_1", this);
        wrap_cov_rd_data_0      = apb_cover_index_wrapper#(`APB_MAX_DATA_WIDTH)::type_id::create("wrap_cov_rd_data_0", this);
        wrap_cov_rd_data_1      = apb_cover_index_wrapper#(`APB_MAX_DATA_WIDTH)::type_id::create("wrap_cov_rd_data_1", this);
`endif // `ifdef COVERAGE_SUPPORTED
    
    endfunction : build_phase


    virtual task run_phase(uvm_phase phase);
        apb_vif vif = agent_config.get_vif() ;
`ifdef COVERAGE_SUPPORTED
        forever begin
            @(negedge vif.presetn) ;
            cover_reset.sample(vif.psel) ;
        end
`endif // `ifdef COVERAGE_SUPPORTED        
    endtask : run_phase



    // + Methode-1: Implementation of the write() methode of "apb_analysis_export" associated with "uvm_analysis_port" (the API)
    // virtual function void write(apb_item_monitor item);
    //     // ...
    // endfunction : write


    // + Methode-2: Implementation of the write() associated with "port_item"
    //      NOTE: the methode name should also be postfixed with "_item"
    virtual function void write_item(apb_item_monitor item) ;
`ifdef COVERAGE_SUPPORTED
        cover_item.sample(item) ;
        $display("DEBUG: %s", $sformatf("Coverage: %0s", coverage2string())) ;

        for(int i = 0; i < `APB_MAX_ADDRESS_WIDTH; i++) begin
            if(item.address[i]) begin
                wrap_cov_addr_1.sample(i);
            end else begin
                wrap_cov_addr_0.sample(i);
            end
        end

        for(int i = 0; i < `APB_MAX_DATA_WIDTH; i++) begin
            case(item.dir) 
                APB_WRITE : begin
                    if(item.data[i]) begin
                        wrap_cov_wr_data_1.sample(i);
                    end else begin
                        wrap_cov_wr_data_0.sample(i);
                    end     
                end 

                APB_READ : begin
                    if(item.data[i]) begin
                        wrap_cov_rd_data_1.sample(i);
                    end else begin
                        wrap_cov_rd_data_0.sample(i);
                    end     
                end  

                default :
                    `uvm_error("ALGORITHM ISSUE", $sformatf("Current version of the code does not support item.dir: %0s", item.dir.name()))

            endcase
        end

`endif // `ifdef COVERAGE_SUPPORTED

    endfunction : write_item


endclass : apb_coverage

`endif // `ifndef APB_COVERAGE_SV
