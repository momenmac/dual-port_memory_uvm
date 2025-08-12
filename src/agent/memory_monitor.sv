class memory_monitor extends uvm_monitor;

    `uvm_component_utils(memory_monitor)
    virtual memory_interface mem_if_inst;
    uvm_analysis_port #(memory_transaction) analysis_port;


    function new(string name = "memory_monitor", uvm_component parent = null);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual memory_interface)::get(this, "", "mem_if_inst", mem_if_inst)) begin
            `uvm_fatal("MEM_IF", "Memory interface not found")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            memory_transaction mem_tr_start;
            memory_transaction mem_tr_end;
            `uvm_info("MEM_MONITOR", "Waiting for memory transaction", UVM_DEBUG);
            mem_tr_start = memory_transaction::type_id::create("mem_tr_start");
            mem_tr_end = memory_transaction::type_id::create("mem_tr_end");

            @(posedge mem_if_inst.clk iff mem_if_inst.valid);
            `uvm_info("MEM_MONITOR", "Memory transaction detected", UVM_DEBUG);
            mem_tr_start.addr = mem_if_inst.addr;
            mem_tr_start.data = mem_if_inst.wr_data;
            mem_tr_start.op = mem_if_inst.op;
            mem_tr_start.is_start = 1;

            `uvm_info("MEM_MONITOR", mem_tr_start.convert2string(), UVM_HIGH);
            analysis_port.write(mem_tr_start);

            if(mem_if_inst.ready) begin
                mem_tr_end.op = mem_if_inst.op;
                mem_tr_end.addr = mem_if_inst.addr;
                mem_tr_end.is_start = 0;

                if(mem_if_inst.op)
                    mem_tr_end.data = mem_if_inst.wr_data;
                else 
                    mem_tr_end.data = mem_if_inst.rd_data;

                `uvm_info("MEM_MONITOR", mem_tr_end.convert2string(), UVM_HIGH);
                analysis_port.write(mem_tr_end);
            end
            else begin
                @(posedge mem_if_inst.clk iff(mem_if_inst.valid && mem_if_inst.ready));
                mem_tr_end.op = mem_if_inst.op;
                mem_tr_end.addr = mem_if_inst.addr;
                mem_tr_end.is_start = 0;

                if(mem_if_inst.op)
                    mem_tr_end.data = mem_if_inst.wr_data;
                else 
                    mem_tr_end.data = mem_if_inst.rd_data;

                `uvm_info("MEM_MONITOR", mem_tr_end.convert2string(), UVM_HIGH);
                analysis_port.write(mem_tr_end);
            end
        end
    endtask : run_phase

endclass : memory_monitor
