`ifndef ENV_GUARD
`define ENV_GUARD

`include "axi_sequencer.sv"
`include "axi_driver.sv"

class environment;
    axi_sequencer                seq;
    axi_driver#(pwm_init_trans)  axi_pwm_drv;  // For PWM
    axi_driver#(intc_init_trans) axi_intc_drv; // For INTC

    // Events
    event          pwm_init_done;
    event          intc_init_done;

    // Mailbox
    mailbox        pwm_mbox;
    mailbox        intc_mbox;

    // Interface
    virtual axi_if axi_vif;

    function new(virtual axi_if axi_vif[1:0]);
        this.pwm_mbox     = new();
        this.intc_mbox    = new();
        this.seq          = new(pwm_mbox, intc_mbox);
        this.axi_pwm_drv  = new(axi_vif[0], pwm_mbox, pwm_init_done);
        this.axi_intc_drv = new(axi_vif[1], intc_mbox, intc_init_done);
    endfunction

    task module_reset();
        $display("PWM Driver reset");
        axi_pwm_drv.reset();
        $display("INTC Driver reset");
        axi_intc_drv.reset();
    endtask

    // Initialization for all block
    task module_init();
        $display("Module init start");
        fork
            seq.pwm_init();
            seq.intc_init();
            axi_pwm_drv.axi_read_write();
            axi_intc_drv.axi_read_write();
        join_any

        // TODO: Combine those 2
        wait(intc_init_done.triggered)
        wait(pwm_init_done.triggered);
    endtask
endclass

`endif

