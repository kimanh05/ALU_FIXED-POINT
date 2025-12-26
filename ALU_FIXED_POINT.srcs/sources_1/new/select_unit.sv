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
// Ch?n k?t qu? cu?i cùng theo opcode
//   0,1,2,3 -> y_algo (add/sub/mul/div)
//   4,5     -> y_shf
//   6..9    -> y_log
//   10      -> EQ  (LSB)
//   11      -> LT
//   12      -> LE
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
            4'd0, 4'd1, 4'd2, 4'd3: y = y_algo;
            4'd4, 4'd5:             y = y_shf;
            4'd6, 4'd7, 4'd8, 4'd9: y = y_log;
            4'd10:                  y = {{(N-1){1'b0}}, eq};
            4'd11:                  y = {{(N-1){1'b0}}, lt};
            4'd12:                  y = {{(N-1){1'b0}}, le};
            default:                y = '0;
        endcase
    end

endmodule

