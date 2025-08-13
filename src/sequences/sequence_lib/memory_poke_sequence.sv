class poke_seq extends memory_base_sequence;
    `uvm_object_utils(poke_seq)

    function new(string name = "poke_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        randomize_transaction();
        poke_mem();
    endtask : body
endclass : poke_seq