

`ifndef TRANS_GUARD
`define TRANS_GUARD

// Memory read/write transaction
class axi_transaction;
    bit  [6:0]target_addr;
    bit [31:0]write_data;
    bit  rw;
    static int addr       = 7'h40;
    static int data       = 32'h04;
    static int rw_toggle  = 1'b0; // 0: write, 1: read

    // Sequential access (NOTE: randomize() doesn't work)
    function new();
        target_addr[6:0] = addr;
        if(rw_toggle) begin
            if((addr === 7'h40) || (addr === 7'h20)) begin
                addr = 7'h00;
            end else begin
                addr = addr + 4;
            end
        end else begin
            if(addr === 7'h40) begin
                write_data   = 32'hFFFFFFFF;
            end else begin
                write_data   = data;
            end
            data = 32'h000000FF & (data + 32'h0c);
        end
        rw           = rw_toggle;
        rw_toggle    = ~rw_toggle;
    endfunction
endclass

`endif

