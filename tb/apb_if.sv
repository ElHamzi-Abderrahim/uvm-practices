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
    endinterface
	
`endif