class read_collision_seq extends memory_virtual_sequence;
    `uvm_object_utils(read_collision_seq)

    fill_mem_seq fill_mem_sequence;


    function new(string name = "read_collision_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = read_seq::type_id::create("read_seq_a");
        mem_sequence_b = read_seq::type_id::create("read_seq_b");
        fill_mem_sequence = fill_mem_seq::type_id::create("fill_mem_sequence");
        mem_sequence_b.same_address = 1;
        mem_sequence_b.same_delay = 1;
        mem_sequence_a.same_address = 1;
        mem_sequence_a.same_delay = 1;
    endtask : pre_start

    virtual task body();
        fill_mem_sequence.start(p_sequencer.mem_sequencer_a);
        repeat (num) begin
            mem_sequence_a.current_addr = $urandom_range(0, `MEMORY_DEPTH-1);
            mem_sequence_a.current_delay = $urandom_range(1, 7);
            mem_sequence_b.current_delay = mem_sequence_a.current_delay;
            mem_sequence_b.current_addr = mem_sequence_a.current_addr;

            fork
                mem_sequence_a.start(p_sequencer.mem_sequencer_a);
                mem_sequence_b.start(p_sequencer.mem_sequencer_b);
            join
        end
    endtask : body
endclass : read_collision_seq