class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    memory_env mem_env_inst;
    memory_virtual_sequence mem_vseq_inst;
    virtual memory_interface mem_if_a;
    virtual memory_interface mem_if_b;
    string command_line_txn;
    int num_txn = -1;
    int num_txn_temp;


    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);

    endfunction : new


    virtual function void build_phase(uvm_phase phase);
        uvm_cmdline_processor clp; 
        super.build_phase(phase);

        mem_env_inst = memory_env::type_id::create("mem_env_inst", this);

        mem_vseq_inst = memory_virtual_sequence::type_id::create("mem_vseq_inst", this);
        if(!uvm_config_db#(virtual memory_interface)::get(this,"", "mem_if_a", mem_if_a))
            `uvm_fatal("MEM_IF_A", "Memory Interface A not found")
        uvm_config_db#(virtual memory_interface)::set(this, "mem_env_inst.mem_agent_a.*", "mem_if_inst", mem_if_a);

        if(!uvm_config_db#(virtual memory_interface)::get(this,"", "mem_if_b", mem_if_b))
            `uvm_fatal("MEM_IF_B", "Memory Interface B not found")
        uvm_config_db#(virtual memory_interface)::set(this, "mem_env_inst.mem_agent_b.*", "mem_if_inst", mem_if_b);

        uvm_config_db#(virtual memory_interface)::set(this, "*sequencer*", "mem_if_inst", mem_if_a);
        uvm_config_db#(virtual memory_interface)::set(this, "*virtual_sequencer*", "mem_if_inst", mem_if_a);

        clp = uvm_cmdline_processor::get_inst();
        if (clp.get_arg_value("+NUM_TXN=", command_line_txn)) begin
            if ($sscanf(command_line_txn, "%d", num_txn_temp))
                num_txn = num_txn_temp;
        end

        if (num_txn == -1)
            void'(mem_vseq_inst.randomize());
        else
            mem_vseq_inst.num = num_txn;

    endfunction : build_phase
    

    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this);
        mem_if_a.rstn = 1'b0;
        repeat ($urandom_range(5, 15)) @(posedge mem_if_a.clk);
        mem_if_a.rstn = 1'b1;
        repeat ($urandom_range(0, 15)) @(posedge mem_if_a.clk);
        `uvm_info("BASE_TEST", "Reset completed", UVM_HIGH);
        phase.drop_objection(this);
    endtask : reset_phase

    virtual task main_phase(uvm_phase phase);
        super.main_phase(phase);
        phase.raise_objection(this);
        `uvm_info("base_test", "Starting memory base sequence", UVM_MEDIUM);
        mem_vseq_inst.ral_model = mem_env_inst.reg_env_inst.ral_model;
        mem_vseq_inst.start(mem_env_inst.mem_virtual_sequencer_inst);
        #200;
        phase.drop_objection(this);
    endtask : main_phase

endclass : base_test