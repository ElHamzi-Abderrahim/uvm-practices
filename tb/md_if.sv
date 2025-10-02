`ifndef MD_IF_SV
`define MD_IF_SV 

interface md_if#(int unsigned DATA_WIDTH = 32)(input clk);
    
    // Width of the offset of the signal
    localparam OFFSET_WIDTH = $clog2(DATA_WIDTH/8) < 1 ? 1 : $clog2(DATA_WIDTH/8) ;

    // Width of the size signal
    localparam SIZE_WIDTH = $clog2(DATA_WIDTH/8) + 1 ;

    logic reset_n;

    logic valid ;
    
    logic [DATA_WIDTH-1:0]    data ;
    
    logic [OFFSET_WIDTH-1:0]  offset ;
    
    logic [SIZE_WIDTH-1:0]    size ;

    logic ready ;    
    
    logic err ;

    bit 	has_checks ;

    initial begin
        has_checks = 1 ;
    end


endinterface


`endif
