class memory_virtual_sequencer extends uvm_sequencer #(memory_transaction);
    `uvm_component_utils(memory_virtual_sequencer)

    memory_sequencer mem_sequencer_a;
    memory_sequencer mem_sequencer_b;
    
    uvm_blocking_put_port#(memory_transaction) scoreboard_put_port;

    function new(string name = "memory_virtual_sequencer", uvm_component parent = null);
        super.new(name, parent);
        scoreboard_put_port = new("scoreboard_put_port", this);
    endfunction : new
    
    virtual task put_to_scoreboard(memory_transaction tr);
        scoreboard_put_port.put(tr);
        `uvm_info("VSEQ_PUT", $sformatf("Sent transaction to scoreboard: %s", tr.convert2string()), UVM_HIGH)
    endtask : put_to_scoreboard
endclass : memory_virtual_sequencer