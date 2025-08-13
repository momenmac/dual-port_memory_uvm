class read_b_seq extends memory_virtual_sequence;
    `uvm_object_utils(read_b_seq)

    poke_seq poke_seq_b;

    function new(string name = "read_b_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_b = read_seq::type_id::create("read_seq_b");
        poke_seq_b = poke_seq::type_id::create("poke_seq_b");
        mem_sequence_b.same_address = 1;
    endtask : pre_start

    virtual task body();
    .    repeat (num) begin
            poke_seq_b.start(p_sequencer.mem_sequencer_b);
            mem_sequence_b.current_addr = poke_seq_b.current_addr;
            mem_sequence_b.start(p_sequencer.mem_sequencer_b);
        end
    endtask : body
endclass : read_b_seq