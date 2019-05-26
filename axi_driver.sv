
`ifndef AXIDRV_GUARD
`define AXIDRV_GUARD

`include "axi_if.sv"
`include "axi_transaction.sv"

`define DRIV_IF axi_vif.DRIVER.driver_cb

class axi_driver;
    virtual axi_if axi_vif;
    mailbox seq_mbx;

    int     repeat_cnt = 30;

    function new(virtual axi_if axi_vif, mailbox seq_mbx);
        this.axi_vif = axi_vif;
        this.seq_mbx = seq_mbx;
    endfunction

    // Reset
    task reset();
        $display("Block is in reset");
        `DRIV_IF.mem_data    <= 32'bz;
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
        repeat(repeat_cnt) begin
            axi_transaction trans_item;
            seq_mbx.get(trans_item);

            `DRIV_IF.mem_addr <= {25'h00000000, trans_item.target_addr};
            // Write access
            if(trans_item.rw == 1'b0) begin
                $display("Write access");
                // Address request
                `DRIV_IF.aw_valid <= 1'b1;
                `DRIV_IF.ar_valid <= 1'b0;
                `DRIV_IF.wdata_valid <= 1'b1;
                `DRIV_IF.mem_data    <= trans_item.write_data;
                `DRIV_IF.b_ready     <= 0;
                $display("Write address: %x", `DRIV_IF.mem_addr);
                $display("Write data: %x", trans_item.write_data);
                while(!(`DRIV_IF.wdata_ready && `DRIV_IF.aw_ready)) begin
                    @ (posedge axi_vif.clk);
                end
                `DRIV_IF.b_ready     <= 1'b1;
            // Read access
            end else begin
                $display("Read access");
                // Address request
                `DRIV_IF.aw_valid <= 1'b0;
                `DRIV_IF.ar_valid <= 1'b1;
                @ (posedge `DRIV_IF.ar_ready)
                    `DRIV_IF.ar_valid <= 1'b0;
                @ (posedge `DRIV_IF.rdata_valid)
                    `DRIV_IF.rdata_ready <= 1'b1;
                $display("Read address: %x", `DRIV_IF.mem_addr);
                $display("Read data: %x", `DRIV_IF.mem_data);
            end
            // Reset
            @ (posedge axi_vif.clk);
            `DRIV_IF.mem_addr    <= 6'h00;
            `DRIV_IF.mem_data    <= 32'bz;
            `DRIV_IF.aw_valid    <= 1'b0;
            `DRIV_IF.ar_valid    <= 1'b0;
            `DRIV_IF.wdata_valid <= 1'b0;
            `DRIV_IF.rdata_ready <= 1'b0;
            `DRIV_IF.b_ready     <= 1'b0;
            @ (posedge axi_vif.clk);
            $display("End access");
        end
        $display("End task");
    endtask
endclass

`endif

