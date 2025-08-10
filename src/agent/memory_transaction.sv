class memory_transaction extends uvm_sequence_item;
    
    rand bit [`ADDR_WIDTH-1:0] addr;        
    rand bit [`DATA_WIDTH-1:0] data;     
    rand bit                   op;
    rand int delay;
    bit is_start = 0;
    
    constraint addr_c {
        soft addr inside {[`MIN_ADDR:`MAX_ADDR]};
    }

    constraint delay_c {
        soft delay inside {[1:7]};
    }
    
    `uvm_object_utils_begin(memory_transaction)
        `uvm_field_int(addr,     UVM_DEFAULT)
        `uvm_field_int(data,     UVM_DEFAULT)
        `uvm_field_int(op,       UVM_DEFAULT)
        `uvm_field_int(delay,   UVM_DEFAULT)
        `uvm_field_int(is_start, UVM_DEFAULT)
    `uvm_object_utils_end
    
    function new(string name = "memory_transaction");
        super.new(name);
    endfunction : new
    
    virtual function string convert2string();
      return $sformatf("\taddr=0x%4h,\tdata=0x%8h,\top=%s,\tdelay=%0d,\tis_start=%0b", 
                        addr, data, op? "WRITE" : "READ", delay, is_start);
    endfunction : convert2string
    
endclass : memory_transaction