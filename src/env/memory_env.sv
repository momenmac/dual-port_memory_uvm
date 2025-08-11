class memory_env extends uvm_env;
    `uvm_component_utils(memory_env)
    
    memory_agent mem_agent_a;
    memory_agent mem_agent_b;
    
    memory_scoreboard mem_scoreboard_inst;
    
        memory_virtual_sequencer mem_virtual_sequencer_inst;
    
    // RAL model and related components
    memory_ral_model ral_model;
    memory_reg_adapter reg_adapter_a;
    memory_reg_adapter reg_adapter_b;
    memory_reg_predictor reg_predictor_a;
    memory_reg_predictor reg_predictor_b;

    function new (string name = "memory_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create agents
        mem_agent_a = memory_agent::type_id::create("mem_agent_a", this);
        mem_agent_b = memory_agent::type_id::create("mem_agent_b", this);
        
        // Create scoreboard
        mem_scoreboard_inst = memory_scoreboard::type_id::create("mem_scoreboard_inst", this);
        
        // Create virtual sequencer
        mem_virtual_sequencer_inst = memory_virtual_sequencer::type_id::create("mem_virtual_sequencer_inst", this);
        
        // Create RAL model
        ral_model = memory_ral_model::type_id::create("ral_model");
        ral_model.build();
        
        // Set RAL model in config_db for other components
        uvm_config_db#(memory_ral_model)::set(this, "*", "ral_model", ral_model);
        
        // Create register adapters
        reg_adapter_a = memory_reg_adapter::type_id::create("reg_adapter_a");
        reg_adapter_b = memory_reg_adapter::type_id::create("reg_adapter_b");
        
        // Create register predictors
        reg_predictor_a = memory_reg_predictor::type_id::create("reg_predictor_a", this);
        reg_predictor_b = memory_reg_predictor::type_id::create("reg_predictor_b", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Connect monitors to scoreboard
        mem_agent_a.monitor_inst.analysis_port.connect(mem_scoreboard_inst.mem_analysis_imp_a);
        mem_agent_b.monitor_inst.analysis_port.connect(mem_scoreboard_inst.mem_analysis_imp_b);
        
        // Connect sequencers to virtual sequencer
        mem_virtual_sequencer_inst.mem_sequencer_a = mem_agent_a.sequencer_inst;
        mem_virtual_sequencer_inst.mem_sequencer_b = mem_agent_b.sequencer_inst;
        
        // Connect RAL model to agents (if agents are active)
        if (mem_agent_a.get_is_active() == UVM_ACTIVE) begin
            ral_model.default_map.set_sequencer(mem_agent_a.sequencer_inst, reg_adapter_a);
        end
        
        if (mem_agent_b.get_is_active() == UVM_ACTIVE) begin
            ral_model.default_map.set_sequencer(mem_agent_b.sequencer_inst, reg_adapter_b);
        end
        
        // Connect monitors to register predictors
        mem_agent_a.monitor_inst.analysis_port.connect(reg_predictor_a.bus_in);
        mem_agent_b.monitor_inst.analysis_port.connect(reg_predictor_b.bus_in);
        
        // Set the register model for predictors
        reg_predictor_a.map = ral_model.default_map;
        reg_predictor_a.adapter = reg_adapter_a;
        
        reg_predictor_b.map = ral_model.default_map;
        reg_predictor_b.adapter = reg_adapter_b;
    endfunction : connect_phase
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("RAL_MODEL", "RAL Model Structure:", UVM_MEDIUM)
        ral_model.print();
    endfunction : end_of_elaboration_phase
    
endclass : memory_env