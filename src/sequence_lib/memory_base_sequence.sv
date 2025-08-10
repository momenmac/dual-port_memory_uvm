class memory_base_sequence extends uvm_sequence #(memory_transaction);
    `uvm_object_utils(memory_base_sequence)
  
  	int current_addr;

    function new(string name = "memory_base_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        memory_transaction tr;
        `uvm_create(tr)
        `uvm_rand_send_with(tr,{op == 1;
                                delay == 1;})
      	current_addr = tr.addr;
        `uvm_rand_send_with(tr,{op == 0;
                                addr ==	current_addr;
                                delay == 1;})
    endtask : body
endclass : memory_base_sequence