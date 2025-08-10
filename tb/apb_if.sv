`ifndef APB_IF_SV
`define APB_IF_SV
	
	`ifndef APB_MAX_ADDRESS_WIDTH
		`define APB_MAX_ADDRESS_WIDTH 16
	`endif

	`ifndef APB_MAX_DATA_WIDTH
		`define APB_MAX_DATA_WIDTH 32
	`endif

	interface apb_if 
      #(parameter APB_MAX_ADDRESS_WIDTH = `APB_MAX_ADDRESS_WIDTH, APB_MAX_DATA_WIDTH = `APB_MAX_DATA_WIDTH) 
      (input pclk);
  		logic 								presetn;
		logic 								psel;
		logic 								penable;
      	logic 								pwrite ;
  		logic [APB_MAX_ADDRESS_WIDTH-1:0] 	paddr;
  		logic [APB_MAX_DATA_WIDTH-1	  :0] 	pwdata;
    	logic 								pready;
  		logic [APB_MAX_DATA_WIDTH-1:0] 		prdata;
  		logic 								pslverr;

		bit 	has_checks ;

		initial begin
			has_checks = 1 ;
		end


		// Setup phase sequence
		sequence setup_phase_s ;
			(psel == 1) && ( ($past(psel) == 0) || (($past(psel) == 1) && ($past(pready) == 1)) ) ; 
		endsequence

		// Access phase sequence
		sequence access_phase_s ; 
			(psel == 1) && (penable == 1) ;
		endsequence


        `ifdef ASSERTIONS_SUPPORTED
		/**************************************************************************/
		/* RULE #1: PENABLE must be asserted in the second cycle of the transfer  */
		/**************************************************************************/
		/* NOTE: "Assertions" are not support by the free version of ModelSim :-( */
		/**************************************************************************/
		
		// - PENABLE is deasserted in the setup phase 
		property penable_at_setup_phase_p;
			@(posedge pclk) disable iff (!presetn || !has_checks) // Don't check the property in reset phase (presetn == 0) and if checker is not enabled (has_checks == 0)
			setup_phase_s |-> (penable == 0) ; // s1 |-> s2: (Overlapped implication) if there is a match of s1, s2 is evaluated on the same clock tick.
 		endproperty

		PENABLE_AT_SETUP_PHASE_A : assert property(penable_at_setup_phase_p) else
			$error("PENALBE at \'Setup Phase\' is not equal to 0.") ;

		// - PENABLE is assreted after one cycle of the setup phase 
		property penable_at_entering_access_phase_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			setup_phase_s |=> (penable == 1) ; // s1 |=> s2 : (Non-Overlapped implication) if there is a match of s1, s2 is evaluated on the next clock tick.
 		endproperty

		PENABLE_AT_ENTERING_ACCESS_PHASE_A : assert property(penable_at_entering_access_phase_p) else
			$error("PENALBE at \'Access Phase\' is not equal to 1.") ;
		/**************************************************************************/


		/**************************************************************************/
		/* RULE #2: PENABLE must be deasserted at the end of the transfer         */
		/**************************************************************************/
		property penable_at_exiting_access_phase_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			access_phase_s and (pready == 1) |=> (penable == 0) ;
 		endproperty

		PENABLE_AT_EXITING_ACCESS_PHASE_A : assert property(penable_at_exiting_access_phase_p) else
			$error("PENALBE when exiting \'Access Phase\' is not equal to 0 .") ;
		/**************************************************************************/


		/**************************************************************************/
		/* RULE #3: Master driver signals must be remain stable at access phase   */
		/**************************************************************************/
		property penable_stable_at_access_phase_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			access_phase_s |-> (penable == 1) ; // In access phase PENALBE should have stable value of "1"
 		endproperty

		PENABLE_STABLE_ACCESS_PHASE_A : assert property(penable_stable_at_access_phase_p) else
			$error("PENALBE was not stable druing \'Access Phase\' .") ;


		property pwrite_stable_at_access_phase_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			access_phase_s |-> $stable(pwrite) ; // $stable() is used rather than "0" or "1" because we can't know if it's a Read or Write operation
 		endproperty

		PWRITE_STABLE_ACCESS_PHASE_A : assert property(pwrite_stable_at_access_phase_p) else
			$error("PWRITE was not stable druing \'Access Phase\' .") ;


		property paddr_stable_at_access_phase_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			access_phase_s |-> $stable(paddr) ;
 		endproperty

		PADDR_STABLE_ACCESS_PHASE_A : assert property(paddr_stable_at_access_phase_p) else
			$error("PADDR was not stable druing \'Access Phase\' .") ;


		property pwdata_stable_at_access_phase_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			access_phase_s and (pwdata == 1) |-> $stable(pwdata) ;
 		endproperty

		PWDATA_STABLE_ACCESS_PHASE_A : assert property(pwdata_stable_at_access_phase_p) else
			$error("PWDATA was not stable druing \'Access Phase\' .") ;
		/**************************************************************************/ 


		/**************************************************************************/
		/* RULE #4: APB signals can not have unknown values (x, z)                */
		/**************************************************************************/
		property unknown_value_psel_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			$isunknown(psel) == 0 ;
 		endproperty

		UNKNOWN_VALUE_PSEL_A : assert property(unknown_value_psel_p) else
			$error("Detected unknown value for APB signal PSEL .") ;


		property unknown_value_penalbe_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			(psel == 1) |-> $isunknown(penable) == 0 ;
 		endproperty

		UNKNOWN_VALUE_PENABLE_A : assert property(unknown_value_penalbe_p) else
			$error("Detected unknown value for APB signal PENABLE .") ;


		property unknown_value_pddr_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			(psel == 1) |-> $isunknown(paddr) == 0 ;
 		endproperty

		UNKNOWN_VALUE_PADDR_A : assert property(unknown_value_pddr_p) else
			$error("Detected unknown value for APB signal PADDR .") ;


		property unknown_value_pwrite_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			(psel == 1) |-> $isunknown(pwrite) == 0 ;
 		endproperty

		UNKNOWN_VALUE_PWRITE_A : assert property(unknown_value_pwrite_p) else
			$error("Detected unknown value for APB signal PWRITE .") ;


		property unknown_value_pwdata_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			(psel == 1) && (pwrite == 1) |-> $isunknown(pwdata) == 0 ;
 		endproperty

		UNKNOWN_VALUE_PWDATA_A : assert property(unknown_value_pwdata_p) else
			$error("Detected unknown value for APB signal PWDATA .") ;


		property unknown_value_prdata_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			(psel == 1) && (pwrite == 1) && (pready == 1) && (pslverr == 0)  |-> $isunknown(prdata) == 0 ;
 		endproperty

		UNKNOWN_VALUE_PRDATA_A : assert property(unknown_value_prdata_p) else
			$error("Detected unknown value for APB signal PRDATA .") ;


		property unknown_value_pready_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			(psel == 1) |-> $isunknown(pready) == 0 ;
 		endproperty

		UNKNOWN_VALUE_PREADY_A : assert property(unknown_value_pready_p) else
			$error("Detected unknown value for APB signal PREADY .") ;

	
		property unknown_value_pslverr_p;
			@(posedge pclk) disable iff (!presetn || !has_checks)
			(psel == 1) && (pready == 1) |-> $isunknown(pslverr) == 0 ;
 		endproperty

		UNKNOWN_VALUE_PSLVERR_A : assert property(unknown_value_pslverr_p) else
			$error("Detected unknown value for APB signal PSLVERR .") ;
		/**************************************************************************/

		`endif // `ifdef ASSERTIONS_SUPPORTED
    endinterface
	
`endif // `ifndef APB_IF_SV