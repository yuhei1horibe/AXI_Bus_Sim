

`ifndef INIT_TRANS_GUARD
`define INIT_TRANS_GUARD

`include "axi_base_trans.sv"

// Memory read/write transaction
class pwm_trans extends axi_base_trans;
    // transaction
    enum int unsigned {
        PWM_INIT = 0,
        PWM_VALUE,
        NUM_PWM_TRANS_TYPE
    } trans_type;

    const int unsigned t_type;

    static int arr_idx[NUM_PWM_TRANS_TYPE]   = {32'h00000000, 32'h00000000};
    static int rw_toggle[NUM_PWM_TRANS_TYPE] = {1'b0, 1'b0}; // 0: write, 1: read

    // PWM initialization
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
    function new(int unsigned t_type);
        this.t_type = t_type;

        case (this.t_type)
            PWM_INIT: begin
                if(arr_idx[PWM_INIT] >= 18) begin
                    target_addr = 7'h00;
                    mem_data    = 32'h00000000;
                end
                target_addr[6:0] = reg_init_values[arr_idx[PWM_INIT]].reg_addr;
                if(rw_toggle[PWM_INIT]) begin
                    arr_idx[PWM_INIT]  = arr_idx[PWM_INIT] + 1;
                end else begin
                    mem_data = reg_init_values[arr_idx[PWM_INIT]].reg_data;
                end
                rw           = rw_toggle[PWM_INIT];
                rw_toggle[PWM_INIT] = ~rw_toggle[PWM_INIT];
            end

            PWM_VALUE: begin
                // TODO
                target_addr  = 7'h00;
                mem_data     = 32'h00000000;
            end
            default: begin
                // TODO
                target_addr  = 7'h00;
                mem_data     = 32'h00000000;
            end
        endcase
    endfunction

    static function static int get_data_size(int unsigned t_type);
        case (t_type)
            PWM_INIT:
                return 18 * 2;
            PWM_VALUE:
                // TODO
                return 0;
            default:
                return 0;
        endcase
    endfunction
endclass

`endif

