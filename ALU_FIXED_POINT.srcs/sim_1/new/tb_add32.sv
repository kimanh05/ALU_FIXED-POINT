`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_add32
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


module tb_add32;
    localparam int N = 32;

    logic signed [N-1:0] a, b;
    logic signed [N-1:0] y;
    logic ovf;

    // Device Under Test (DUT)
    add32 #(
        .N(N),
        .SAT(1)
    ) dut (
        .a   (a),
        .b   (b),
        .y   (y),
        .ovf (ovf)
    );

    initial begin
        // -----------------------------
        // 1. Normal addition
        // -----------------------------
        a = 10;
        b = 20;
        #10;

        // -----------------------------
        // 2. Addition with zero
        // -----------------------------
        a = 12345;
        b = 0;
        #10;

        a = 0;
        b = -54321;
        #10;

        // -----------------------------
        // 3. Near maximum boundary (no overflow)
        // -----------------------------
        a = 32'sh7FFFFFFE;
        b = 1;
        #10;

        // -----------------------------
        // 4. Positive overflow (max + 1)
        // -----------------------------
        a = 32'sh7FFFFFFF;
        b = 1;
        #10;

        // -----------------------------
        // 5. Negative overflow (min - 1)
        // -----------------------------
        a = 32'sh80000000;
        b = -1;
        #10;

        // -----------------------------
        // 6. Negative + positive (no overflow)
        // -----------------------------
        a = -100;
        b = 50;
        #10;

        // -----------------------------
        // 7. Negative + negative (no overflow)
        // -----------------------------
        a = -100;
        b = -200;
        #10;

        $finish;
    end
endmodule
