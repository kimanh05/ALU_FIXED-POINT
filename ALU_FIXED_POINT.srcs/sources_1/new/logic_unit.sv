`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:14:01 AM
// Design Name: 
// Module Name: logic_unit
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


// Opcode mapping:
//   4'd6 : AND
//   4'd7 : OR
//   4'd8 : XOR
//   4'd9 : NOR
//
// For unsupported opcodes, output is set to zero.
// ============================================================
module logic_unit #(
    parameter int N = 32
)(
    input  logic signed [N-1:0] a,
    input  logic signed [N-1:0] b,
    input  logic        [3:0]   op,
    output logic signed [N-1:0] y
);
    always_comb begin
        unique case (op)
            4'd6:  y = a & b;        // AND
            4'd7:  y = a | b;        // OR
            4'd8:  y = a ^ b;        // XOR
            4'd9:  y = ~(a | b);     // NOR
            default: y = '0;         // Default output
        endcase
    end
endmodule

