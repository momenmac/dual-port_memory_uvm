class scb;
    mailbox mon2scb_a;
    mailbox mon2scb_b;
    int index_a = 0;
    int index_b = 0;
    int pass_count_a = 0;
    int fail_count_a = 0;
    int pass_count_b = 0;
    int fail_count_b = 0;
    bit [`DATA_WIDTH - 1:0] memory [`MEMORY_DEPTH - 1:0] = '{default: 0};
    string tag_a;
    string tag_b;
	  virtual dut_if vif;
  	int debug_enabled;
    
    int collision_count = 0;
    time collision_window = 0;

    transaction active_start_a, active_start_b;
    bit transaction_active_a = 0, transaction_active_b = 0;
    bit collision_detected_a = 0, collision_detected_b = 0;
  
    function void reset ();
      for (int i = 0; i < `MEMORY_DEPTH; i++) begin
            memory[i] <= 0;
        end
    endfunction
  
  function new();
    this.debug_enabled = TestRegistry::get_int("DebugEnabled");
  endfunction
  
  task run();
    $display("SCB is running");

    forever begin
    fork
      begin
        forever begin
          transaction item_a;
          mon2scb_a.get(item_a);
          tag_a = item_a.we ? "Write" : "Read";
          tag_a = $sformatf("Transaction (%s)", tag_a);
          item_a.print("Port_A", "ScoreBoard", tag_a, index_a);
          if (!item_a.we && !item_a.is_start) 
            #collision_window;
          check_collision(item_a, "Port_A");
        end
      end

      begin
        forever begin
          transaction item_b;
          mon2scb_b.get(item_b);
          tag_b = item_b.we ? "Write" : "Read";
          tag_b = $sformatf("Transaction (%s)", tag_b);
          item_b.print("Port_B", "ScoreBoard", tag_b, index_b);
          if (!item_b.we && !item_b.is_start)
            #collision_window;
          check_collision(item_b, "Port_B");
        end
      end

      begin
        @(negedge vif.rst_n);
        if (debug_enabled)
          $display("SCB reset started");
        reset();
        if (debug_enabled)
          $display("SCB reset complete");
      end
    join_any
    disable fork;
    end
  endtask
    
  function void check_collision(transaction tr, string port_name);
    time current_time = $time;
    
    if (port_name == "Port_A") begin
      if (tr.is_start) begin
        active_start_a = tr;
        transaction_active_a = 1;
        collision_detected_a = 0;
        
        if (transaction_active_b && active_start_b.addr == tr.addr && active_start_b.we != tr.we) begin
          collision_detected_a = 1;
          collision_detected_b = 1;
          collision_count++;
          if(debug_enabled)
            $display("Collision DETECTED: Port_A %s starts while Port_B %s active at address %0h [%t] ", 
                    tr.we ? "Write" : "Read", active_start_b.we ? "Write" : "Read", tr.addr, current_time);
        end
        
      end else begin
        if (collision_detected_a) begin
          handle_bypass_end(tr, active_start_a, active_start_b, "Port_A", "Port_B");
          collision_detected_a = 0;
        end else begin
          check_transaction(tr, pass_count_a, fail_count_a, index_a, port_name);
        end
        transaction_active_a = 0;
      end
      
    end else begin 
      if (tr.is_start) begin
        active_start_b = tr;
        transaction_active_b = 1;
        collision_detected_b = 0;
        
        if (transaction_active_a && active_start_a.addr == tr.addr && active_start_a.we != tr.we) begin
          collision_detected_a = 1;
          collision_detected_b = 1;
          collision_count++;
          if(debug_enabled) begin
            $display("Collision DETECTED: Port_B %s starts while Port_A %s active at address %0h [%t]", 
                    tr.we ? "Write" : "Read", active_start_a.we ? "Write" : "Read", tr.addr, current_time);
          end
        end
        
      end else begin
        if (collision_detected_b) begin
          handle_bypass_end(tr, active_start_b, active_start_a, "Port_B", "Port_A");
          collision_detected_b = 0;
        end else begin
          check_transaction(tr, pass_count_b, fail_count_b, index_b, port_name);
        end
        transaction_active_b = 0;
      end
    end
  endfunction
  
  function void handle_bypass_end(transaction end_tr, transaction my_start, transaction other_start, string my_port, string other_port);
    
    if (my_start.addr != other_start.addr) begin
      if (debug_enabled)
        $display("ERROR: Address mismatch in bypass - my_addr=%0h, other_addr=%0h [%t]", 
                my_start.addr, other_start.addr, $time);
      if (my_port == "Port_A") begin
        check_transaction(end_tr, pass_count_a, fail_count_a, index_a, my_port);
      end else begin
        check_transaction(end_tr, pass_count_b, fail_count_b, index_b, my_port);
      end
      return;
    end
    
    if (my_start.we && !other_start.we) begin
      memory[my_start.addr] = my_start.data;
      if (debug_enabled)
        $display("<%s> Write successful to address %0h with data %0h, memory updated [%t]", 
                my_port, my_start.addr, my_start.data, $time);
      
      if (my_port == "Port_A") begin
        pass_count_a++;
        index_a++;
      end else begin
        pass_count_b++;
        index_b++;
      end
      
    end else if (!my_start.we && other_start.we) begin
        bit other_port_active;
      if (my_port == "Port_A") begin
        other_port_active = transaction_active_b;
      end else begin
        other_port_active = transaction_active_a;
      end
      
      if (other_port_active) begin
        if(debug_enabled)

        if (end_tr.data == other_start.data) begin
          if (debug_enabled)
            $display("<%s> Read bypass successful at address %0h with data %0h (from active %s write) [%t]", 
                    my_port, my_start.addr, end_tr.data, other_port, $time);
          if (my_port == "Port_A") begin
            pass_count_a++;
            index_a++;
          end else begin
            pass_count_b++;
            index_b++;
          end
        end else begin
          $error("<%s> Read bypass mismatch at address %0h: expected %0h (from %s write), got %0h [%t]", 
                 my_port, my_start.addr, other_start.data, other_port, end_tr.data, $time);
          if (my_port == "Port_A") begin
            fail_count_a++;
            index_a++;
          end else begin
            fail_count_b++;
            index_b++;
          end
        end
      end else begin
      
        if (my_port == "Port_A") begin
          check_transaction(end_tr, pass_count_a, fail_count_a, index_a, my_port);
        end else begin
          check_transaction(end_tr, pass_count_b, fail_count_b, index_b, my_port);
        end
      end
    end
  endfunction
  
  function void report_statistics();
      $display("==========================");
      $display("SCB Statistics:");
      $display("Total Passes (Port A): %0d", pass_count_a);
      $display("Total Failures (Port A): %0d", fail_count_a);
      $display("Pass Rate (Port A): %0.2f%%", (pass_count_a + fail_count_a) ? (pass_count_a * 100.0 / (pass_count_a + fail_count_a)) : 0);
      $display("Total Passes (Port B): %0d", pass_count_b);
      $display("Total Failures (Port B): %0d", fail_count_b);
      $display("Pass Rate (Port B): %0.2f%%", (pass_count_b + fail_count_b) ? (pass_count_b * 100.0 / (pass_count_b + fail_count_b)) : 0);
      $display("Total Transactions: %0d", pass_count_a + fail_count_a + pass_count_b + fail_count_b);
      $display("Pass Rate: %0.2f%%", (pass_count_a + fail_count_a + pass_count_b + fail_count_b) ? ((pass_count_a + pass_count_b) * 100.0 / (pass_count_a + fail_count_a + pass_count_b + fail_count_b)) : 0);
      $display("Fail Rate: %0.2f%%", (pass_count_a + fail_count_a + pass_count_b + fail_count_b) ? ((fail_count_a + fail_count_b) * 100.0 / (pass_count_a + fail_count_a + pass_count_b + fail_count_b)) : 0);
      $display("==========================");
      $display("Collision Statistics:");
      $display("Total Read-Write Collisions: %0d", collision_count);
      $display("==========================");
  endfunction

  function void check_transaction(transaction tr, ref int pass_count, ref int fail_count,ref int index, input string port_name = "");

    if (tr.addr >= `MEMORY_DEPTH && debug_enabled) begin
        	$display("Error: %s Address out of bounds: %0h", port_name, tr.addr);
          return;
    end

    if (tr.we) begin
      if (!tr.is_start) begin
        memory[tr.addr] = tr.data;
        if (debug_enabled)
          $display("<%s> Write successful to address %0h with data %0h", port_name, tr.addr, tr.data);
        index++;
        pass_count++;
      end
    end
    else begin
      if (!tr.is_start) begin
        index++;
        assert (memory[tr.addr] == tr.data) begin
          if (debug_enabled)
            $display("<%s> Read successful to address from ref memory %0h with data %0h", port_name, tr.addr, tr.data);
          pass_count++;
        end
        else begin
          $error("<%s> Read mismatch at address %0h: expected %0h, got %0h", port_name, tr.addr, memory[tr.addr], tr.data);
          fail_count++;
        end
      end
    end

  endfunction
  endclass : scb