`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_shift_unit
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_shift_unit
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


module tb_shift_unit;

    localparam int N = 32;

    logic signed [N-1:0] a;
    logic [$clog2(N)-1:0] shamt;
    logic do_left;
    logic signed [N-1:0] y;

    // ------------------------------------------------------------
    // DUT
    // ------------------------------------------------------------
    shift_unit #(.N(N)) dut (
        .a(a),
        .shamt(shamt),
        .do_left(do_left),
        .y(y)
    );

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------
    initial begin
        // ================================
        // Case 1: Left shift, positive
        // 1 <<< 5 = 32
        // ================================
        a       = 32'sd1;
        shamt   = 5;
        do_left = 1;
        #10;

        // ================================
        // Case 2: Right shift, positive
        // 32 >>> 5 = 1
        // ================================
        do_left = 0;
        #10;

        // ================================
        // Case 3: Right shift, negative
        // -32 >>> 2 = -8 (arithmetic shift)
        // ================================
        a       = -32'sd32;
        shamt   = 2;
        do_left = 0;
        #10;

        // ================================
        // Case 4: Left shift, negative
        // -1 <<< 4 = -16
        // ================================
        a       = -32'sd1;
        shamt   = 4;
        do_left = 1;
        #10;

        // ================================
        // Case 5: Shift by zero
        // ================================
        a       = 32'sh1234_5678;
        shamt   = 0;
        do_left = 1;
        #10;

        // ================================
        // End simulation
        // ================================
        $finish;
    end

endmodule

