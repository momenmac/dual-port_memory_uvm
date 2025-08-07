interface memory_interface (input clk, input rstn);
    logic [`DATA_WIDTH-1:0] wr_data;
    logic [`DATA_WIDTH-1:0] rd_data;
    logic [`ADDR_WIDTH-1:0] addr = 0;
    logic op = 0;
    logic valid = 0;
    logic ready;
endinterface : memory_interface