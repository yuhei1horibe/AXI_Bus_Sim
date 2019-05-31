
`ifndef AXISEQ_GUARD
`define AXISEQ_GUARD

`include "pwm_trans.sv"
`include "intc_trans.sv"

// Memory access sequence generator
class axi_sequencer;
    // mailbox
    mailbox pwm_mbx;
    mailbox intc_mbx;

    // Transaction item
    pwm_trans  pwm_init_item;
    intc_trans intc_init_item;
    intc_trans intc_read_item;
    intc_trans intc_clear_item;

    function new(mailbox pwm_mbx, mailbox intc_mbx);
        this.pwm_mbx  = pwm_mbx;
        this.intc_mbx = intc_mbx;
    endfunction

    // PWM Initialization
    task pwm_init();
        repeat(pwm_trans::get_data_size(pwm_trans::PWM_INIT)) begin
            // Generate requests and push it to mailbox
            pwm_init_item = new(pwm_trans::PWM_INIT);
            pwm_mbx.put(pwm_init_item);
        end
    endtask

    // Interrupt Controller Initialization
    task intc_init();
        repeat(intc_trans::get_data_size(intc_trans::INTC_INIT)) begin
            // Generate requests and push it to mailbox
            intc_init_item = new(intc_trans::INTC_INIT);
            intc_mbx.put(intc_init_item);
        end
    endtask

    // Interrupt status read
    task intc_read_stat();
        repeat(intc_trans::get_data_size(intc_trans::INTC_READ_STAT)) begin
            // Generate requests and push it to mailbox
            intc_read_item = new(intc_trans::INTC_READ_STAT);
            intc_mbx.put(intc_read_item);
        end
    endtask

    // Interrupt Clear
    task intc_clear_int(int unsigned val);
        repeat(intc_trans::get_data_size(intc_trans::INTC_CLEAR_INT)) begin
            intc_clear_item = new(intc_trans::INTC_CLEAR_INT, val);
            intc_mbx.put(intc_clear_item);
        end
    endtask
endclass

`endif

