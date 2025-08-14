class back_to_back_writes_b_seq extends memory_virtual_sequence;
    `uvm_object_utils(back_to_back_writes_b_seq)

    function new(string name = "back_to_back_writes_b_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_b = write_seq::type_id::create("write_seq_b");
        mem_sequence_b.same_delay = 1;
    endtask : pre_start

    virtual task body();

        repeat (num) begin
            mem_sequence_b.current_delay = 0;
            mem_sequence_b.start(p_sequencer.mem_sequencer_b);
        end
    endtask : body
endclass : back_to_back_writes_b_seq