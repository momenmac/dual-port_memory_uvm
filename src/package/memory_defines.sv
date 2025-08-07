//=============================================================================
// File: memory_defines.sv
// Description: Global defines and parameters for dual port memory UVM testbench
//=============================================================================

`ifndef MEMORY_DEFINES_SV
`define MEMORY_DEFINES_SV

// Memory Configuration Parameters
`define DATA_WIDTH      32
`define ADDR_WIDTH      16
`define MEMORY_DEPTH    49152
`define NUM_PORTS       2

// Port Selection
`define PORT_A          2'b00
`define PORT_B          2'b01
`define PORT_BOTH       2'b10

// Operation Types
`define READ_OP         1'b0
`define WRITE_OP        1'b1

// Address Ranges
`define MIN_ADDR        0
`define MAX_ADDR        (`MEMORY_DEPTH - 1)

// Test Configuration
`define DEFAULT_NUM_TRANS   100

// Timing Parameters
`define CLK_PERIOD      10ns
`define RESET_TIME      100ns

// Coverage Parameters
`define COV_BINS_ADDR   16
`define COV_BINS_DATA   8

// Debug and Verbosity
`define DEBUG_ENABLE    1
`define TRACE_ENABLE    0

`endif // MEMORY_DEFINES_SV
