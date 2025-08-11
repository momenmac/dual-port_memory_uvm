`ifndef MEMORY_PKG_SV
`define MEMORY_PKG_SV

// Include defines first
`include "memory_defines.sv"

package memory_pkg;
    
    // Import UVM library
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // Include all UVM components
    `include "memory_transaction.sv"
//     `include "memory_config.sv"
    `include "memory_sequencer.sv"
    `include "memory_driver.sv"
    `include "memory_monitor.sv"
    `include "memory_agent.sv"
    `include "memory_scoreboard.sv"
//     `include "memory_subscriber.sv"
//     `include "memory_coverage.sv"
    `include "memory_virtual_sequencer.sv"


    // Include RAL components
    `include "memory_ral_model.sv"
    `include "memory_reg_adapter.sv"
    `include "memory_reg_predictor.sv"

	`include "reg_env.sv"
    `include "memory_env.sv"

    
    // Include sequences
    `include "memory_base_sequence.sv"
    `include "memory_virtual_sequence.sv"
//     `include "memory_write_sequence.sv"
//     `include "memory_read_sequence.sv"
//     `include "memory_random_sequence.sv"
    
    // Include tests
    `include "memory_base_test.sv"
//     `include "memory_basic_test.sv"
//     `include "memory_random_test.sv"
    
endpackage : memory_pkg

`endif // MEMORY_PKG_SV