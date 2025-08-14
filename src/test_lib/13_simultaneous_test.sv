class simultaneous_write_test extends base_test;
    `uvm_component_utils(simultaneous_write_test)

    function new(string name = "simultaneous_write_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        memory_virtual_sequence::type_id::set_type_override(simultaneous_write_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

endclass : simultaneous_write_test