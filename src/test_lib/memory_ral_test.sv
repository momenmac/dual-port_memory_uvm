class memory_ral_test extends base_test;
    `uvm_component_utils(memory_ral_test)
    
    function new(string name = "memory_ral_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("RAL_TEST", "Building RAL test", UVM_LOW)
    endfunction : build_phase
    
    virtual task run_phase(uvm_phase phase);
        memory_ral_write_read_sequence ral_seq;
        memory_ral_multiple_sequence ral_multi_seq;
        memory_ral_dual_port_sequence ral_dual_seq;
        
        phase.raise_objection(this);
        
        `uvm_info("RAL_TEST", "Starting RAL test sequences", UVM_LOW)
        
        // Test 1: Simple write-read sequence
        `uvm_info("RAL_TEST", "=== Test 1: Simple RAL Write-Read ===", UVM_LOW)
        ral_seq = memory_ral_write_read_sequence::type_id::create("ral_seq");
        assert(ral_seq.randomize()) else 
            `uvm_fatal("RAL_TEST", "Failed to randomize RAL sequence")
        ral_seq.start(mem_env_inst.mem_virtual_sequencer_inst);
        
        #100ns;
        
        // Test 2: Multiple write-read operations
        `uvm_info("RAL_TEST", "=== Test 2: Multiple RAL Operations ===", UVM_LOW)
        ral_multi_seq = memory_ral_multiple_sequence::type_id::create("ral_multi_seq");
        assert(ral_multi_seq.randomize()) else 
            `uvm_fatal("RAL_TEST", "Failed to randomize RAL multiple sequence")
        ral_multi_seq.start(mem_env_inst.mem_virtual_sequencer_inst);
        
        #100ns;
        
        // Test 3: Dual port operations
        `uvm_info("RAL_TEST", "=== Test 3: Dual Port RAL Operations ===", UVM_LOW)
        ral_dual_seq = memory_ral_dual_port_sequence::type_id::create("ral_dual_seq");
        assert(ral_dual_seq.randomize()) else 
            `uvm_fatal("RAL_TEST", "Failed to randomize RAL dual port sequence")
        ral_dual_seq.start(mem_env_inst.mem_virtual_sequencer_inst);
        
        #100ns;
        
        `uvm_info("RAL_TEST", "RAL test completed", UVM_LOW)
        
        phase.drop_objection(this);
    endtask : run_phase
    
endclass : memory_ral_test
