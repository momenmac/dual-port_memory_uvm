class memory_virtual_sequencer extends uvm_sequencer #(memory_transaction);
    `uvm_component_utils(memory_virtual_sequencer)

    memory_sequencer mem_sequencer_a;
    memory_sequencer mem_sequencer_b;

    function new(string name = "memory_virtual_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new
    
endclass : memory_virtual_sequencer