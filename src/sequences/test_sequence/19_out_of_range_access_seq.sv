class out_of_range_access_seq extends memory_virtual_sequence;
    `uvm_object_utils(out_of_range_access_seq)

    read_all_mem_seq read_all_mem_seq_a;

    function new(string name = "out_of_range_access_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = write_seq::type_id::create("write_seq_a");
        mem_sequence_b = write_seq::type_id::create("write_seq_b");
        read_all_mem_seq_a = read_all_mem_seq::type_id::create("read_all_mem_seq_a");
        mem_sequence_b.same_address = 1;
        mem_sequence_b.same_delay = 1;
        mem_sequence_a.same_address = 1;
        mem_sequence_a.same_delay = 1;
    endtask : pre_start

    virtual task body();
        repeat (num) begin
            mem_sequence_a.current_addr = $urandom_range(`MEMORY_DEPTH, 2** `ADDR_WIDTH - 1);
            mem_sequence_a.current_delay = $urandom_range(1, 7);
            mem_sequence_b.current_delay = mem_sequence_a.current_delay;
            mem_sequence_b.current_addr = mem_sequence_a.current_addr;
            if($urandom_range(0, 1))
                mem_sequence_a.start(p_sequencer.mem_sequencer_a);
            else
                mem_sequence_b.start(p_sequencer.mem_sequencer_b);
        end
        read_all_mem_seq_a.start(p_sequencer.mem_sequencer_a);
    endtask : body
endclass : out_of_range_access_seq