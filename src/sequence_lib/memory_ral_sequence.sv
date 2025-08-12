class memory_ral_write_read_sequence extends uvm_sequence;
    `uvm_object_utils(memory_ral_write_read_sequence)
    
    memory_ral_model ral_model;
    memory_virtual_sequencer p_sequencer;
    rand bit [`ADDR_WIDTH-1:0] test_addr;
    rand bit [`DATA_WIDTH-1:0] test_data;
    rand int delay_cycles;
    
    constraint addr_c {
        soft test_addr inside {[`MIN_ADDR:`MAX_ADDR]};
    }
    
    constraint delay_c {
        soft delay_cycles inside {[5:20]};
    }
    
    function new(string name = "memory_ral_write_read_sequence");
        super.new(name);
    endfunction : new
    
    virtual task body();
        uvm_status_e status;
        uvm_reg_data_t read_data;

        ral_model.mem.write(status, test_addr, test_data, UVM_FRONTDOOR, .parent(this));
        
        if (status != UVM_IS_OK) begin
            `uvm_error("RAL_SEQ", $sformatf("RAL write failed with status: %s", status.name()))
        end else begin
            `uvm_info("RAL_SEQ", "RAL write completed successfully", UVM_MEDIUM)
        end
        
        `uvm_info("RAL_SEQ", $sformatf("Reading from address 0x%0h using RAL front door", test_addr), UVM_MEDIUM)
        
        ral_model.mem.read(status, test_addr, read_data, UVM_FRONTDOOR, .parent(this));
        
        if (status != UVM_IS_OK) begin
            `uvm_error("RAL_SEQ", $sformatf("RAL read failed with status: %s", status.name()))
        end else begin
            `uvm_info("RAL_SEQ", $sformatf("RAL read completed: addr=0x%0h, data=0x%0h", 
                      test_addr, read_data), UVM_MEDIUM)
            
            // Compare read data with written data
            if (read_data == test_data) begin
                `uvm_info("RAL_SEQ", "RAL write-read sequence PASSED - data matches!", UVM_MEDIUM)
            end else begin
                `uvm_error("RAL_SEQ", $sformatf("RAL write-read sequence FAILED - expected=0x%0h, actual=0x%0h", 
                           test_data, read_data))
            end
        end
        
    endtask : body
    
endclass : memory_ral_write_read_sequence


// Simple sequence that performs multiple write-read operations
class memory_ral_multiple_sequence extends uvm_sequence;
    `uvm_object_utils(memory_ral_multiple_sequence)
    
    rand int num_transactions;
    
    constraint num_trans_c {
        soft num_transactions inside {[5:15]};
    }
    
    function new(string name = "memory_ral_multiple_sequence");
        super.new(name);
    endfunction : new
    
    virtual task body();
        memory_ral_write_read_sequence ral_seq;
        
        `uvm_info("RAL_MULTI_SEQ", $sformatf("Starting multiple RAL sequence with %0d transactions", 
                  num_transactions), UVM_LOW)
        
        repeat(num_transactions) begin
            ral_seq = memory_ral_write_read_sequence::type_id::create("ral_seq");
            assert(ral_seq.randomize()) else 
                `uvm_fatal("RAL_MULTI_SEQ", "Failed to randomize RAL sequence")
            
            ral_seq.start(m_sequencer);
            
            if ($cast(p_sequencer, m_sequencer)) begin
                repeat($urandom_range(1,5)) @(posedge p_sequencer.mem_if_inst.clk);
            end else begin
                #($urandom_range(10,50));
            end
        end
        
        `uvm_info("RAL_MULTI_SEQ", "Multiple RAL sequence completed", UVM_LOW)
        
    endtask : body
    
endclass : memory_ral_multiple_sequence


// Sequence that tests concurrent access from both ports
class memory_ral_dual_port_sequence extends uvm_sequence;
    `uvm_object_utils(memory_ral_dual_port_sequence)
    
    memory_ral_model ral_model;
    memory_virtual_sequencer p_sequencer;
    rand bit [`ADDR_WIDTH-1:0] test_addr;
    rand bit [`DATA_WIDTH-1:0] test_data_a, test_data_b;
    
    function new(string name = "memory_ral_dual_port_sequence");
        super.new(name);
    endfunction : new
    
    virtual task body();
        uvm_status_e status;
        uvm_reg_data_t read_data_a, read_data_b;
        
        // Get RAL model from config_db
        if (!uvm_config_db#(memory_ral_model)::get(m_sequencer, "", "ral_model", ral_model)) begin
            `uvm_fatal("RAL_DUAL_SEQ", "Could not get RAL model from config_db")
        end
        
        `uvm_info("RAL_DUAL_SEQ", $sformatf("Starting dual port RAL sequence at addr=0x%0h", test_addr), UVM_MEDIUM)
        
        // Write from port A using map_a
        `uvm_info("RAL_DUAL_SEQ", $sformatf("Writing 0x%0h to address 0x%0h via PORT A", 
                  test_data_a, test_addr), UVM_MEDIUM)
        
        ral_model.mem.write(status, test_addr, test_data_a, UVM_FRONTDOOR, .parent(this), .map(ral_model.get_map_a()));
        
        if (status == UVM_IS_OK) begin
            `uvm_info("RAL_DUAL_SEQ", "Port A write completed", UVM_MEDIUM)
        end
        
        // Small delay
        if ($cast(p_sequencer, m_sequencer)) begin
            repeat(3) @(posedge p_sequencer.mem_if_inst.clk);
        end else begin
            #30ns;
        end
        
        // Read from port B using map_b
        `uvm_info("RAL_DUAL_SEQ", $sformatf("Reading from address 0x%0h via PORT B", test_addr), UVM_MEDIUM)
        
        ral_model.mem.read(status, test_addr, read_data_b, UVM_FRONTDOOR, .parent(this), .map(ral_model.get_map_b()));
        
        if (status == UVM_IS_OK) begin
            `uvm_info("RAL_DUAL_SEQ", $sformatf("Port B read completed: data=0x%0h", read_data_b), UVM_MEDIUM)
            
            if (read_data_b == test_data_a) begin
                `uvm_info("RAL_DUAL_SEQ", "Dual port test PASSED - Port B read matches Port A write!", UVM_MEDIUM)
            end else begin
                `uvm_error("RAL_DUAL_SEQ", $sformatf("Dual port test FAILED - expected=0x%0h, actual=0x%0h", 
                           test_data_a, read_data_b))
            end
        end
        
    endtask : body
    
endclass : memory_ral_dual_port_sequence
