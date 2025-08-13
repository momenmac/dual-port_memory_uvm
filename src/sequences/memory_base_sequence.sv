class memory_base_sequence extends uvm_sequence #(memory_transaction);
    `uvm_object_utils(memory_base_sequence)
    
    uvm_reg_map map;

    uvm_status_e status;
    memory_transaction tr;

    memory_ral_model ral_model;
    virtual memory_interface mem_if_inst;
    memory_virtual_sequencer p_virtual_sequencer;

    int current_addr;
    logic [`DATA_WIDTH-1 : 0] written_data;
    logic [`DATA_WIDTH-1 : 0]  read_data;
    bit same_address;

    function new(string name = "memory_base_sequence");
        super.new(name);
        current_addr = $urandom_range(0,`MEMORY_DEPTH-1);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        
        if (!uvm_config_db#(virtual memory_interface)::get(m_sequencer, "", "mem_if_inst", mem_if_inst)) 
            `uvm_fatal("MEM_IF", "Memory interface not found in config DB")
        
        if (!uvm_config_db#(memory_ral_model)::get(m_sequencer, "", "ral_model", ral_model)) 
            `uvm_fatal("RAL_MODEL", "RAL model not found in config DB")
        
        if (!uvm_config_db#(memory_virtual_sequencer)::get(m_sequencer, "", "virtual_sequencer", p_virtual_sequencer)) 
            `uvm_fatal("BASE_SEQ", "Virtual sequencer not found - put port functionality disabled")
    endtask : pre_start

    virtual task pre_body();
        `uvm_create(tr)
    endtask : pre_body

    virtual task body();
        randomize_transaction();
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
        tr.op = `WRITE_OP;
        `uvm_info("WRITE_SEQ", tr.convert2string(), UVM_HIGH);
        written_data = tr.data;
        if(same_address) 
            tr.addr = current_addr;
        current_addr = tr.addr;
      	ral_model.mem.write(status, tr.addr, tr.data, .map(map));
        if (status != UVM_IS_OK) 
            `uvm_error("RAL_SEQ", $sformatf("RAL write failed with status: %s", status.name()))
    endtask : write_mem

    virtual task read_mem();
        tr.op = `READ_OP;
        `uvm_info("READ_SEQ", tr.convert2string(), UVM_HIGH);
        if(same_address) 
            tr.addr = current_addr;
        current_addr = tr.addr;
      	ral_model.mem.read(status, tr.addr, read_data, .map(map));
        if (status != UVM_IS_OK) 
            `uvm_error("RAL_SEQ", $sformatf("RAL read failed with status: %s", status.name()))
    endtask : read_mem

    virtual task poke_mem();
        `uvm_info("POKE_SEQ", $sformatf("Poking memory at address %0h with data %0h", tr.addr, tr.data), UVM_HIGH);
        written_data = tr.data;
        if(same_address)
            tr.addr = current_addr;
        current_addr = tr.addr;
        ral_model.mem.poke(status, tr.addr, tr.data);
        p_virtual_sequencer.put_to_scoreboard(tr);
        if (status != UVM_IS_OK) 
            `uvm_error("RAL_SEQ", $sformatf("RAL poke failed with status: %s", status.name()))
    endtask : poke_mem

    virtual task peek_mem();
        `uvm_info("PEEK_SEQ", $sformatf("Peeking memory at address %0h", tr.addr), UVM_HIGH);
        if(same_address) 
            tr.addr = current_addr;
        current_addr = tr.addr;
        ral_model.mem.peek(status, tr.addr, read_data);
        if (status != UVM_IS_OK) 
            `uvm_error("RAL_SEQ", $sformatf("RAL peek failed with status: %s", status.name()))
    endtask : peek_mem

    virtual task wait_clocks(int num_clocks);
        `uvm_info("MEMORY_BASE_SEQ", $sformatf("Waiting for %0d clock cycles", num_clocks), UVM_DEBUG);
        repeat(num_clocks) @(posedge mem_if_inst.clk);
    endtask : wait_clocks

    virtual task reset_memory();
        repeat ($urandom_range(1, 7)) @(posedge mem_if_inst.clk);
        mem_if_inst.rstn = 1'b0;
        repeat ($urandom_range(5, 15)) @(posedge mem_if_inst.clk);
        mem_if_inst.rstn = 1'b1;
        repeat ($urandom_range(0, 15)) @(posedge mem_if_inst.clk);
        `uvm_info("BASE_TEST", "Reset completed", UVM_HIGH);
    endtask : reset_memory
endclass : memory_base_sequence