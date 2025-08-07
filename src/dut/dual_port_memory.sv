`define DATA_WIDTH 32
`define ADDR_WIDTH 16
`define MEM_DEPTH  49152

module MEM(
  input clk,
  input rstn,
  input valid,
  input op,
  input [`DATA_WIDTH-1:0] wr_data,
  input [`ADDR_WIDTH-1:0] addr,
  output reg [`DATA_WIDTH-1:0] rd_data
);
  
  reg[`DATA_WIDTH-1:0] mem[`MEM_DEPTH];

  always @(negedge rstn) begin
    foreach(mem[idx]) mem[idx] <= 0;
  end
  
  assign rd_data =  mem[addr];
  
  always @(posedge clk) begin
    if(valid && rstn) begin
      if(op && addr<`MEM_DEPTH) begin
        mem[addr] <= wr_data;
      end
    end
  end
  
endmodule

module DP_MEM(
  input clk,
  input rstn,
  input valid_a,
  input op_a,
  input [`DATA_WIDTH-1:0] wr_data_a,
  input [`ADDR_WIDTH-1:0] addr_a,
  output [`DATA_WIDTH-1:0] rd_data_a,
  output ready_a,
  input valid_b,
  input op_b,
  input [`DATA_WIDTH-1:0] wr_data_b,
  input [`ADDR_WIDTH-1:0] addr_b,
  output [`DATA_WIDTH-1:0] rd_data_b,
  output ready_b
);
  
  reg port_select;
  wire selected_port;
  wire valid_muxed;
  wire op_muxed;
  wire [`DATA_WIDTH-1:0] wr_data_muxed;
  wire [`ADDR_WIDTH-1:0] addr_muxed;
  wire [`DATA_WIDTH-1:0] rd_data_mem;

  MEM mem_inst (.clk(clk),
                .rstn(rstn),
                .valid(valid_muxed),
                .op(op_muxed),
                .wr_data(wr_data_muxed),
                .addr(addr_muxed),
                .rd_data(rd_data_mem)
               );
  assign selected_port = valid_a && valid_b ? port_select : valid_b;
  
  assign valid_muxed   = ~selected_port ? valid_a   : valid_b;
  assign op_muxed      = ~selected_port ? op_a      : op_b;
  assign wr_data_muxed = ~selected_port ? wr_data_a : wr_data_b;
  assign addr_muxed    = ~selected_port ? addr_a    : addr_b;
  
  assign rd_data_a = (valid_b && op_b && (addr_a==addr_b)) ? wr_data_b : rd_data_mem;
  assign rd_data_b = (valid_a && op_a && (addr_a==addr_b)) ? wr_data_a : rd_data_mem;
  assign ready_a = !rstn ? 1'b1 : (valid_a &  selected_port ? 1'b0 : 1'b1);
  assign ready_b = !rstn ? 1'b1 : (valid_b & !selected_port ? 1'b0 : 1'b1);
  
  always @(negedge rstn) begin
    port_select <=0;
  end
  
  always @(posedge clk) begin
    port_select <= ~port_select;
  end
    
  
  
endmodule