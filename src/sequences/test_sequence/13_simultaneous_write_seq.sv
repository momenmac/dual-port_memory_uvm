class simultaneous_write_seq extends memory_virtual_sequence;
    `uvm_object_utils(simultaneous_write_seq)

    read_all_mem_seq read_all_mem_seq_a;

    function new(string name = "simultaneous_write_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = write_seq::type_id::create("write_seq_a");
        mem_sequence_b = write_seq::type_id::create("write_seq_b");
        read_all_mem_seq_a = read_all_mem_seq::type_id::create("read_all_mem_seq_a");
    endtask : pre_start

    virtual task body();
        fork
        repeat (num) begin
            mem_sequence_a.start(p_sequencer.mem_sequencer_a);
        end
        repeat (num) begin
            mem_sequence_b.start(p_sequencer.mem_sequencer_b);
        end
        join
        read_all_mem_seq_a.start(p_sequencer.mem_sequencer_a);
    endtask : body
endclass : simultaneous_write_seq