class back_to_back_writes_a_test extends base_test;
    `uvm_component_utils(back_to_back_writes_a_test)

    function new(string name = "back_to_back_writes_a_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        memory_virtual_sequence::type_id::set_type_override(back_to_back_writes_a_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

endclass : back_to_back_writes_a_test