`include "memory_interface.sv"
`include "memory_pkg.sv"
module top_tb;
    logic clk;
    logic rstn;

    memory_interface mem_if_inst
    (
        .clk (clk),
        .rstn (rstn),
    );

    localparam CLK_PERIOD = 10;
    // always #(CLK_PERIOD/2) clk=~clk;

    initial begin
        $dumpfile("tb_memory_interface.vcd");
        $dumpvars(0, tb_memory_interface);
    end

    initial begin

    end

endmodule
