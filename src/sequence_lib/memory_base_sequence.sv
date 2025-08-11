class memory_base_sequence extends uvm_sequence #(memory_transaction);
    `uvm_object_utils(memory_base_sequence)
  
    int current_addr;
    virtual memory_interface mem_if_inst;

    function new(string name = "memory_base_sequence");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        if (!uvm_config_db#(virtual memory_interface)::get(m_sequencer, "", "mem_if_inst", mem_if_inst)) begin
            `uvm_fatal("MEM_IF", "Memory interface not found in sequence")
        end
    endtask : pre_start

    virtual task body();
        memory_transaction tr;

        `uvm_create(tr)
        `uvm_rand_send_with(tr,{op == `WRITE_OP;})
        current_addr = tr.addr;
        wait_clocks(tr.delay);

        `uvm_rand_send_with(tr,{op == `READ_OP; addr == current_addr;})
        wait_clocks(tr.delay);
  
    endtask : body

    virtual task wait_clocks(int num_clocks);
        `uvm_info("MEMORY_BASE_SEQ", $sformatf("Waiting for %0d clock cycles", num_clocks), UVM_DEBUG);
        repeat(num_clocks) @(posedge mem_if_inst.clk);
    endtask : wait_clocks
endclass : memory_base_sequence