`include "memory_interface.sv"
`include "memory_pkg.sv"
module top_tb;
    logic clk = 0;

    memory_interface mem_if_a (.clk (clk));
    memory_interface mem_if_b (.clk (clk));

    DP_MEM DP_MEMORY_INST (
        .clk(clk),
      	.rstn(mem_if_a.rstn),
        .valid_a(mem_if_a.valid),
        .op_a(mem_if_a.op),
        .wr_data_a(mem_if_a.wr_data),
        .addr_a(mem_if_a.addr),
        .rd_data_a(mem_if_a.rd_data),
        .ready_a(mem_if_a.ready),
        .valid_b(mem_if_b.valid),
        .op_b(mem_if_b.op),
        .wr_data_b(mem_if_b.wr_data),
        .addr_b(mem_if_b.addr),
        .rd_data_b(mem_if_b.rd_data),
        .ready_b(mem_if_b.ready)
    );

    always #5 clk=~clk;

    initial begin
      	uvm_config_db#(virtual memory_interface)::set(null, "uvm_test_top", "mem_if_a", mem_if_a);
        uvm_config_db#(virtual memory_interface)::set(null, "uvm_test_top", "mem_if_b", mem_if_b);
        uvm_config_db#(virtual memory_interface)::set(null, "uvm_test_top.*mem_scoreboard_inst", "vif", mem_if_a);
        run_test();
    end

    initial begin
        $dumpfile("tb_memory_interface.vcd");
      $dumpvars(0, top_tb);
    end

    initial begin

    end

endmodule
