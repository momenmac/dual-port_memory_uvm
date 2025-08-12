
class memory_model extends uvm_mem;
    `uvm_object_utils(memory_model)
    
    function new(string name = "memory_model");
        super.new(name, `MEMORY_DEPTH, `DATA_WIDTH, "RW", UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        add_hdl_path_slice("mem_inst.mem", `MIN_ADDR, `DATA_WIDTH);
    endfunction : build
endclass

class memory_ral_model extends uvm_reg_block;
    `uvm_object_utils(memory_ral_model)
    
    memory_model mem;
    uvm_reg_map map_a;
    uvm_reg_map map_b;
    
    function new(string name = "memory_ral_model");
        super.new(name, UVM_NO_COVERAGE);
    endfunction
    
    virtual function void build();
        mem = memory_model::type_id::create("mem");
        mem.build();
        mem.configure(this); 

        map_a = create_map("map_a", 0, 4, UVM_LITTLE_ENDIAN, 0);
        map_b = create_map("map_b", 0, 4, UVM_LITTLE_ENDIAN, 0);
        
        map_a.add_mem(mem, 0, "RW");
        map_b.add_mem(mem, 0, "RW");
        add_hdl_path("top_tb.DP_MEMORY_INST", "RTL");
    endfunction

    function memory_model get_memory();
        return mem;
    endfunction
    
    function uvm_reg_map get_map_a();
        return map_a;
    endfunction
    
    function uvm_reg_map get_map_b();
        return map_b;
    endfunction
endclass