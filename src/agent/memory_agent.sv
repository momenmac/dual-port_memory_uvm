class memory_agent extends uvm_agent;
    `uvm_component_utils(memory_agent)
    memory_sequencer sequencer_inst;
    memory_driver driver_inst;
    memory_monitor monitor_inst;

    function new(string name = "memory_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer_inst = memory_sequencer::type_id::create("sequencer_inst", this);
        driver_inst = memory_driver::type_id::create("driver_inst", this); 
        monitor_inst = memory_monitor::type_id::create("monitor_inst", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver_inst.seq_item_port.connect(sequencer_inst.seq_item_export);
    endfunction : connect_phase

endclass : memory_agent