`ifndef ENV_GUARD
`define ENV_GUARD

`include "axi_sequencer.sv"
`include "axi_driver.sv"

class environment;
    axi_sequencer  seq;
    axi_driver     axi_drv;

    // Mailbox
    mailbox        seq_mbox;

    // Interface
    virtual axi_if axi_vif;

    function new(virtual axi_if axi_vif);
        this.seq_mbox = new();
        this.seq      = new(seq_mbox);
        this.axi_drv  = new(axi_vif, seq_mbox);
    endfunction

    task pre_test();
        $display("Driver reset");
        axi_drv.reset();
    endtask

    // Test
    task test();
        $display("PWM init start");
        fork
            seq.pwm_init();
            axi_drv.axi_read_write();
        join_any
    endtask
endclass

`endif

