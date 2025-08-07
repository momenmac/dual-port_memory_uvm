class memory_driver extends uvm_driver #(memory_transaction);
    `uvm_component_utils(memory_driver)
    virtual memory_interface mem_if_inst;

    function new(string name = "memory_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase)
        super.build_phase(phase);
        if (!uvm_config_db#(virtual memory_interface)::get(this,"", "mem_if_inst", mem_if_inst)) begin
            `uvm_fatal("MEM_IF", "Memory interface not found")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            memory_transaction mem_tr;
            sequence_item_port.get_next_item(mem_tr);
            mem_if_inst.addr <= mem_tr.addr;
            mem_if_inst.wr_data <= mem_tr.data;
            mem_if_inst.op <= mem_tr.op;
            mem_if_inst.valid <= 1;
            `uvm_info("MEMORY_DRIVER", mem_tr.convert2string(), UVM_HIGH);
            @(posedge mem_if_inst.clk iff mem_if_inst.ready);

            fork : delay_fork
                begin
                    repeat (mem_tr.delay) begin
                        mem_if_inst.valid <= 0;
                        @(posedge mem_if_inst.clk);
                    end
                end

                begin
                    @(negedge mem_if_inst.rstn);
                    mem_if_inst.valid <= 0;
                    `uvm_info("MEMORY_DRIVER", "RESET completed", UVM_HIGH);
                end
            join_any
            disable delay_fork;
        end


    endtask : run_phase
endclass : memory_driver