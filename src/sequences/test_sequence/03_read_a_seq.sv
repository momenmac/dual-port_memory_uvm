class read_a_seq extends memory_virtual_sequence;
    `uvm_object_utils(read_a_seq)

    poke_seq poke_seq_a;

    function new(string name = "read_a_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = read_seq::type_id::create("read_seq_a");
        poke_seq_a = poke_seq::type_id::create("poke_seq_a");
        mem_sequence_a.same_address = 1;

    endtask : pre_start

    virtual task body();
        repeat (num) begin
            poke_seq_a.start(p_sequencer.mem_sequencer_a);
            mem_sequence_a.current_addr = poke_seq_a.current_addr;
            mem_sequence_a.start(p_sequencer.mem_sequencer_a);
        end
    endtask : body
endclass : read_a_seq