`uvm_analysis_imp_decl(_a)
`uvm_analysis_imp_decl(_b)

class memory_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(memory_scoreboard)
    uvm_analysis_imp_a#(memory_transaction, memory_scoreboard) mem_analysis_imp_a;
    uvm_analysis_imp_b#(memory_transaction, memory_scoreboard) mem_analysis_imp_b;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mem_analysis_imp_a = new("mem_analysis_imp_a", this);
        mem_analysis_imp_b = new("mem_analysis_imp_b", this);
    endfunction : build_phase

    virtual function write_a(memory_transaction mem_tr_inst);
        `uvm_info("SCOREBOARD_A", mem_tr_inst.convert2string(), UVM_MEDIUM)
    endfunction : write_a

    virtual function write_b(memory_transaction mem_tr_inst);
        `uvm_info("SCOREBOARD_B", mem_tr_inst.convert2string(), UVM_MEDIUM)
    endfunction : write_b

endclass : memory_scoreboard