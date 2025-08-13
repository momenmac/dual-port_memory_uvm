class write_same_address_seq extends memory_virtual_sequence;
    `uvm_object_utils(write_same_address_seq)

    function new(string name = "write_same_address_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a = write_seq::type_id::create("write_seq_a");
    endtask : pre_start

    virtual task body();
        repeat (num) begin
            mem_sequence_a.start(p_sequencer.mem_sequencer_a);
            `uvm_info("write_same_address_seq", $sformatf("Reading from address: %0h", mem_sequence_a.current_addr), UVM_HIGH)
            mem_sequence_a.same_address = 1;

            repeat ($urandom_range(2, 5)) begin
                mem_sequence_a.start(p_sequencer.mem_sequencer_a);
                `uvm_info("write_same_address_seq", $sformatf("Writing to address: %0h", mem_sequence_a.current_addr), UVM_HIGH)
            end
            mem_sequence_a.same_address = 0;
        end
    endtask : body
endclass : write_same_address_seq