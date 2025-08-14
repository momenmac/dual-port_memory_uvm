class back_to_back_transactions_seq extends memory_virtual_sequence;
    `uvm_object_utils(back_to_back_transactions_seq)

    fill_mem_seq fill_mem_seq_inst;
    read_seq mem_sequence_a_rd;
    read_seq mem_sequence_b_rd;

    write_seq mem_sequence_a_wr;
    write_seq mem_sequence_b_wr;

    function new(string name = "back_to_back_transactions_seq");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        super.pre_start();
        mem_sequence_a_rd = read_seq::type_id::create("mem_sequence_a_rd");
        mem_sequence_b_rd = read_seq::type_id::create("mem_sequence_b_rd");

        mem_sequence_a_wr = write_seq::type_id::create("mem_sequence_a_wr");
        mem_sequence_b_wr = write_seq::type_id::create("mem_sequence_b_wr");

        fill_mem_seq_inst = fill_mem_seq::type_id::create("fill_mem_seq_inst");
        mem_sequence_b_wr.same_delay = 1;
        mem_sequence_a_wr.same_delay = 1;
        mem_sequence_b_rd.same_delay = 1;
        mem_sequence_a_rd.same_delay = 1;

        mem_sequence_b_rd.map = ral_model.get_map_b();
        mem_sequence_a_rd.map = ral_model.get_map_a();
        mem_sequence_b_wr.map = ral_model.get_map_b();
        mem_sequence_a_wr.map = ral_model.get_map_a();
    endtask : pre_start

    virtual task body();
        fill_mem_seq_inst.start(p_sequencer.mem_sequencer_a);
        mem_sequence_a_rd.current_delay = 0;
        mem_sequence_b_rd.current_delay = 0;
        mem_sequence_a_wr.current_delay = 0;
        mem_sequence_b_wr.current_delay = 0;
        repeat (num) begin
            fork
                begin
                    if($urandom_range(0, 1))
                        mem_sequence_a_rd.start(p_sequencer.mem_sequencer_a);
                    else
                        mem_sequence_a_wr.start(p_sequencer.mem_sequencer_a);
                end

                begin
                    if($urandom_range(0, 1)) 
                        mem_sequence_b_rd.start(p_sequencer.mem_sequencer_b);
                    else
                        mem_sequence_b_wr.start(p_sequencer.mem_sequencer_b);
                end
            join
        end
    endtask : body
endclass : back_to_back_transactions_seq