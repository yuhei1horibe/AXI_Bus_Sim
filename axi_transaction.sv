

`ifndef TRANS_GUARD
`define TRANS_GUARD

// Memory read/write transaction
class axi_transaction;
    bit  [6:0]target_addr;
    bit [31:0]write_data;
    bit  rw;
    static int addr = 7'h0;
    static int data = 32'h0c;
    static int rw_toggle  = 1'b0; // 0: write, 1: read

    // Sequential access (NOTE: randomize() doesn't work)
    function new();
        target_addr[6:0] = addr;
        if(rw_toggle == 1) begin
            addr         = addr + 1;
        end else begin
            write_data   = data;
            data         = data + 32'hd;
        end
        rw               = rw_toggle;
        rw_toggle        = ~rw_toggle;
    endfunction
endclass

`endif

