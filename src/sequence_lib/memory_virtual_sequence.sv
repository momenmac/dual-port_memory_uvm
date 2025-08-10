class memory_virtual_sequence extends uvm_sequence #(memory_transaction);
    `uvm_object_utils(memory_virtual_sequence)
  `uvm_declare_p_sequencer (memory_virtual_sequencer)

    memory_base_sequence mem_sequence_a;
    memory_base_sequence mem_sequence_b;

    rand int num;

    constraint num_c {
        soft num inside {[1:20]};
    }

    function new(string name = "memory_virtual_sequence");
        super.new(name);
    endfunction : new

    virtual task pre_body();
        mem_sequence_a = memory_base_sequence::type_id::create("mem_sequence_a");
        mem_sequence_b = memory_base_sequence::type_id::create("mem_sequence_b"); 
    endtask : pre_body

    virtual task body();
        fork
            begin
                repeat (num)
                    `uvm_do_on(mem_sequence_a, p_sequencer.mem_sequencer_a)
            end
            begin
                repeat (num)
                    `uvm_do_on(mem_sequence_b, p_sequencer.mem_sequencer_b)
            end
        join
    endtask : body

endclass : memory_virtual_sequence