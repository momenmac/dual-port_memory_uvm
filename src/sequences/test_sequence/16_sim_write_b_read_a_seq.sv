class sim_write_b_read_a_seq extends memory_virtual_sequence;
    `uvm_object_utils(sim_write_b_read_a_seq)

    function new(string name = "sim_write_b_read_a_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = read_seq::type_id::create("read_seq_a");
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
endclass : sim_write_b_read_a_seq