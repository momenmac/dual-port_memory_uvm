class fill_memory_test extends base_test;
    `uvm_component_utils(fill_memory_test)

    function new(string name = "fill_memory_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        memory_virtual_sequence::type_id::set_type_override(fill_memory_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

endclass : fill_memory_test