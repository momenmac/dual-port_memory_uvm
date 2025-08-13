class write_a_read_b_seq extends memory_virtual_sequence;
    `uvm_object_utils(write_a_read_b_seq)

    function new(string name = "write_a_read_b_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = write_seq::type_id::create("write_seq_a");
        mem_sequence_b = read_seq::type_id::create("read_seq_b");
        mem_sequence_b.same_address = 1;
    endtask : pre_start

    virtual task body();
        repeat (num) begin
            mem_sequence_a.start(p_sequencer.mem_sequencer_a);
            `uvm_info("WRITE_A_READ_B_SEQ", $sformatf("Writing to address: %0h", mem_sequence_a.current_addr), UVM_HIGH)
            mem_sequence_b.current_addr = mem_sequence_a.current_addr;
            mem_sequence_b.start(p_sequencer.mem_sequencer_b);
            `uvm_info("WRITE_A_READ_B_SEQ", $sformatf("Reading from address: %0h", mem_sequence_b.current_addr), UVM_HIGH)
        end
    endtask : body
endclass : write_a_read_b_seq