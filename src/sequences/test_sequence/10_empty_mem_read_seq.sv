class empty_mem_read_seq extends memory_virtual_sequence;
    `uvm_object_utils(empty_mem_read_seq)

    read_all_mem_seq read_all_mem_seq_a;

    function new(string name = "empty_mem_read_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = read_seq::type_id::create("read_seq_a");
        read_all_mem_seq_a = read_all_mem_seq::type_id::create("read_all_mem_seq_a");
    endtask : pre_start

    virtual task body();
            read_all_mem_seq_a.start(p_sequencer.mem_sequencer_a);
            mem_sequence_a.same_address = 1;
            for(int i = 0; i < `MEMORY_DEPTH; i++) begin
                mem_sequence_a.current_addr = i;
                mem_sequence_a.start(p_sequencer.mem_sequencer_a);
            end
    endtask : body
endclass : empty_mem_read_seq