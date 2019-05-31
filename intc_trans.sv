

`ifndef INTC_TRANS_GUARD
`define INTC_TRANS_GUARD

`include "axi_base_trans.sv"

// Memory read/write transaction
class intc_trans extends axi_base_trans;
    enum int unsigned
    {
        INTC_INIT = 0,
        INTC_READ_STAT,
        INTC_CLEAR_INT,
        NUM_INTC_TRANS
    } intc_trans_type;
    const int unsigned intc_t_type;
    static int arr_idx[NUM_INTC_TRANS]   = {0, 0, 0};
    static int rw_toggle[NUM_INTC_TRANS] = {0, 0, 0}; // 0: write, 1: read
    static struct {
        bit [ 6:0] reg_addr;
        bit [31:0] reg_data;
    } reg_init_values[5] = 
    {
        // Global enable
        { reg_addr:7'h00, reg_data:32'h00000001 },

        // Individual Interrupt Enable
        { reg_addr:7'h04, reg_data:32'h00000001 },

        // Interrupt Acknowledge (clear)
        { reg_addr:7'h0C, reg_data:32'hFFFFFFFF },

        // Interrupt Status (Read only)
        { reg_addr:7'h08, reg_data:32'h00000000 },

        // Interrupt Pending (Read only)
        { reg_addr:7'h10, reg_data:32'h00000000 }
    };

    // Sequential access (NOTE: randomize() doesn't work)
    function new(int unsigned intc_t_type, bit [31:0]val = 0);
        this.intc_t_type = intc_t_type;

        case (this.intc_t_type)
            INTC_INIT: begin
                if (arr_idx[INTC_INIT] < 3) begin
                    target_addr = reg_init_values[arr_idx[INTC_INIT]].reg_addr;
                    if(rw_toggle[INTC_INIT]) begin
                        arr_idx[INTC_INIT] = arr_idx[INTC_INIT] + 1;
                    end else begin
                        mem_data   = reg_init_values[arr_idx[INTC_INIT]].reg_data;
                    end
                    rw          = rw_toggle[INTC_INIT];
                    rw_toggle[INTC_INIT]   = ~rw_toggle[INTC_INIT];
                // Read only registers
                end else if(arr_idx[INTC_INIT] < 5) begin
                    target_addr = reg_init_values[arr_idx[INTC_INIT]].reg_addr;
                    mem_data  = 32'h00000000;
                    rw        = 1;
                    arr_idx[INTC_INIT] = arr_idx[INTC_INIT] + 1;
                end else if(arr_idx[INTC_INIT] >= 5) begin
                    target_addr = 7'h00;
                    mem_data  = 32'h00000000;
                    rw          = 1;
                end
            end

            INTC_READ_STAT: begin
                target_addr = 7'h10;
                mem_data    = 32'h00000000;
                rw          = 1;
            end

            INTC_CLEAR_INT: begin
                if(arr_idx[INTC_CLEAR_INT] == 0) begin
                    // Write
                    target_addr = 7'h0C;
                    mem_data    = val;
                    rw          = 0;
                    arr_idx[INTC_CLEAR_INT] = 1;
                end else begin
                    // Read
                    target_addr = 7'h10;
                    mem_data    = 32'h00000000;
                    rw          = 1;
                    arr_idx[INTC_CLEAR_INT] = 0;
                end
            end
            default: begin
            end
        endcase
    endfunction

    static function static int get_data_size(int unsigned t_type);
        case (t_type)
            INTC_INIT:
                return 3 * 2 + 2;
            INTC_READ_STAT:
                return 1;
            INTC_CLEAR_INT:
                return 2;
            default:
                return 0;
        endcase
    endfunction
endclass

`endif

