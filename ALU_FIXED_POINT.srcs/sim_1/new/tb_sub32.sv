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

    // DUT instantiation (saturation enabled)
    sub32 #(
        .N(N),
        .SAT(1)
    ) dut (
        .a(a),
        .b(b),
        .y(y),
        .ovf(ovf)
    );

    initial begin
        // -----------------------------
        // Normal subtraction (positive result)
        // 20 - 10 = 10
        // -----------------------------
        a = 20;
        b = 10;
        #10;

        // -----------------------------
        // Normal subtraction (negative result)
        // -10 - 20 = -30
        // -----------------------------
        a = -10;
        b = 20;
        #10;

        // -----------------------------
        // Zero result
        // 15 - 15 = 0
        // -----------------------------
        a = 15;
        b = 15;
        #10;

        // -----------------------------
        // Positive overflow
        // MAX + 1 (via subtraction)
        // (2^31 - 1) - (-1)
        // Expected: clamp to MAX, ovf = 1
        // -----------------------------
        a = 32'sh7FFFFFFF;
        b = -1;
        #10;

        // -----------------------------
        // Negative overflow
        // MIN - 1
        // Expected: clamp to MIN, ovf = 1
        // -----------------------------
        a = 32'sh80000000;
        b = 1;
        #10;

        // -----------------------------
        // Random normal case
        // -----------------------------
        a = 123456;
        b = -65432;
        #10;

        $finish;
    end

endmodule