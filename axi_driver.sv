
`ifndef AXIDRV_GUARD
`define AXIDRV_GUARD

`include "axi_if.sv"

`define DRIV_IF axi_vif.DRIVER.driver_cb

class axi_driver #(type TRANS_TYPE);
    virtual axi_if axi_vif;
    mailbox seq_mbx;
    mailbox read_back_mbx;

    // Driver done event
    event     trans_done;

    function new(virtual axi_if axi_vif, mailbox seq_mbx, mailbox read_back_mbx, event trans_done);
        this.axi_vif          = axi_vif;
        this.seq_mbx          = seq_mbx;
        this.read_back_mbx    = read_back_mbx;
        this.trans_done       = trans_done;
    endfunction

    // Reset
    task reset();
        $display("Block is in reset");
        `DRIV_IF.write_data    <= 32'h00000000;
        `DRIV_IF.mem_addr    <= 7'h00;
        `DRIV_IF.ar_valid    <= 0;
        `DRIV_IF.aw_valid    <= 0;
        `DRIV_IF.wdata_valid <= 0;
        `DRIV_IF.rdata_ready <= 0;
        `DRIV_IF.b_ready     <= 0;
        while(axi_vif.reset)
            @ (posedge axi_vif.clk);
        $display("Block is out of reset");
    endtask

    // AXI transactions
    task axi_read_write();
        TRANS_TYPE trans_item;
        while(seq_mbx.try_get(trans_item)) begin
            // Write access
            if(trans_item.rw == 1'b0) begin
                $display("Write access");
                // Address request
                `DRIV_IF.ar_valid    <= 1'b0;
                `DRIV_IF.aw_valid    <= 1'b1;
                `DRIV_IF.wdata_valid <= 1'b1;
                `DRIV_IF.mem_addr    <= trans_item.target_addr;
                `DRIV_IF.write_data  <= trans_item.mem_data;
                $display("Write address: %x", trans_item.target_addr);
                $display("Write data: %x", trans_item.mem_data);
                @ (posedge (`DRIV_IF.wdata_ready && `DRIV_IF.aw_ready));
                `DRIV_IF.aw_valid    <= 1'b0;
                `DRIV_IF.wdata_valid <= 1'b0;
                `DRIV_IF.mem_addr    <= 7'h00;
                `DRIV_IF.write_data  <= 32'h00000000;
                @ (posedge `DRIV_IF.b_valid);
                `DRIV_IF.b_ready     <= 1'b1;
            // Read access
            end else begin
                $display("Read access");
                // Address request
                `DRIV_IF.aw_valid    <= 1'b0;
                `DRIV_IF.ar_valid    <= 1'b1;
                `DRIV_IF.mem_addr    <= trans_item.target_addr;
                @ (posedge `DRIV_IF.ar_ready);
                `DRIV_IF.ar_valid    <= 1'b0;
                `DRIV_IF.mem_addr    <= 7'h00;
                @ (posedge `DRIV_IF.rdata_valid);
                `DRIV_IF.rdata_ready <= 1'b1;
                trans_item.mem_data  <= `DRIV_IF.read_data;
                $display("Read address: %x", trans_item.target_addr);
                $display("Read data: %x", `DRIV_IF.read_data);
                read_back_mbx.put(trans_item);
            end
            @ (posedge axi_vif.clk);
            // Reset
            `DRIV_IF.aw_valid    <= 1'b0;
            `DRIV_IF.ar_valid    <= 1'b0;
            `DRIV_IF.wdata_valid <= 1'b0;
            `DRIV_IF.rdata_ready <= 1'b0;
            `DRIV_IF.b_ready     <= 1'b0;
            `DRIV_IF.rdata_ready <= 1'b0;
            @ (posedge axi_vif.clk);
            $display("End access");
        end
        ->trans_done;
        $display("End task");
    endtask
endclass

`endif

