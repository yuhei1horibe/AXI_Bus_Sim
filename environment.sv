`ifndef ENV_GUARD
`define ENV_GUARD

`include "axi_sequencer.sv"
`include "axi_driver.sv"

class environment;
    axi_sequencer                seq;
    axi_driver axi_pwm_drv;  // For PWM
    axi_driver axi_intc_drv; // For INTC

    intc_trans intc_int_stat;
    intc_trans intc_clear_item;

    enum int unsigned {
        CMD_MBX = 0,
        RB_MBX,
        NUM_MBOX_TYPE
    } mbox_type;

    // Events
    event      pwm_init_done;
    event      intc_init_done;

    // Mailbox
    mailbox    pwm_mbox[NUM_MBOX_TYPE];
    mailbox    intc_mbox[NUM_MBOX_TYPE];

    // Interface
    virtual    axi_if axi_vif;

    function new(virtual axi_if axi_vif[2]);
        this.pwm_mbox[CMD_MBX]  = new();
        this.pwm_mbox[RB_MBX]   = new();
        this.intc_mbox[CMD_MBX] = new();
        this.intc_mbox[RB_MBX]  = new();
        this.seq                = new(pwm_mbox[CMD_MBX], intc_mbox[CMD_MBX]);
        this.axi_pwm_drv        = new(axi_vif[0], pwm_mbox[CMD_MBX], pwm_mbox[RB_MBX], pwm_init_done);
        this.axi_intc_drv       = new(axi_vif[1], intc_mbox[CMD_MBX], intc_mbox[RB_MBX], intc_init_done);
    endfunction

    task module_reset();
        $display("PWM Driver reset");
        axi_pwm_drv.reset();
        $display("INTC Driver reset");
        axi_intc_drv.reset();
    endtask

    // Initialization for all block
    task module_init();
        pwm_trans  pwm_read_back;
        intc_trans intc_read_back;

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

        // Print read back
        $display("PWM read back");
        while(pwm_mbox[RB_MBX].try_get(pwm_read_back)) begin
            $display("Read address: %x", pwm_read_back.target_addr);
            $display("Read data: %x", pwm_read_back.mem_data);
        end

        $display("INTC read back");
        while(intc_mbox[RB_MBX].try_get(intc_read_back)) begin
            $display("Read address: %x", intc_read_back.target_addr);
            $display("Read data: %x", intc_read_back.mem_data);
        end
    endtask

    // Read interrupt status, then clear all of them
    task all_int_clear();
        fork
            seq.intc_read_stat();
            axi_intc_drv.axi_read_write();
        join_any

        wait(intc_init_done.triggered);
        while(intc_mbox[RB_MBX].try_get(intc_int_stat)) begin
            $display("Read address: %x", intc_int_stat.target_addr);
            $display("Read data: %x", intc_int_stat.mem_data);
        end

        fork
            seq.intc_clear_int(intc_int_stat.mem_data);
            axi_intc_drv.axi_read_write();
        join_any

        wait(intc_init_done.triggered);
        $display("INTC read back");
        while(intc_mbox[RB_MBX].try_get(intc_clear_item)) begin
            $display("Read address: %x", intc_clear_item.target_addr);
            $display("Read data: %x", intc_clear_item.mem_data);
        end
        wait(intc_init_done.triggered);
    endtask
endclass

`endif

