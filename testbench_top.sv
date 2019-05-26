`timescale 1 ns / 1 ps

`include "environment.sv"

module testbench_top ();
    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter integer C_S00_AXI_DATA_WIDTH    = 32;
    parameter integer C_S00_AXI_ADDR_WIDTH    = 7;

    // Parameters of Axi Slave Bus Interface S_AXI_INTR
    parameter integer C_S_AXI_INTR_DATA_WIDTH = 32;
    parameter integer C_S_AXI_INTR_ADDR_WIDTH = 5;
    parameter integer C_NUM_OF_INTR           = 1;
    parameter  C_INTR_SENSITIVITY             = 32'hFFFFFFFF;
    parameter  C_INTR_ACTIVE_STATE            = 32'hFFFFFFFF;
    parameter integer C_IRQ_SENSITIVITY       = 1;
    parameter integer C_IRQ_ACTIVE_STATE      = 1;

    // Signals
    bit [7:0]PWM_OUT;
    bit [31:0]rdata;
    bit  axi_aclk;
    bit  axi_aresetn;
    bit  bresp;
    bit  bvalid;
    bit  bready;
    bit  rresp;

    // Interface
    axi_if axi_if_inst(.clk(axi_aclk), .reset(axi_aresetn));

    // Class
    environment axi_test_env;

    // Clock generation
    always #50 axi_aclk = ~axi_aclk;

    // Reset
    initial begin
        axi_test_env = new(axi_if_inst);

        axi_test_env.pre_test();
        axi_aresetn = 1'b0;
        #1000
        axi_aresetn = 1'b1;
        axi_test_env.test();
    end

    // Device Under test
    my_irq_v1_0 dut_irq(
        .s00_axi_aclk    (axi_aclk),
        .s00_axi_aresetn (axi_aresetn),
        .s00_axi_awaddr  (axi_if_inst.mem_addr),
        .s00_axi_awprot  (2'h0),
        .s00_axi_awvalid (axi_if_inst.aw_valid),
        .s00_axi_awready (axi_if_inst.aw_ready),
        .s00_axi_wdata   (axi_if_inst.mem_data),
        .s00_axi_wstrb   (4'h0),
        .s00_axi_wvalid  (axi_if_inst.aw_valid),
        .s00_axi_wready  (axi_if_inst.wdata_ready),
        .s00_axi_bresp   (bresp),
        .s00_axi_bvalid  (axi_if_inst.b_valid),
        .s00_axi_bready  (axi_if_inst.b_ready),
        .s00_axi_araddr  (axi_if_inst.mem_addr),
        .s00_axi_arprot  (2'h0),
        .s00_axi_arvalid (axi_if_inst.ar_valid),
        .s00_axi_arready (axi_if_inst.ar_ready),
        .s00_axi_rdata   (rdata),
        .s00_axi_rresp   (rresp),
        .s00_axi_rvalid  (axi_if_inst.rdata_valid),
        .s00_axi_rready  (axi_if_inst.rdata_ready)
                                                                  
        // Ports of Axi Slave Bus Interface S_AXI_INTR            // Ports of Axi Slave Bus Interface S_AXI_INTR
        //.s_axi_intr_aclk    (axi_aclk),
        //.s_axi_intr_aresetn (axi_aresetn),
        //.s_axi_intr_awaddr  (5'h00),
        //.s_axi_intr_awprot  (2'h0),
        //.s_axi_intr_awvalid (1'b0),
        //.s_axi_intr_awready (1'b0),
        //.s_axi_intr_wdata   (32'h00000000),
        //.s_axi_intr_wstrb   (4'h0),
        //.s_axi_intr_wvalid  (1'b0),
        //.s_axi_intr_wready  (1'b0),
        //.s_axi_intr_bresp   (1'b0),
        //.s_axi_intr_bvalid  (1'b0),
        //.s_axi_intr_bready  (1'b0),
        //.s_axi_intr_araddr  (1'b0),
        //.s_axi_intr_arprot  (2'h0),
        //.s_axi_intr_arvalid (1'b0),
        //.s_axi_intr_arready (1'b0),
        //.s_axi_intr_rdata   (32'h00000000),
        //.s_axi_intr_rresp   (1'b0),
        //.s_axi_intr_rvalid  (1'b0),
        //.s_axi_intr_rready  (1'b0),
        //.irq                (1'b0)
    );
endmodule

