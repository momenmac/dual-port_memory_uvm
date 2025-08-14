class back_to_back_reads_seq extends memory_virtual_sequence;
    `uvm_object_utils(back_to_back_reads_seq)

    fill_mem_seq fill_mem_seq_inst;


    function new(string name = "back_to_back_reads_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = read_seq::type_id::create("read_seq_a");
        mem_sequence_b = read_seq::type_id::create("read_seq_b");
        fill_mem_seq_inst = fill_mem_seq::type_id::create("fill_mem_seq_inst");
        mem_sequence_b.same_delay = 1;
        mem_sequence_a.same_delay = 1;
    endtask : pre_start

    virtual task body();
        fill_mem_seq_inst.start(p_sequencer.mem_sequencer_a);
        mem_sequence_a.current_delay = 0;
        mem_sequence_b.current_delay = mem_sequence_a.current_delay;
        repeat (num) begin
            fork
                mem_sequence_a.start(p_sequencer.mem_sequencer_a);
                mem_sequence_b.start(p_sequencer.mem_sequencer_b);
            join
        end
    endtask : body
endclass : back_to_back_reads_seq