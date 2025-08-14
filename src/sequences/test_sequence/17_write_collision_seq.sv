class write_collision_seq extends memory_virtual_sequence;
    `uvm_object_utils(write_collision_seq)

    function new(string name = "write_collision_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = write_seq::type_id::create("write_seq_a");
        mem_sequence_b = write_seq::type_id::create("write_seq_b");
        mem_sequence_b.same_address = 1;
        mem_sequence_b.same_delay = 1;
        mem_sequence_a.same_address = 1;
        mem_sequence_a.same_delay = 1;
    endtask : pre_start

    virtual task body();

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
endclass : write_collision_seq