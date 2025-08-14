class read_collision_test extends base_test;
    `uvm_component_utils(read_collision_test)

    function new(string name = "read_collision_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        memory_virtual_sequence::type_id::set_type_override(read_collision_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

endclass : read_collision_test