`ifndef APB_TYPES_SV
`define APB_TYPES_SV
	
	// Virtual interface type:
	typedef virtual apb_if apb_vif;

	// APB directions:
	typedef enum bit {APB_READ = 0, APB_WRITE = 1} apb_dir;
	
	// APB address:
	typedef bit [`APB_MAX_ADDRESS_WIDTH-1:0] apb_addr ;

	// APB data:
	typedef bit [`APB_MAX_DATA_WIDTH-1:0] apb_data ;

	// APB response:
	typedef enum bit {APB_OKAY = 0 , APB_ERR = 1} apb_response ;


`endif // `ifndef APB_TYPES_SV