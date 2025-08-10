class memory_env extends uvm_env;
    `uvm_component_utils(memory_env)
    memory_agent mem_agent_a;
    memory_agent mem_agent_b;
    memory_scoreboard mem_scoreboard_inst;
    memory_virtual_sequencer mem_virtual_sequencer_inst;

    function new (string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mem_agent_a = memory_agent::type_id::create("mem_agent_a", this);
        mem_agent_b = memory_agent::type_id::create("mem_agent_b", this);
        mem_scoreboard_inst = memory_scoreboard::type_id::create("mem_scoreboard_inst", this);
        mem_virtual_sequencer_inst = memory_virtual_sequencer::type_id::create("mem_virtual_sequencer_inst", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mem_agent_a.monitor_inst.analysis_port.connect(mem_scoreboard_inst.mem_analysis_imp_a);
        mem_agent_b.monitor_inst.analysis_port.connect(mem_scoreboard_inst.mem_analysis_imp_b);
        
        mem_virtual_sequencer_inst.mem_sequencer_a = mem_agent_a.sequencer_inst;
        mem_virtual_sequencer_inst.mem_sequencer_b = mem_agent_b.sequencer_inst;
    endfunction : connect_phase
endclass : memory_env