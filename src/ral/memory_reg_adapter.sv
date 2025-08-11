class memory_reg_adapter extends uvm_reg_adapter;
    `uvm_object_utils(memory_reg_adapter)
    
    function new(string name = "memory_reg_adapter");
        super.new(name);
        supports_byte_enable = 0;
        provides_responses = 0;
    endfunction
    
    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        memory_transaction mem_tr;
        
        mem_tr = memory_transaction::type_id::create("mem_tr");
        assert (mem_tr.randomize()) else 
            `uvm_fatal("REG_ADAPTER", "Failed to randomize memory_transaction")
        
        mem_tr.addr = rw.addr[`ADDR_WIDTH-1:0];
        mem_tr.op = (rw.kind == UVM_WRITE) ? `WRITE_OP : `READ_OP;
        
        if (rw.kind == UVM_WRITE) 
            mem_tr.data = rw.data[`DATA_WIDTH-1:0];

        `uvm_info("REG_ADAPTER", $sformatf("reg2bus: %s", mem_tr.convert2string()), UVM_HIGH)
        return mem_tr;
    endfunction
    
    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        memory_transaction mem_tr;
        
        if (!$cast(mem_tr, bus_item)) begin
            `uvm_fatal("REG_ADAPTER", "Failed to cast bus_item to memory_transaction")
        end
        
        if (mem_tr.is_start) begin
            rw.status = UVM_NOT_OK;  
            `uvm_info("REG_ADAPTER", "Ignoring start transaction", UVM_HIGH)
            return;
        end
        
        rw.kind = mem_tr.op ? UVM_WRITE : UVM_READ;
        rw.addr = mem_tr.addr;
        rw.data = mem_tr.data;
        rw.status = UVM_IS_OK;
        
        `uvm_info("REG_ADAPTER", $sformatf("bus2reg: addr=0x%0h, data=0x%0h, op=%s", 
                  rw.addr, rw.data, rw.kind == UVM_WRITE ? "WRITE" : "READ"), UVM_HIGH)
    endfunction
endclass