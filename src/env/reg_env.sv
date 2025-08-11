class reg_env extends uvm_env;
    `uvm_component_utils(reg_env)

    memory_ral_model ral_model;
    memory_reg_adapter reg_adapter_a;
    memory_reg_adapter reg_adapter_b;
    memory_reg_predictor reg_predictor_a;
    memory_reg_predictor reg_predictor_b;

    function new(string name = "reg_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ral_model = memory_ral_model::type_id::create("ral_model");

        reg_adapter_a = memory_reg_adapter::type_id::create("reg_adapter_a");
        reg_adapter_b = memory_reg_adapter::type_id::create("reg_adapter_b");

        reg_predictor_a = memory_reg_predictor::type_id::create("reg_predictor_a", this);
        reg_predictor_b = memory_reg_predictor::type_id::create("reg_predictor_b", this);

        ral_model.build();
        ral_model.lock_model();

        uvm_config_db#(memory_ral_model)::set(this, "*", "ral_model", ral_model);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        reg_predictor_a.map = ral_model.get_map_a();
        reg_predictor_a.adapter = reg_adapter_a;
        
        reg_predictor_b.map = ral_model.get_map_b();
        reg_predictor_b.adapter = reg_adapter_b;
    endfunction : connect_phase

endclass : reg_env