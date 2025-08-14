class out_of_range_access_seq extends memory_virtual_sequence;
    `uvm_object_utils(out_of_range_access_seq)

    read_all_mem_seq read_all_mem_seq_a;
    function new(string name = "out_of_range_access_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        read_all_mem_seq_a = read_all_mem_seq::type_id::create("read_all_mem_seq_a");
    endtask : pre_start

    virtual task body();
        repeat (num) begin
            `uvm_do_on_with(req, $urandom_range(0, 1)? p_sequencer.mem_sequencer_a : p_sequencer.mem_sequencer_b,
            {
            req.addr >= `MEMORY_DEPTH;
            req.addr < 2 ** `ADDR_WIDTH;
            })

            get_response(rsp);
            `uvm_info(get_type_name(), $sformatf("Received response: %0h", rsp.data), UVM_DEBUG)
        end
        read_all_mem_seq_a.start(p_sequencer.mem_sequencer_a);
    endtask : body
endclass : out_of_range_access_seq
