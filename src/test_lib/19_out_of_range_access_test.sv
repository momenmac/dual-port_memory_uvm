class out_of_range_access_test extends base_test;
    `uvm_component_utils(out_of_range_access_test)

    function new(string name = "out_of_range_access_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        memory_virtual_sequence::type_id::set_type_override(out_of_range_access_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

endclass : out_of_range_access_test