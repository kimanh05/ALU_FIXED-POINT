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

    logic clk = 0;
    logic rst_n = 0;
    logic en = 1;

    logic signed [2*N-1:0] p;
    logic signed [N-1:0]   y;

    // Clock generation: 100 MHz
    always #5 clk = ~clk;

    // DUT instantiation
    round_cut #(
        .N(N),
        .F(F),
        .PIPE(2)
    ) dut (
        .clk   (clk),
        .rst_n (rst_n),
        .en    (en),
        .p     (p),
        .y     (y)
    );

    initial begin
        // -----------------------------
        // Reset phase
        // -----------------------------
        rst_n = 0;
        p = 0;
        en = 1;
        #15;
        rst_n = 1;

        // -----------------------------
        // Test 1: Positive rounding
        // 0.5 * 0.5 = 0.25
        // Expected output: 0.25 (Q1.31)
        // -----------------------------
        p = 64'sh2000_0000_0000_0000;
        @(posedge clk);
        #1;

        // -----------------------------
        // Test 2: Negative rounding
        // -0.5 * 0.5 = -0.25
        // Expected output: -0.25
        // -----------------------------
        p = -64'sh2000_0000_0000_0000;
        @(posedge clk);
        #1;

        // -----------------------------
        // Test 3: Rounding up (positive)
        // Value slightly above 0.25
        // -----------------------------
        p = 64'sh2000_0000_4000_0000;
        @(posedge clk);
        #1;

        // -----------------------------
        // Test 4: Rounding down (negative)
        // Value slightly below -0.25
        // -----------------------------
        p = -64'sh2000_0000_4000_0000;
        @(posedge clk);
        #1;

        // -----------------------------
        // Test 5: No rounding required
        // Exact representable value
        // -----------------------------
        p = 64'sh4000_0000_0000_0000; // 1.0 * 0.5 = 0.5
        @(posedge clk);
        #1;

        // -----------------------------
        // Test 6: Enable = 0 (hold output)
        // Output should remain unchanged
        // -----------------------------
        en = 0;
        p  = 64'sh6000_0000_0000_0000;
        @(posedge clk);
        #1;

        // Re-enable pipeline
        en = 1;
        @(posedge clk);
        #1;

        // -----------------------------
        // Finish simulation
        // -----------------------------
        $finish;
    end

endmodule