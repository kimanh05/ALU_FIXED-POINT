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

    logic clk = 0;
    logic rst_n = 0;
    logic en = 1;

    logic signed [N-1:0] a, b;
    logic signed [N-1:0] y;
    logic ovf;

    // Clock generation: 100 MHz
    always #5 clk = ~clk;

    div_unit #(
        .N(N),
        .F(F)
    ) dut (
        .clk (clk),
        .rst_n(rst_n),
        .en  (en),
        .a   (a),
        .b   (b),
        .y   (y),
        .ovf (ovf)
    );

    initial begin
        // ----------------------------
        // Reset
        // ----------------------------
        rst_n = 0;
        a = 0;
        b = 0;
        #20;
        rst_n = 1;

        // ----------------------------
        // 0.5 / 0.25 = 2.0
        // ----------------------------
        a = 32'sh4000_0000; //  0.5
        b = 32'sh2000_0000; //  0.25
        #10;

        // ----------------------------
        // -0.5 / 0.25 = -2.0
        // ----------------------------
        a = -32'sh4000_0000; // -0.5
        b =  32'sh2000_0000; //  0.25
        #10;

        // ----------------------------
        // -0.5 / -0.25 = +2.0
        // ----------------------------
        a = -32'sh4000_0000; // -0.5
        b = -32'sh2000_0000; // -0.25
        #10;

        // ----------------------------
        // 0.25 / 2.0 = 0.125
        // ----------------------------
        a = 32'sh2000_0000; // 0.25
        b = 32'sh8000_0000; // 2.0
        #10;

        // ----------------------------
        // Division by zero
        // ----------------------------
        a = 32'sh4000_0000; // 0.5
        b = 0;
        #10;

        // ----------------------------
        // Disable enable (output should hold)
        // ----------------------------
        en = 0;
        a  = 32'sh4000_0000;
        b  = 32'sh2000_0000;
        #20;
        en = 1;

        $finish;
    end
endmodule