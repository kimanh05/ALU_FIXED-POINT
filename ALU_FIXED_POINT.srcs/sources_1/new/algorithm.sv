`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:21:35 AM
// Design Name: 
// Module Name: algorithm
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


// ============================================================
// Kh?i s? h?c: c?ng, tr?, nhân fixed-point, chia fixed-point
// ADD/SUB: saturate n?u SAT=1
// MUL:     dùng mul_unit (DSP + pipeline + round-to-nearest)
// DIV:     (a<<F)/b, clamp n?u chia 0
// ============================================================
module algorithm #(
    parameter int N    = 32,
    parameter int F    = 31,
    parameter bit SAT  = 1,
    parameter int PIPE = 2      // chuy?n ti?p cho mul_unit
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 en,
    input  logic signed [N-1:0]  a,
    input  logic signed [N-1:0]  b,
    input  logic        [3:0]    op,   // 0:add 1:sub 2:mul 3:div
    output logic signed [N-1:0]  y,
    output logic                 ovf
);

    // ------------ ADD ------------
    logic signed [N-1:0] y_add;
    logic                 ovf_add;

    add32 #(
        .N  (N),
        .SAT(SAT)
    ) u_add (
        .a  (a),
        .b  (b),
        .y  (y_add),
        .ovf(ovf_add)
    );

    // ------------ SUB ------------
    logic signed [N-1:0] y_sub;
    logic                 ovf_sub;

    sub32 #(
        .N  (N),
        .SAT(SAT)
    ) u_sub (
        .a  (a),
        .b  (b),
        .y  (y_sub),
        .ovf(ovf_sub)
    );

    // ------------ MUL ------------
    logic signed [N-1:0] y_mul;

    mul_unit #(
        .N   (N),
        .F   (F),
        .PIPE(PIPE)
    ) u_mul (
        .clk (clk),
        .rst_n(rst_n),
        .en  (en),
        .a   (a),
        .b   (b),
        .y   (y_mul)
    );

    // ------------ DIV ------------
    logic signed [N-1:0] y_div;
    logic                 ovf_div;

    div_unit #(
        .N(N),
        .F(F)
    ) u_div (
        .clk (clk),
        .rst_n(rst_n),
        .en  (en),
        .a   (a),
        .b   (b),
        .y   (y_div),
        .ovf (ovf_div)
    );

    // ------------ MUX theo opcode ------------
    always_comb begin
        unique case (op)
            4'd0: begin
                y   = y_add;
                ovf = ovf_add;
            end
            4'd1: begin
                y   = y_sub;
                ovf = ovf_sub;
            end
            4'd2: begin
                y   = y_mul;
                ovf = 1'b0;     // nhân không saturate, không báo ovf
            end
            4'd3: begin
                y   = y_div;
                ovf = ovf_div;
            end
            default: begin
                y   = '0;
                ovf = 1'b0;
            end
        endcase
    end

endmodule

