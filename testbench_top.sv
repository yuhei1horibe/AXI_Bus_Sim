`timescale 1 ns / 1 ps

`include "environment.sv"

module testbench_top ();
    // Signals
    bit [7:0]PWM_OUT;
    bit [31:0]rdata;
    bit  axi_aclk;
    bit  axi_aresetn;
    bit  [1:0]bresp;
    bit  [1:0]rresp;

    // Interface
    axi_if axi_if_inst[1:0](.clk(axi_aclk), .reset(axi_aresetn));

    // Class
    environment axi_test_env;

    // Clock generation
    always #50 axi_aclk = ~axi_aclk;

    // Reset
    initial begin
        axi_test_env = new(axi_if_inst[0]);

        axi_test_env.pre_test();
        axi_aresetn = 1'b0;
        #1000
        axi_aresetn = 1'b1;
        axi_test_env.test();
    end

    // Device Under test
    my_irq_v1_0 dut_irq(
        .PWM_OUT         (PWM_OUT),
        .s00_axi_aclk    (axi_aclk),
        .s00_axi_aresetn (axi_aresetn),
        .s00_axi_awaddr  (axi_if_inst[0].mem_addr),
        .s00_axi_awprot  (2'h0),
        .s00_axi_awvalid (axi_if_inst[0].aw_valid),
        .s00_axi_awready (axi_if_inst[0].aw_ready),
        .s00_axi_wdata   (axi_if_inst[0].mem_data),
        .s00_axi_wstrb   (4'hF),
        .s00_axi_wvalid  (axi_if_inst[0].aw_valid),
        .s00_axi_wready  (axi_if_inst[0].wdata_ready),
        .s00_axi_bresp   (bresp),
        .s00_axi_bvalid  (axi_if_inst[0].b_valid),
        .s00_axi_bready  (axi_if_inst[0].b_ready),
        .s00_axi_araddr  (axi_if_inst[0].mem_addr),
        //.s00_axi_araddr  (7'h00),
        .s00_axi_arprot  (2'h0),
        .s00_axi_arvalid (axi_if_inst[0].ar_valid),
        .s00_axi_arready (axi_if_inst[0].ar_ready),
        .s00_axi_rdata   (rdata),
        //.s00_axi_rdata   (axi_if_inst[0].mem_data),
        .s00_axi_rresp   (rresp),
        .s00_axi_rvalid  (axi_if_inst[0].rdata_valid),
        .s00_axi_rready  (axi_if_inst[0].rdata_ready)
                                                                  
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

