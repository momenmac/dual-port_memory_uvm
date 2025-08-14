class cfg_info extends uvm_object;
    `uvm_object_utils(cfg_info)

    rand int transmit_delay; 

    constraint c_transmit_delay {
        transmit_delay > 0;
        transmit_delay <= 7;
    }
    function new (string name = "cfg_info");
        super.new(name);
    endfunction : new
endclass