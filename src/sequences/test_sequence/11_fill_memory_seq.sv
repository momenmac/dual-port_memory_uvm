class fill_memory_seq extends memory_virtual_sequence;
    `uvm_object_utils(fill_memory_seq)

    read_all_mem_seq read_all_mem_seq_a;

    function new(string name = "fill_memory_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = write_seq::type_id::create("write_seq_a");
        read_all_mem_seq_a = read_all_mem_seq::type_id::create("read_all_mem_seq_a");
    endtask : pre_start

    virtual task body();
            mem_sequence_a.same_address = 1;
            for(int i = 0; i < `MEMORY_DEPTH; i++) begin
                mem_sequence_a.current_addr = i;
                mem_sequence_a.start(p_sequencer.mem_sequencer_a);
            end
            read_all_mem_seq_a.start(p_sequencer.mem_sequencer_a);
    endtask : body
endclass : fill_memory_seq