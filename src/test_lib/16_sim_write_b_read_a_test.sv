class sim_write_b_read_a_test extends base_test;
    `uvm_component_utils(sim_write_b_read_a_test)

    function new(string name = "sim_write_b_read_a_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        memory_virtual_sequence::type_id::set_type_override(sim_write_b_read_a_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

endclass : sim_write_b_read_a_test