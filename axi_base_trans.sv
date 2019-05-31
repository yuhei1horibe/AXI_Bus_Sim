

`ifndef BASE_TRANS_GUARD
`define BASE_TRANS_GUARD


// AXI transaction base class
class axi_base_trans;
    bit  [6:0] target_addr;
    bit [31:0] mem_data;
    bit        rw;

    // Sequential access (NOTE: randomize() doesn't work)
    function new();
        target_addr = 7'h0;
        mem_data    = 32'h0;
        rw          = 1'b1;  // Defaulted to read transaction
    endfunction
endclass

`endif

