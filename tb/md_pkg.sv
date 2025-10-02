`ifndef MD_PKG_SV
`define MD_PKG_SV

    `include "md_if.sv"

    package md_pkg ;
        import uvm_pkg::* ;

        `include "md_agent_config.sv"
        `include "md_agent_config_slave.sv"
        `include "md_agent_config_master.sv"
        `include "md_reset_handler.sv"
        `include "md_agent.sv"
        `include "md_agent_slave.sv"
        `include "md_agent_master.sv"


    endpackage

`endif