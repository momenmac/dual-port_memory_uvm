class write_b_seq extends memory_virtual_sequence;
    `uvm_object_utils(write_b_seq)

    function new(string name = "write_b_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_b = write_seq::type_id::create("write_seq_b");

    endtask : pre_start

    virtual task body();
        repeat (num) begin
            mem_sequence_b.start(p_sequencer.mem_sequencer_b);
        end
    endtask : body
endclass : write_b_seq