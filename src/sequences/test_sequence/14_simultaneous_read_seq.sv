class simultaneous_read_seq extends memory_virtual_sequence;
    `uvm_object_utils(simultaneous_read_seq)

    fill_mem_seq fill_mem_sequence;

    function new(string name = "simultaneous_read_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = read_seq::type_id::create("read_seq_a");
        mem_sequence_b = read_seq::type_id::create("read_seq_b");
        fill_mem_sequence = fill_mem_seq::type_id::create("fill_mem_sequence");
    endtask : pre_start

    virtual task body();
        fill_mem_sequence.start(p_sequencer.mem_sequencer_a);
        fork
        repeat (num) begin
            mem_sequence_a.start(p_sequencer.mem_sequencer_a);
        end
        repeat (num) begin
            mem_sequence_b.start(p_sequencer.mem_sequencer_b);
        end
        join
    endtask : body
endclass : simultaneous_read_seq