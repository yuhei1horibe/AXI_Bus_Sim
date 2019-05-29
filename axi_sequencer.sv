
`ifndef AXISEQ_GUARD
`define AXISEQ_GUARD

`include "pwm_init_trans.sv"
`include "intc_init_trans.sv"

// Memory access sequence generator
class axi_sequencer;
    // mailbox
    mailbox init_mbx;
    mailbox intc_init_mbx;

    // Transaction item
    pwm_init_trans  pwm_init_item;
    intc_init_trans intc_init_item;

    function new(mailbox init_mbx, mailbox intc_init_mbx);
        this.init_mbx      = init_mbx;
        this.intc_init_mbx = intc_init_mbx;
    endfunction

    // PWM Initialization
    task pwm_init();
        repeat(pwm_init_trans::get_data_size()) begin
            // Generate requests and push it to mailbox
            pwm_init_item = new();
            init_mbx.put(pwm_init_item);
        end
    endtask

    // Interrupt Controller Initialization
    task intc_init();
        repeat(intc_init_trans::get_data_size()) begin
            // Generate requests and push it to mailbox
            intc_init_item = new();
            intc_init_mbx.put(intc_init_item);
        end
    endtask
endclass

`endif

