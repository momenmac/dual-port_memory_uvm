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
//     `include "memory_subscriber.sv"
//     `include "memory_coverage.sv"


    // Include RAL components
    `include "memory_ral_model.sv"
    `include "memory_reg_adapter.sv"
    `include "memory_reg_predictor.sv"

    `include "memory_virtual_sequencer.sv"

    `include "cfg_info.sv"
	`include "reg_env.sv"
    `include "memory_scoreboard.sv"
    `include "memory_env.sv"

    
    // Include sequences
    `include "memory_base_sequence.sv"
    `include "memory_virtual_sequence.sv"
    
    // Include sequence library
    `include "fill_memory_sequence.sv"
    `include "memory_peek_sequence.sv"
    `include "memory_poke_sequence.sv"
    `include "memory_read_sequence.sv"
    `include "memory_reset_seq.sv"
    `include "memory_write_read_sequence.sv"
    `include "memory_write_sequence.sv"
    `include "read_all_memory_sequence.sv"
    
    // Include test sequences
    `include "01_write_a_seq.sv"
    `include "02_write_b_seq.sv"
    `include "03_read_a_seq.sv"
    `include "04_read_b_seq.sv"
    `include "05_write_read_a_seq.sv"
    `include "06_write_read_b_seq.sv"
    `include "07_write_a_read_b_seq.sv"
    `include "08_write_b_read_a_seq.sv"
    `include "09_write_same_address_seq.sv"
    `include "10_empty_mem_read_seq.sv"
    `include "11_fill_memory_seq.sv"
    `include "12_reset_behavior_seq.sv"
    `include "13_simultaneous_write_seq.sv"
    `include "14_simultaneous_read_seq.sv"
    `include "15_sim_write_a_read_b_seq.sv"
    `include "16_sim_write_b_read_a_seq.sv"
    `include "17_write_collision_seq.sv"
    `include "18_read_collision_seq.sv"
    `include "19_out_of_range_access_seq.sv"
    `include "20_back_to_back_writes_a_seq.sv"
    `include "21_back_to_back_writes_b_seq.sv"
    `include "22_back_to_back_writes_seq.sv"
    `include "23_back_to_back_reads_a_seq.sv"
    `include "24_back_to_back_reads_b_seq.sv"
    `include "25_back_to_back_reads_seq.sv"
    `include "26_back_to_back_transactions_seq.sv"
    
    // Include tests
    `include "memory_base_test.sv"
    `include "memory_ral_test.sv"
    `include "memory_basic_test.sv"
    `include "memory_random_test.sv"
    
    // Include test library
    `include "01_write_a_test.sv"
    `include "02_write_b_test.sv"
    `include "03_read_a_test.sv"
    `include "04_read_b_test.sv"
    `include "05_write_read_a.sv"
    `include "06_write_read_b.sv"
    `include "07_write_a_read_b.sv"
    `include "08_write_b_read_a.sv"
    `include "09_write_same_address_test.sv"
    `include "10_empty_mem_read_test.sv"
    `include "11_fill_memory_test.sv"
    `include "12_reset_behavior_test.sv"
    `include "13_simultaneous_test.sv"
    `include "14_simultaneous_read_test.sv"
    `include "15_sim_write_a_read_b_test.sv"
    `include "16_sim_write_b_read_a_test.sv"
    `include "17_write_collision_test.sv"
    `include "18_read_collision_test.sv"
    `include "19_out_of_range_access_test.sv"
    `include "20_back_to_back_writes_a_test.sv"
    `include "21_back_to_back_writes_b_test.sv"
    `include "22_back_to_back_writes_test.sv"
    `include "23_back_to_back_reads_a_test.sv"
    `include "24_back_to_back_reads_b_test.sv"
    `include "25_back_to_back_reads_test.sv"
    `include "26_back_to_back_transactions_test.sv"
    
endpackage : memory_pkg

`endif // MEMORY_PKG_SV