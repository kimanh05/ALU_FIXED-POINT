`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:00:58 AM
// Design Name: 
// Module Name: mul_unit
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


module mul_unit #(
    parameter int N    = 32,
    parameter int F    = 31,
    parameter int PIPE = 2       // t?ng stage: 2 ho?c 3
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 en,
    input  logic signed [N-1:0]  a,
    input  logic signed [N-1:0]  b,
    output logic signed [N-1:0]  y
);
    logic signed [2*N-1:0] p;

    mul_core #(
        .N(N)
    ) u_core (
        .clk (clk),
        .rst_n(rst_n),
        .en  (en),
        .a   (a),
        .b   (b),
        .p   (p)
    );

    round_cut #(
        .N   (N),
        .F   (F),
        .PIPE(PIPE)
    ) u_rc (
        .clk (clk),
        .rst_n(rst_n),
        .en  (en),
        .p   (p),
        .y   (y)
    );

endmodule
