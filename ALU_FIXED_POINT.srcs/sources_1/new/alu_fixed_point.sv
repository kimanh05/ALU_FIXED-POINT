`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2025 05:30:58 PM
// Design Name: 
// Module Name: alu_fixed_point
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
// Fixed-point ALU top-level
// Q-format: Q1.F (default Q1.31)
// Opcode mapping:
//   0 : ADD
//   1 : SUB
//   2 : MUL
//   3 : DIV
//   4 : SHL
//   5 : SHR
//   6 : AND
//   7 : OR
//   8 : XOR
//   9 : NOR
//   10: EQ
//   11: LT
//   12: LE
// ============================================================
module alu_fixed_point #(
    parameter int N    = 32,
    parameter int F    = 31,
    parameter bit SAT  = 1,
    parameter int PIPE = 2
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 en,        // valid_in for new operation

    input  logic signed [N-1:0]  a,
    input  logic signed [N-1:0]  b,
    input  logic        [3:0]    op,

    output logic signed [N-1:0]  y,
    output logic                 ovf,
    output logic                 z,
    output logic                 n,
    output logic                 valid_out
);

    // ============================================================
    // Core ALU (fully pipelined inside algorithm)
    // ============================================================
    algorithm #(
        .N   (N),
        .F   (F),
        .SAT (SAT),
        .PIPE(PIPE)
    ) u_algorithm (
        .clk      (clk),
        .rst_n    (rst_n),
        .en       (en),
        .a        (a),
        .b        (b),
        .op       (op),
        .y        (y),
        .ovf      (ovf),
        .valid_out(valid_out)
    );

    // ============================================================
    // Status flags
    // - These flags are meaningful only when valid_out = 1
    // - Hold previous values when valid_out = 0 to avoid confusion/glitches
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            z <= 1'b0;
            n <= 1'b0;
        end else if (valid_out) begin
            z <= (y == '0);
            n <= y[N-1];
        end
    end

endmodule