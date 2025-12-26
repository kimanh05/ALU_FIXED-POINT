`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_sub32
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


module tb_sub32;
    localparam int N = 32;

    logic signed [N-1:0] a, b;
    logic signed [N-1:0] y;
    logic ovf;

    sub32 #(.N(N), .SAT(1)) dut (
        .a(a), .b(b), .y(y), .ovf(ovf)
    );

    initial begin
        a = 20; b = 10; #10;
        a = -10; b = 20; #10;
        a = 32'sh80000000; b = 1; #10; // overflow
        $finish;
    end
endmodule
