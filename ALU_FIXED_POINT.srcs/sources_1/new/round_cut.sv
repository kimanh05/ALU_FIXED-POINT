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
    parameter int PIPE = 2      // 2 ho?c 3
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   en,
    input  logic signed [2*N-1:0]  p,
    output logic signed [N-1:0]    y
);
    // bias magnitude = 1 << (F-1), canh ? LSB
    localparam logic [2*N-1:0] BIAS_MAG = {
        {(2*N-F){1'b0}},
        1'b1,
        {(F-1){1'b0}}
    };

    logic signed [2*N-1:0] p_biased;

    // round-to-nearest ??i x?ng:
    //   p >= 0 -> p + BIAS_MAG
    //   p <  0 -> p - BIAS_MAG
    always_comb begin
        if (p[2*N-1]) begin
            // s? âm
            p_biased = p - $signed(BIAS_MAG);
        end else begin
            // s? d??ng ho?c 0
            p_biased = p + $signed(BIAS_MAG);
        end
    end

    // stage trung gian (optional) gi?a bias và cut
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

    // c?t v? N-bit: l?y ?o?n [F +: N]
    logic signed [N-1:0] y_next;

    always_comb begin
        y_next = s1[F +: N];
    end

    // stage cu?i: ??ng ký output
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y <= '0;
        end else if (en) begin
            y <= y_next;
        end
    end

endmodule
