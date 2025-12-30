`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:14:01 AM
// Design Name: 
// Module Name: compare_unit
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
// Signed comparison unit:
//   eq = (a == b)
//   lt = (a <  b)
//   le = (a <= b)
// ============================================================
module compare_unit #(
    parameter int N = 32
)(
    input  logic signed [N-1:0] a,
    input  logic signed [N-1:0] b,
    output logic                eq,
    output logic                lt,
    output logic                le
);

    assign eq = (a == b);
    assign lt = (a <  b);
    assign le = (a <= b);

endmodule

