class write_seq extends memory_base_sequence;
    `uvm_object_utils(write_seq)

    function new(string name = "write_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        randomize_transaction();
        write_mem();
        wait_clocks(tr.delay);
    endtask : body
endclass : write_seq