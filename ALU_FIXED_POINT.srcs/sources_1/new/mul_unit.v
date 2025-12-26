`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 12:18:20 PM
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


module mul_unit #
(
    parameter N    = 32,
    parameter F    = 31,
    parameter PIPE = 2
)
(
    input                   clk, rst_n, en,
    input  signed [N-1:0]   a, b,
    output signed [N-1:0]   y
);
    wire signed [2*N-1:0] p;
    mul_core  #(.N(N)) u_core (.clk(clk), .rst_n(rst_n), .en(en), .a(a), .b(b), .p(p));
    round_cut #(.N(N), .F(F), .PIPE(PIPE)) u_rc (.clk(clk), .rst_n(rst_n), .en(en), .p(p), .y(y));
endmodule

