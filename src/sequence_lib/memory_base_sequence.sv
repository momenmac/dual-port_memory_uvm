class memory_base_sequence extends uvm_sequence #(memory_transaction);
    `uvm_object_utils(memory_base_sequence)
  
    int current_addr;
    int written_data;
    uvm_status_e status;
    memory_transaction tr;
    virtual memory_interface mem_if_inst;
    memory_ral_model ral_model;
    logic [`DATA_WIDTH-1 : 0]  read_data;
    uvm_reg_map map;


    function new(string name = "memory_base_sequence");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        if (!uvm_config_db#(virtual memory_interface)::get(m_sequencer, "", "mem_if_inst", mem_if_inst)) begin
            `uvm_fatal("MEM_IF", "Memory interface not found in sequence")
        end
    endtask : pre_start

    virtual task pre_body();
        `uvm_create(tr)
    endtask : pre_body

    virtual task body();
        randomize_transaction();
        write_mem();
        wait_clocks(tr.delay);
        randomize_transaction();
        tr.addr = current_addr;
        read_mem();
        wait_clocks(tr.delay);

    endtask : body

    virtual task randomize_transaction();
        assert(tr.randomize()) else 
            `uvm_fatal("BASE_SEQ", "Failed to randomize memory_transaction");
    endtask : randomize_transaction

    virtual task write_mem();
        `uvm_info("WRITE_SEQ", tr.convert2string(), UVM_HIGH);
        current_addr = tr.addr;
        
      	ral_model.mem.write(status, tr.addr, tr.data, .map(map));
        if (status != UVM_IS_OK) 
            `uvm_error("RAL_SEQ", $sformatf("RAL write failed with status: %s", status.name()))
    endtask : write_mem

    virtual task read_mem();
        `uvm_info("READ_SEQ", tr.convert2string(), UVM_HIGH);
        current_addr = tr.addr;
      	ral_model.mem.read(status, tr.addr, read_data, .map(map));
        if (status != UVM_IS_OK) 
            `uvm_error("RAL_SEQ", $sformatf("RAL read failed with status: %s", status.name()))
    endtask : read_mem

    virtual task wait_clocks(int num_clocks);
        `uvm_info("MEMORY_BASE_SEQ", $sformatf("Waiting for %0d clock cycles", num_clocks), UVM_DEBUG);
        repeat(num_clocks) @(posedge mem_if_inst.clk);
    endtask : wait_clocks
endclass : memory_base_sequence