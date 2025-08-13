class empty_mem_read_test extends base_test;
    `uvm_component_utils(empty_mem_read_test)

    function new(string name = "empty_mem_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        memory_virtual_sequence::type_id::set_type_override(empty_mem_read_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

endclass : empty_mem_read_test