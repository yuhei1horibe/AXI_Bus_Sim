//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Yuhei Horibe
// 
// Create Date: 05/05/2019 04:51:20 PM
// Design Name: 
// Module Name: clock_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Clock divider
module clock_divider(
    input  clk_in,
    input  [32:0]clk_div,
    input  reset,
    output clk_out
);

    // 32 bit counter
    reg [32:0]counter_reg;
    reg       clk_out_reg;
    wire      trigger;

    // Update counter
    always @ (posedge clk_in or negedge reset) begin
        if(reset == 1'b0 || trigger == 1'b1) begin
            counter_reg <= 32'h00000000;
        end

        else begin
            counter_reg <= counter_reg + 1;
        end
    end
    assign trigger = counter_reg >= clk_div;

    // Output
    always @ (posedge trigger or negedge reset) begin
        if(reset == 1'b0) begin
            clk_out_reg <= 0;
        end

        else begin
            clk_out_reg <= ~clk_out_reg;
        end
    end
    assign clk_out = clk_out_reg;

endmodule

