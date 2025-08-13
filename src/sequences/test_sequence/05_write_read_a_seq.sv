class write_read_a_seq extends memory_virtual_sequence;
    `uvm_object_utils(write_read_a_seq)

    function new(string name = "write_read_a_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = write_read_seq::type_id::create("write_read_seq_a");
    endtask : pre_start

    virtual task body();
        repeat (num) begin
            mem_sequence_a.start(p_sequencer.mem_sequencer_a);
        end
    endtask : body
endclass : write_read_a_seq