
`ifndef MEMIF_GUARD
`define MEMIF_GUARD

interface axi_if(input logic clk, reset);
    logic [31:0] mem_data;
    logic [ 6:0] mem_addr;
    logic        ar_valid;
    logic        aw_valid;
    logic        ar_ready;
    logic        aw_ready;
    logic        wdata_valid; // Output to slave
    logic        rdata_valid; // Input from slave
    logic        wdata_ready; // Input from slave
    logic        rdata_ready; // Output to slave
    logic        b_valid;
    logic        b_ready;

    // Clocking block
    clocking driver_cb @(posedge clk);
        default input #10 output #10;
        output mem_data;
        output mem_addr;
        output ar_valid;
        output aw_valid;
        input  ar_ready;
        input  aw_ready;
        output wdata_valid;
        input  rdata_valid;
        input  wdata_ready;
        output rdata_ready;
        input  b_valid;
        output b_ready;
    endclocking

    clocking monitor_cb @(posedge clk);
        default input #1 output #1;
        input mem_data;
        input mem_addr;
        input ar_valid;
        input aw_valid;
        input ar_ready;
        input aw_ready;
        input wdata_valid;
        input rdata_valid;
        input wdata_ready;
        input rdata_ready;
        input b_valid;
        input b_ready;
    endclocking

    // modport
    modport DRIVER (clocking driver_cb, input clk, reset);
    modport MONITOR (clocking monitor_cb, input clk, reset);
endinterface

`endif


