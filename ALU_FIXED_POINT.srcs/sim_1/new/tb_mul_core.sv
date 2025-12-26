`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_mul_core
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


module tb_mul_core;
    localparam int N = 32;

    logic clk = 0, rst_n = 0, en = 1;
    logic signed [N-1:0] a, b;
    logic signed [2*N-1:0] p;

    always #5 clk = ~clk;

    mul_core #(.N(N)) dut (
        .clk(clk), .rst_n(rst_n), .en(en),
        .a(a), .b(b), .p(p)
    );

    initial begin
        rst_n = 0;
        a = 0; b = 0;
        #20 rst_n = 1;

        a = 10; b = 20;
        #10;

        a = -5; b = 7;
        #10;

        a = -3; b = -4;
        #20;

        $finish;
    end
endmodule

