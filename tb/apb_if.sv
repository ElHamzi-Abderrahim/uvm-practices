`ifndef APB_IF_SV
	`define APB_IF_SV
	
	interface apb_if 
      #(parameter APB_MAX_ADDRESS_WIDTH = 16, APB_MAX_DATA_WIDTH = 32) 
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
    endinterface
	
`endif