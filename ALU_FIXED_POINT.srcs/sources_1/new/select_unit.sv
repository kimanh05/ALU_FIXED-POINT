`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:14:01 AM
// Design Name: 
// Module Name: select_unit
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
// Result selection based on opcode:
//   0,1,2,3 -> Arithmetic result (ADD/SUB/MUL/DIV)
//   4,5     -> Shift result (SHL/SHR)
//   6..9    -> Logic result (AND/OR/XOR/NOR)
//   10      -> EQ result (LSB = eq)
//   11      -> LT result (LSB = lt)
//   12      -> LE result (LSB = le)
// ============================================================
module select_unit #(
    parameter int N = 32
)(
    input  logic        [3:0]   op,
    input  logic signed [N-1:0] y_algo,
    input  logic signed [N-1:0] y_shf,
    input  logic signed [N-1:0] y_log,
    input  logic                eq,
    input  logic                lt,
    input  logic                le,
    output logic signed [N-1:0] y
);

    always_comb begin
        unique case (op)
            4'd0, 4'd1, 4'd2, 4'd3: y = y_algo; // arithmetic
            4'd4, 4'd5:             y = y_shf;  // shift
            4'd6, 4'd7, 4'd8, 4'd9: y = y_log;  // logic
            4'd10:                  y = {{(N-1){1'b0}}, eq}; // equal
            4'd11:                  y = {{(N-1){1'b0}}, lt}; // less than
            4'd12:                  y = {{(N-1){1'b0}}, le}; // less or equal
            default:                y = '0;
        endcase
    end

endmodule
