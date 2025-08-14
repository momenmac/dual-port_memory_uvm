class back_to_back_writes_seq extends memory_virtual_sequence;
    `uvm_object_utils(back_to_back_writes_seq)

    function new(string name = "back_to_back_writes_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = write_seq::type_id::create("write_seq_a");
        mem_sequence_b = write_seq::type_id::create("write_seq_b");
        mem_sequence_b.same_delay = 1;
        mem_sequence_a.same_delay = 1;
    endtask : pre_start

    virtual task body();
        mem_sequence_a.current_delay = 0;
        mem_sequence_b.current_delay = mem_sequence_a.current_delay;
        repeat (num) begin
            fork
                mem_sequence_a.start(p_sequencer.mem_sequencer_a);
                mem_sequence_b.start(p_sequencer.mem_sequencer_b);
            join
        end
    endtask : body
endclass : back_to_back_writes_seq