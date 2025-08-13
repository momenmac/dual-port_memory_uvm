class fill_mem_seq extends memory_base_sequence;
    `uvm_object_utils(fill_mem_seq)

    function new(string name = "fill_mem_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        same_address = 1; 
        for(int i = 0; i < `MEMORY_DEPTH; i++) begin
            current_addr = i;
            randomize_transaction();
            poke_mem();
        end
    endtask : body
endclass : fill_mem_seq