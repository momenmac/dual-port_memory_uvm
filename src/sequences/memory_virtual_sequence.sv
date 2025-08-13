class memory_virtual_sequence extends uvm_sequence #(memory_transaction);
    `uvm_object_utils(memory_virtual_sequence)
  	`uvm_declare_p_sequencer (memory_virtual_sequencer)

    memory_base_sequence mem_sequence_a;
    memory_base_sequence mem_sequence_b;
  
  	memory_ral_model ral_model;
  

    rand int num;

    constraint num_c {
        soft num inside {[1:20]};
    }

    function new(string name = "memory_virtual_sequence");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        mem_sequence_a = memory_base_sequence::type_id::create("mem_sequence_a");   
        mem_sequence_b = memory_base_sequence::type_id::create("mem_sequence_b");
    endtask : pre_start


    virtual task pre_body();
        mem_sequence_a.map = ral_model.get_map_a();
        mem_sequence_b.map = ral_model.get_map_b();
    endtask : pre_body

    virtual task body();
        fork
            begin
                repeat (num)
                  mem_sequence_a.start(p_sequencer.mem_sequencer_a);
            end
            begin
                repeat (num)
                  mem_sequence_b.start(p_sequencer.mem_sequencer_b);
            end
        join
        
    endtask : body

endclass : memory_virtual_sequence