class write_read_seq extends memory_base_sequence;
    `uvm_object_utils(write_read_seq)

    function new(string name = "write_read_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        same_address = 1;
        randomize_transaction();
        write_mem();
        wait_clocks(tr.delay);
        randomize_transaction();
        read_mem();
        assert (read_data == written_data) else begin
            `uvm_error("WRITE_READ_SEQ", $sformatf("Data mismatch: expected %0h, got %0h", written_data, read_data));
        end
        wait_clocks(tr.delay);
    endtask : body
endclass : write_read_seq
