class memory_reset_seq extends memory_base_sequence;
    `uvm_object_utils(memory_reset_seq)

    function new(string name = "memory_reset_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        reset_memory();
    endtask : body
endclass : memory_reset_seq
