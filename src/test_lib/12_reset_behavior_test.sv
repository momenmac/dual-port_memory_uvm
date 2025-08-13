class reset_behavior_test extends base_test;
    `uvm_component_utils(reset_behavior_test)

    function new(string name = "reset_behavior_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        memory_virtual_sequence::type_id::set_type_override(reset_behavior_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

endclass : reset_behavior_test