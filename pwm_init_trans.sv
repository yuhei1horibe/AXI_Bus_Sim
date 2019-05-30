

`ifndef INIT_TRANS_GUARD
`define INIT_TRANS_GUARD


// Memory read/write transaction
class pwm_init_trans;
    bit  [6:0]target_addr;
    bit [31:0]mem_data;
    bit  rw;
    static int arr_idx    = 32'h00000000;
    static int rw_toggle  = 1'b0; // 0: write, 1: read
    static struct {
        bit [ 6:0] reg_addr;
        bit [31:0] reg_data;
    } reg_init_values[18] = 
    {
        // PWM Control Register
        { reg_addr:7'h40, reg_data:32'h00000000 },

        // PWM value registers
        { reg_addr:7'h00, reg_data:32'h00000002 },
        { reg_addr:7'h04, reg_data:32'h00000004 },
        { reg_addr:7'h08, reg_data:32'h00000008 },
        { reg_addr:7'h0C, reg_data:32'h00000010 },
        { reg_addr:7'h10, reg_data:32'h00000020 },
        { reg_addr:7'h14, reg_data:32'h00000040 },
        { reg_addr:7'h18, reg_data:32'h00000080 },
        { reg_addr:7'h1C, reg_data:32'h000000FF },

        // PWM range registers
        { reg_addr:7'h20, reg_data:32'h0000001F },
        { reg_addr:7'h24, reg_data:32'h0000001F },
        { reg_addr:7'h28, reg_data:32'h0000003F },
        { reg_addr:7'h2C, reg_data:32'h0000003F },
        { reg_addr:7'h30, reg_data:32'h0000007F },
        { reg_addr:7'h34, reg_data:32'h0000007F },
        { reg_addr:7'h38, reg_data:32'h000000FF },
        { reg_addr:7'h3C, reg_data:32'h000000FF },

        // PWM Control Register
        { reg_addr:7'h40, reg_data:32'h000000FF }
    };

    // Sequential access (NOTE: randomize() doesn't work)
    function new();
        if(arr_idx >= 18) begin
            target_addr = 7'h00;
            mem_data  = 32'h00000000;
        end
        target_addr[6:0] = reg_init_values[arr_idx].reg_addr;
        if(rw_toggle) begin
            arr_idx      = arr_idx + 1;
        end else begin
            mem_data   = reg_init_values[arr_idx].reg_data;
        end
        rw           = rw_toggle;
        rw_toggle    = ~rw_toggle;
    endfunction

    static function static int get_data_size();
        return 18 * 2;
    endfunction
endclass

`endif

