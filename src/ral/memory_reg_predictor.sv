// This is a placeholder for future enhancements or specific implementations
class memory_reg_predictor extends uvm_reg_predictor#(memory_transaction);
    `uvm_component_utils(memory_reg_predictor)
       
    function new(string name = "memory_reg_predictor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass
