
`ifndef AXISEQ_GUARD
`define AXISEQ_GUARD

`include "pwm_init_trans.sv"

// Memory access sequence generator
class axi_sequencer;
    // mailbox
    mailbox init_mbx;

    // Transaction item
    pwm_init_trans pwm_init_item;

    function new(mailbox init_mbx);
        this.init_mbx = init_mbx;
    endfunction

    // PWM initialization
    task pwm_init();
        repeat(pwm_init_trans::get_data_size()) begin
            // Generate requests and push it to mailbox
            pwm_init_item = new();
            init_mbx.put(pwm_init_item);
        end
    endtask
endclass

`endif

