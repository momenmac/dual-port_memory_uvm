`uvm_analysis_imp_decl(_a)
`uvm_analysis_imp_decl(_b)

class memory_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(memory_scoreboard)
    
    uvm_analysis_imp_a#(memory_transaction, memory_scoreboard) mem_analysis_imp_a;
    uvm_analysis_imp_b#(memory_transaction, memory_scoreboard) mem_analysis_imp_b;
    uvm_blocking_put_imp#(memory_transaction, memory_scoreboard) m_put_imp;

    
    memory_ral_model ral_model;
  
    bit [`DATA_WIDTH-1:0] ref_memory [`MEMORY_DEPTH-1:0];
    
    int pass_count_a = 0;
    int fail_count_a = 0;
    int pass_count_b = 0;
    int fail_count_b = 0;
    int index_a = 0;
    int index_b = 0;
    int collision_count = 0;
    time collision_window = 0;
    
    memory_transaction active_start_a, active_start_b;
    bit transaction_active_a = 0, transaction_active_b = 0;
    bit collision_detected_a = 0, collision_detected_b = 0;
    
    virtual memory_interface vif;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mem_analysis_imp_a = new("mem_analysis_imp_a", this);
        mem_analysis_imp_b = new("mem_analysis_imp_b", this);
    
        if (!uvm_config_db#(virtual memory_interface)::get(this, "", "vif", vif)) begin
            `uvm_fatal("SCOREBOARD", "Virtual interface not found in config DB")
        end
        m_put_imp = new("m_put_imp", this);
        reset_ref_memory();
    endfunction : build_phase
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        fork
            monitor_reset();
        join_none
    endfunction : connect_phase

    virtual task put (memory_transaction mem_tr_inst);
        `uvm_info("REF_MEMORY_PUT", $sformatf("Putting transaction: %s", mem_tr_inst.convert2string()), UVM_HIGH)
        if(mem_tr_inst.op == `WRITE_OP)
            ref_memory[mem_tr_inst.addr] = mem_tr_inst.data;
      	else begin
            if (ref_memory[mem_tr_inst.addr] !== mem_tr_inst.data)
                `uvm_error("DATA_MISMATCH", $sformatf("Data mismatch at addr=0x%0h: expected=0x%0h, actual=0x%0h", 
                          mem_tr_inst.addr, ref_memory[mem_tr_inst.addr], mem_tr_inst.data))
            else
                `uvm_info("DATA_MATCH", $sformatf("Data match at addr=0x%0h: data=0x%0h", 
                          mem_tr_inst.addr, mem_tr_inst.data), UVM_MEDIUM)
        end
      
    endtask : put

    virtual task monitor_reset();
        forever begin
            @(negedge vif.rstn);
            `uvm_info("SCOREBOARD", "Reset detected - clearing reference memory", UVM_LOW)
            reset_ref_memory();
        end
    endtask : monitor_reset

    virtual function void reset_ref_memory();
        for (int i = 0; i < `MEMORY_DEPTH; i++) begin
            ref_memory[i] = 0;
        end
        `uvm_info("SCOREBOARD", $sformatf("Reference memory reset complete - %0d locations cleared", `MEMORY_DEPTH), UVM_MEDIUM)
    endfunction : reset_ref_memory

    virtual function write_a(memory_transaction mem_tr_inst);
        `uvm_info("SCB_PORT_A", $sformatf("Received transaction: %s", mem_tr_inst.convert2string()), UVM_HIGH)
        fork
            begin
                if (!mem_tr_inst.op && !mem_tr_inst.is_start)
                    #collision_window;
                check_collision_and_process(mem_tr_inst, "PORT_A");
            end
        join_none
    endfunction : write_a

    virtual function write_b(memory_transaction mem_tr_inst);
        `uvm_info("SCB_PORT_B", $sformatf("Received transaction: %s", mem_tr_inst.convert2string()), UVM_HIGH)
        fork
            begin
                if (!mem_tr_inst.op && !mem_tr_inst.is_start)
                    #collision_window;
                check_collision_and_process(mem_tr_inst, "PORT_B");
            end
        join_none
    endfunction : write_b
    
    virtual task check_collision_and_process(memory_transaction tr, string port_name);
        time current_time = $time;
        
        if (port_name == "PORT_A") begin
            if (tr.is_start) begin
                active_start_a = tr;
                transaction_active_a = 1;
                collision_detected_a = 0;
                
                if (transaction_active_b && active_start_b.addr == tr.addr && active_start_b.op != tr.op) begin
                    collision_detected_a = 1;
                    collision_detected_b = 1;
                    collision_count++;
                    `uvm_info("COLLISION", $sformatf("Detected at addr=0x%0h: PORT_A %s vs PORT_B %s at time %0t", 
                             tr.addr, tr.op ? "WRITE" : "READ", active_start_b.op ? "WRITE" : "READ", current_time), UVM_LOW)
                end else begin
                    `uvm_info("SCB_PORT_A", $sformatf("Transaction started: %s at addr=0x%0h", 
                             tr.op ? "WRITE" : "READ", tr.addr), UVM_MEDIUM)
                end
                
            end else begin
                if (collision_detected_a) begin
                    handle_collision_resolution(tr, active_start_a, active_start_b, "PORT_A", "PORT_B");
                    collision_detected_a = 0;
                end else begin
                    if (transaction_active_b && active_start_b.addr == tr.addr && active_start_b.op != tr.op && !collision_detected_b) begin
                        collision_detected_a = 1;
                        collision_detected_b = 1;
                        collision_count++;
                        `uvm_info("COLLISION", $sformatf("Late detected at addr=0x%0h: PORT_A %s vs PORT_B %s at time %0t", 
                                 tr.addr, tr.op ? "WRITE" : "READ", active_start_b.op ? "WRITE" : "READ", current_time), UVM_LOW)
                        handle_collision_resolution(tr, active_start_a, active_start_b, "PORT_A", "PORT_B");
                    end else begin
                        check_normal_transaction(tr, pass_count_a, fail_count_a, index_a, "PORT_A");
                    end
                end
                transaction_active_a = 0;
            end
            
        end else begin 
            if (tr.is_start) begin
                active_start_b = tr;
                transaction_active_b = 1;
                collision_detected_b = 0;
                
                if (transaction_active_a && active_start_a.addr == tr.addr && active_start_a.op != tr.op) begin
                    collision_detected_a = 1;
                    collision_detected_b = 1;
                    collision_count++;
                    `uvm_info("COLLISION", $sformatf("Detected at addr=0x%0h: PORT_B %s vs PORT_A %s at time %0t", 
                             tr.addr, tr.op ? "WRITE" : "READ", active_start_a.op ? "WRITE" : "READ", current_time), UVM_LOW)
                end else begin
                    `uvm_info("SCB_PORT_B", $sformatf("Transaction started: %s at addr=0x%0h", 
                             tr.op ? "WRITE" : "READ", tr.addr), UVM_MEDIUM)
                end
                
            end else begin
                if (collision_detected_b) begin
                    handle_collision_resolution(tr, active_start_b, active_start_a, "PORT_B", "PORT_A");
                    collision_detected_b = 0;
                end else begin
                    if (transaction_active_a && active_start_a.addr == tr.addr && active_start_a.op != tr.op && !collision_detected_a) begin
                        collision_detected_a = 1;
                        collision_detected_b = 1;
                        collision_count++;
                        `uvm_info("COLLISION", $sformatf("Late detected at addr=0x%0h: PORT_B %s vs PORT_A %s at time %0t", 
                                 tr.addr, tr.op ? "WRITE" : "READ", active_start_a.op ? "WRITE" : "READ", current_time), UVM_LOW)
                        handle_collision_resolution(tr, active_start_b, active_start_a, "PORT_B", "PORT_A");
                    end else begin
                        check_normal_transaction(tr, pass_count_b, fail_count_b, index_b, "PORT_B");
                    end
                end
                transaction_active_b = 0;
            end
        end
    endtask
    
    virtual function void handle_collision_resolution(memory_transaction end_tr, memory_transaction my_start, 
                                                    memory_transaction other_start, string my_port, string other_port);
        
        if (my_start.addr != other_start.addr) begin
            `uvm_error("COLLISION", $sformatf("Address mismatch in collision: %s=0x%0h vs %s=0x%0h", 
                      my_port, my_start.addr, other_port, other_start.addr))
            if (my_port == "PORT_A") begin
                check_normal_transaction(end_tr, pass_count_a, fail_count_a, index_a, my_port);
            end else begin
                check_normal_transaction(end_tr, pass_count_b, fail_count_b, index_b, my_port);
            end
            return;
        end
        
        if (my_start.op && !other_start.op) begin
            ref_memory[my_start.addr] = my_start.data;
            verify_ral_backdoor_write(my_start.addr, my_start.data);
            
            `uvm_info("WRITE_SUCCESS", $sformatf("%s: Write completed to addr=0x%0h, data=0x%0h (during collision)", 
                     my_port, my_start.addr, my_start.data), UVM_MEDIUM)
            
            if (my_port == "PORT_A") begin
                pass_count_a++;
                index_a++;
            end else begin
                pass_count_b++;
                index_b++;
            end
            
        end else if (!my_start.op && other_start.op) begin
            if (end_tr.data == other_start.data) begin
                `uvm_info("READ_BYPASS", $sformatf("%s: Read bypass successful at addr=0x%0h, data=0x%0h (from %s write)", 
                         my_port, my_start.addr, end_tr.data, other_port), UVM_MEDIUM)
                
                if (my_port == "PORT_A") begin
                    pass_count_a++;
                    index_a++;
                end else begin
                    pass_count_b++;
                    index_b++;
                end
            end else begin
                `uvm_error("READ_BYPASS", $sformatf("%s: Read bypass failed at addr=0x%0h - expected=0x%0h (from %s), actual=0x%0h", 
                          my_port, my_start.addr, other_start.data, other_port, end_tr.data))
                
                if (my_port == "PORT_A") begin
                    fail_count_a++;
                    index_a++;
                end else begin
                    fail_count_b++;
                    index_b++;
                end
            end
        end
    endfunction
    
    virtual function void check_normal_transaction(memory_transaction tr, ref int pass_count, ref int fail_count, 
                                                 ref int index, input string port_name);
        
        if (tr.addr >= `MEMORY_DEPTH) begin
            `uvm_error("ADDR_BOUNDS", $sformatf("%s: Address 0x%0h exceeds memory depth %0d", 
                      port_name, tr.addr, `MEMORY_DEPTH))
            fail_count++;
            index++;
            return;
        end
        
        if (tr.op) begin
            if (!tr.is_start) begin
                ref_memory[tr.addr] = tr.data;
                verify_ral_backdoor_write(tr.addr, tr.data);
                
                `uvm_info("WRITE_SUCCESS", $sformatf("%s: Write completed to addr=0x%0h, data=0x%0h", 
                         port_name, tr.addr, tr.data), UVM_MEDIUM)
                
                pass_count++;
                index++;
            end
        end else begin
            if (!tr.is_start) begin
                bit [`DATA_WIDTH-1:0] expected_data = ref_memory[tr.addr];
                
                if (expected_data == tr.data) begin
                    `uvm_info("READ_SUCCESS", $sformatf("%s: Read successful from addr=0x%0h, data=0x%0h", 
                             port_name, tr.addr, tr.data), UVM_MEDIUM)
                    pass_count++;
                end else begin
                    `uvm_error("READ_MISMATCH", $sformatf("%s: Read failed at addr=0x%0h - expected=0x%0h, actual=0x%0h", 
                              port_name, tr.addr, expected_data, tr.data))
                    fail_count++;
                end
                index++;
            end
        end
    endfunction
    
    virtual function void verify_ral_backdoor_write(bit [`ADDR_WIDTH-1:0] addr, bit [`DATA_WIDTH-1:0] data);
        uvm_status_e status;
        bit [`DATA_WIDTH-1:0] backdoor_data;

        fork
            begin
                #1;
                ral_model.get_memory().peek(status, addr, backdoor_data);
                
                if (status == UVM_IS_OK) begin
                    if (backdoor_data == data) begin
                        `uvm_info("RAL_VERIFY", $sformatf("RAL backdoor verification PASSED: addr=0x%0h, data=0x%0h", 
                                    addr, data), UVM_HIGH)
                    end else begin
                        `uvm_warning("RAL_VERIFY", $sformatf("RAL backdoor verification FAILED: addr=0x%0h, expected=0x%0h, actual=0x%0h", 
                                    addr, data, backdoor_data))
                    end
                end else begin
                    `uvm_warning("RAL_VERIFY", $sformatf("RAL backdoor peek failed for addr=0x%0h", addr))
                end
            end
        join_none
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        print_final_statistics();
    endfunction
    
    virtual function void print_final_statistics();
        int total_transactions = pass_count_a + fail_count_a + pass_count_b + fail_count_b;
        int total_passes = pass_count_a + pass_count_b;
        int total_fails = fail_count_a + fail_count_b;
        real overall_pass_rate = total_transactions ? (total_passes * 100.0 / total_transactions) : 0;
        real overall_fail_rate = total_transactions ? (total_fails * 100.0 / total_transactions) : 0;
        real port_a_pass_rate = (pass_count_a + fail_count_a) ? (pass_count_a * 100.0 / (pass_count_a + fail_count_a)) : 0;
        real port_b_pass_rate = (pass_count_b + fail_count_b) ? (pass_count_b * 100.0 / (pass_count_b + fail_count_b)) : 0;
        
        `uvm_info("FINAL_REPORT", "========================================", UVM_NONE)
        `uvm_info("FINAL_REPORT", "        SCOREBOARD FINAL STATISTICS", UVM_NONE)
        `uvm_info("FINAL_REPORT", "========================================", UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("PORT A Results:"), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Passes: %0d", pass_count_a), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Failures: %0d", fail_count_a), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Pass Rate: %0.2f%%", port_a_pass_rate), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("PORT B Results:"), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Passes: %0d", pass_count_b), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Failures: %0d", fail_count_b), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Pass Rate: %0.2f%%", port_b_pass_rate), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("Overall Results:"), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Total Transactions: %0d", total_transactions), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Total Passes: %0d", total_passes), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Total Failures: %0d", total_fails), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Overall Pass Rate: %0.2f%%", overall_pass_rate), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Overall Fail Rate: %0.2f%%", overall_fail_rate), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("Collision Statistics:"), UVM_NONE)
        `uvm_info("FINAL_REPORT", $sformatf("  Read-Write Collisions: %0d", collision_count), UVM_NONE)
        `uvm_info("FINAL_REPORT", "========================================", UVM_NONE)
        
        if (total_fails == 0) begin
            `uvm_info("TEST_RESULT", "*** TEST PASSED - All transactions successful! ***", UVM_NONE)
        end else begin
            `uvm_error("TEST_RESULT", $sformatf("*** TEST FAILED - %0d transaction failures detected ***", total_fails))
        end
    endfunction

endclass : memory_scoreboard