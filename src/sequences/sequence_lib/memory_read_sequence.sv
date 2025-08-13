class read_seq extends memory_base_sequence;
    `uvm_object_utils(read_seq)

    function new(string name = "read_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        randomize_transaction();
        read_mem();
        wait_clocks(tr.delay);
    endtask : body
endclass : read_seq
