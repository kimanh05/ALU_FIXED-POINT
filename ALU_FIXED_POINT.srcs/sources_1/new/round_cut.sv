`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:00:58 AM
// Design Name: 
// Module Name: round_cut
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


module round_cut #(
    parameter int N    = 32,
    parameter int F    = 31,
    parameter int PIPE = 2
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   en,
    input  logic signed [2*N-1:0]  p,
    output logic signed [N-1:0]    y
);

    // Rounding bias magnitude = 2^(F-1), aligned to the fractional LSB
    localparam logic [2*N-1:0] BIAS_MAG = {
        {(2*N-F){1'b0}},
        1'b1,
        {(F-1){1'b0}}
    };

    logic signed [2*N-1:0] p_biased;

    // Symmetric round-to-nearest
    //   p >= 0 : add bias
    //   p <  0 : subtract bias
    always_comb begin
        if (p[2*N-1]) begin
            p_biased = p - $signed(BIAS_MAG);
        end else begin
            p_biased = p + $signed(BIAS_MAG);
        end
    end

    // Optional intermediate pipeline stage
    logic signed [2*N-1:0] s1;

    generate
        if (PIPE >= 3) begin : GEN_PIPE3
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    s1 <= '0;
                end else if (en) begin
                    s1 <= p_biased;
                end
            end
        end else begin : GEN_PIPE2
            always_comb begin
                s1 = p_biased;
            end
        end
    endgenerate

    // Truncate to N bits after rounding
    logic signed [N-1:0] y_next;

    always_comb begin
        y_next = s1[F +: N];
    end

    // Final output register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y <= '0;
        end else if (en) begin
            y <= y_next;
        end
    end

endmodule