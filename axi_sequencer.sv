
`ifndef AXISEQ_GUARD
`define AXISEQ_GUARD

`include "axi_transaction.sv"

// Memory access sequence generator
class axi_sequencer;
    // mailbox
    mailbox seq_mbx;

    // Transaction item
    axi_transaction tr_item;

    function new(mailbox seq_mbx);
        this.seq_mbx = seq_mbx;
    endfunction

    // AXI bus request
    task axi_request();
        repeat(34) begin
            // Generate requests and push it to mailbox
            tr_item = new();
            seq_mbx.put(tr_item);
        end
    endtask
endclass

`endif

