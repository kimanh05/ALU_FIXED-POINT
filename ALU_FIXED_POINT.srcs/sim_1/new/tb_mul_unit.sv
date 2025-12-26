`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_mul_unit
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


module tb_mul_unit;
    localparam int N = 32;
    localparam int F = 31;

    logic clk = 0, rst_n = 0, en = 1;
    logic signed [N-1:0] a, b;
    logic signed [N-1:0] y;

    always #5 clk = ~clk;

    mul_unit #(.N(N), .F(F), .PIPE(2)) dut (
        .clk(clk), .rst_n(rst_n), .en(en),
        .a(a), .b(b), .y(y)
    );

    initial begin
        rst_n = 0;
        #20 rst_n = 1;

        // 0.5 * 0.5
        a = 32'sh4000_0000;
        b = 32'sh4000_0000;
        #30;

        // -1 * 0.25
        a = -32'sh8000_0000;
        b = 32'sh2000_0000;
        #30;

        $finish;
    end
endmodule

