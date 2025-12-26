`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_round_cut
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


module tb_round_cut;
    localparam int N = 32;
    localparam int F = 31;

    logic clk = 0, rst_n = 0, en = 1;
    logic signed [2*N-1:0] p;
    logic signed [N-1:0] y;

    always #5 clk = ~clk;

    round_cut #(.N(N), .F(F), .PIPE(2)) dut (
        .clk(clk), .rst_n(rst_n), .en(en),
        .p(p), .y(y)
    );

    initial begin
        rst_n = 0;
        #15 rst_n = 1;

        // 0.5 * 0.5 = 0.25 (Q1.31)
        p = 64'sh2000_0000_0000_0000;
        #10;

        // -0.5 * 0.5 = -0.25
        p = -64'sh2000_0000_0000_0000;
        #20;

        $finish;
    end
endmodule

