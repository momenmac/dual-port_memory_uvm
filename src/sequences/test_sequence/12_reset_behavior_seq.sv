class reset_behavior_seq extends memory_virtual_sequence;
    `uvm_object_utils(reset_behavior_seq)
    
    fill_mem_seq fill_mem_seq_a;
    read_all_mem_seq read_all_mem_seq_a;
    memory_reset_seq reset_seq_a;

    function new(string name = "reset_behavior_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        fill_mem_seq_a = fill_mem_seq::type_id::create("fill_mem_seq_a");
        read_all_mem_seq_a = read_all_mem_seq::type_id::create("read_all_mem_seq_a");
        reset_seq_a = memory_reset_seq::type_id::create("reset_seq_a");
    endtask : pre_start

    virtual task body();
            fill_mem_seq_a.start(p_sequencer.mem_sequencer_a);
            reset_seq_a.start(p_sequencer.mem_sequencer_a);
            read_all_mem_seq_a.start(p_sequencer.mem_sequencer_a);
    endtask : body
endclass : reset_behavior_seq