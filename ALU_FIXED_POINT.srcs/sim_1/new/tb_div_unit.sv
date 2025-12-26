`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_div_unit
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


module tb_div_unit;
    localparam int N = 32;
    localparam int F = 31;

    logic clk = 0, rst_n = 0, en = 1;
    logic signed [N-1:0] a, b;
    logic signed [N-1:0] y;
    logic ovf;

    always #5 clk = ~clk;

    div_unit #(.N(N), .F(F)) dut (
        .clk(clk), .rst_n(rst_n), .en(en),
        .a(a), .b(b), .y(y), .ovf(ovf)
    );

    initial begin
        rst_n = 0;
        #20 rst_n = 1;

        // 0.5 / 0.25 = 2.0
        a = 32'sh4000_0000;
        b = 32'sh2000_0000;
        #10;

        // chia 0
        a = 32'sh4000_0000;
        b = 0;
        #10;

        $finish;
    end
endmodule
