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

    logic clk = 0;
    logic rst_n = 0;
    logic en = 1;

    logic signed [N-1:0]   a, b;
    logic signed [2*N-1:0] p;

    // Clock generation: 100 MHz
    always #5 clk = ~clk;

    // DUT instantiation
    mul_core #(.N(N)) dut (
        .clk   (clk),
        .rst_n (rst_n),
        .en    (en),
        .a     (a),
        .b     (b),
        .p     (p)
    );

    initial begin
        // -------------------------------
        // Reset phase
        // -------------------------------
        rst_n = 0;
        a = 0; 
        b = 0;
        en = 1;
        #20;
        rst_n = 1;

        // -------------------------------
        // Test 1: Positive * Positive
        // 10 * 20 = 200
        // -------------------------------
        a = 10;
        b = 20;
        @(posedge clk); // wait for pipeline
        #1;

        // -------------------------------
        // Test 2: Negative * Positive
        // -5 * 7 = -35
        // -------------------------------
        a = -5;
        b = 7;
        @(posedge clk);
        #1;

        // -------------------------------
        // Test 3: Negative * Negative
        // -3 * -4 = 12
        // -------------------------------
        a = -3;
        b = -4;
        @(posedge clk);
        #1;

        // -------------------------------
        // Test 4: Zero multiplication
        // 0 * anything = 0
        // -------------------------------
        a = 0;
        b = 12345;
        @(posedge clk);
        #1;

        // -------------------------------
        // Test 5: Enable = 0 (hold output)
        // Output should remain unchanged
        // -------------------------------
        en = 0;
        a = 100;
        b = 100;
        @(posedge clk);
        #1;

        // Re-enable and compute again
        en = 1;
        @(posedge clk);
        #1;

        // -------------------------------
        // Test 6: Corner cases
        // Max positive * 1
        // -------------------------------
        a = 32'sh7FFFFFFF;
        b = 1;
        @(posedge clk);
        #1;

        // Min negative * 1
        a = 32'sh80000000;
        b = 1;
        @(posedge clk);
        #1;

        // -------------------------------
        // Finish simulation
        // -------------------------------
        $finish;
    end

endmodule
