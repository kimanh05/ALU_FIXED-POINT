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
// Top-level: ALU fixed-point 32-bit, tham s? hoá
// Q-format: m?c ??nh Q1.F (ví d? Q1.31 v?i N=32, F=31)
// Opcode mapping:
//   0:ADD 1:SUB 2:MUL 3:DIV
//   4:SHL 5:SHR
//   6:AND 7:OR  8:XOR 9:NOR
//   10:EQ  11:LT 12:LE
// ============================================================
module alu_fixed_point #(
    parameter int N    = 32,   // t?ng s? bit
    parameter int F    = 31,   // s? bit ph?n l?
    parameter bit SAT  = 1,    // saturation cho c?ng/tr?
    parameter int PIPE = 2     // pipeline cho nhánh nhân (2..3)
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 en,
    input  logic signed [N-1:0]  a,
    input  logic signed [N-1:0]  b,
    input  logic        [3:0]    op,
    output logic signed [N-1:0]  y,
    output logic                 ovf,   // overflow (add/sub/div0)
    output logic                 z,     // zero flag
    output logic                 n      // negative flag
);

    // --- ???ng s? h?c (add/sub/mul/div) ---
    logic signed [N-1:0] y_algo;
    logic                 ovf_algo;

    algorithm #(
        .N(N), .F(F), .SAT(SAT), .PIPE(PIPE)
    ) u_algorithm (
        .clk (clk),
        .rst_n (rst_n),
        .en  (en),
        .a   (a),
        .b   (b),
        .op  (op),
        .y   (y_algo),
        .ovf (ovf_algo)
    );

    // --- ???ng shift ---
    logic signed [N-1:0] y_shf;

    shift_unit #(.N(N)) u_shift (
        .a      (a),
        .shamt  (b[$clog2(N)-1:0]),
        .do_left(op == 4'd4), // 4: SHL, 5: SHR
        .y      (y_shf)
    );

    // --- ???ng logic ---
    logic signed [N-1:0] y_log;

    logic_unit #(.N(N)) u_logic (
        .a  (a),
        .b  (b),
        .op (op), // 6..9
        .y  (y_log)
    );

    // --- so sánh ---
    logic eq, lt, le;
    compare_unit #(.N(N)) u_cmp (
        .a (a),
        .b (b),
        .eq(eq),
        .lt(lt),
        .le(le)
    );

    // --- ch?n k?t qu? cu?i ---
    select_unit #(.N(N)) u_sel (
        .op    (op),
        .y_algo(y_algo),
        .y_shf (y_shf),
        .y_log (y_log),
        .eq    (eq),
        .lt    (lt),
        .le    (le),
        .y     (y)
    );

    // --- c? tr?ng thái ---
    flag_unit #(.N(N)) u_flags (
        .y     (y),
        .ovf_in(ovf_algo),
        .ovf   (ovf),
        .z     (z),
        .n     (n)
    );

endmodule

