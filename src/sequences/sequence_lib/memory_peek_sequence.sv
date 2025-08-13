class peek_seq extends memory_base_sequence;
    `uvm_object_utils(peek_seq)

    function new(string name = "peek_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        randomize_transaction();
        peek_mem();
    endtask : body
endclass : peek_seq