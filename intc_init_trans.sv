

`ifndef INTC_TRANS_GUARD
`define INTC_TRANS_GUARD

// Memory read/write transaction
class intc_init_trans;
    bit  [6:0]target_addr;
    bit [31:0]write_data;
    bit  rw;
    static int arr_idx    = 32'h00000000;
    static int rw_toggle  = 1'b0; // 0: write, 1: read
    static struct {
        bit [ 6:0] reg_addr;
        bit [31:0] reg_data;
    } reg_init_values[4:0] = 
    {
        // Interrupt Pending (Read only)
        { reg_addr:7'h10, reg_data:32'h00000000 },

        // Interrupt Status (Read only)
        { reg_addr:7'h08, reg_data:32'h00000000 },

        // Interrupt Acknowledge (clear)
        { reg_addr:7'h0C, reg_data:32'hFFFFFFFF },

        // Individual Interrupt Enable
        { reg_addr:7'h04, reg_data:32'h00000001 },

        // Global enable
        { reg_addr:7'h00, reg_data:32'h00000001 }
    };

    // Sequential access (NOTE: randomize() doesn't work)
    function new();
        // Read only registers
        if(arr_idx >= 3) begin
            target_addr = reg_init_values[arr_idx].reg_addr;
            write_data  = 32'h00000000;
            rw          = 1;
            arr_idx     = arr_idx + 1;
        end else if(arr_idx >= 5) begin
            target_addr = 7'h00;
            write_data  = 32'h00000000;
        end
        target_addr[6:0] = reg_init_values[arr_idx].reg_addr;
        if(rw_toggle) begin
            arr_idx      = arr_idx + 1;
        end else begin
            write_data   = reg_init_values[arr_idx].reg_data;
        end
        rw           = rw_toggle;
        rw_toggle    = ~rw_toggle;
    endfunction

    static function static int get_data_size();
        return 4 * 2 + 2;
    endfunction
endclass

`endif

