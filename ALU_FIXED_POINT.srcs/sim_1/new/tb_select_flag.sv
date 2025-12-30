`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_select_flag
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


module tb_select_flag;
    localparam int N = 32;

    logic [3:0] op;
    logic signed [N-1:0] y_algo, y_shf, y_log, y;
    logic eq, lt, le;
    logic ovf, z, n;

    // ------------------------------------------------------------
    // DUTs
    // ------------------------------------------------------------
    select_unit #(.N(N)) u_sel (
        .op(op),
        .y_algo(y_algo),
        .y_shf(y_shf),
        .y_log(y_log),
        .eq(eq),
        .lt(lt),
        .le(le),
        .y(y)
    );

    flag_unit #(.N(N)) u_flag (
        .y(y),
        .ovf_in(1'b0),   // overflow is injected manually here
        .ovf(ovf),
        .z(z),
        .n(n)
    );

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------
    initial begin
        // Default values
        y_algo = 100;
        y_shf  = 8;
        y_log  = 32'h0000_00FF;
        eq = 1;
        lt = 0;
        le = 1;

        // --------------------------------------------------------
        // Arithmetic result
        // --------------------------------------------------------
        op = 4'd0;  // ADD/SUB/MUL/DIV
        #10;

        // Zero flag test
        y_algo = 0;
        #10;

        // Negative flag test
        y_algo = -5;
        #10;

        // --------------------------------------------------------
        // Shift result
        // --------------------------------------------------------
        y_shf = -16;
        op = 4'd4;  // SHL/SHR
        #10;

        // --------------------------------------------------------
        // Logic result
        // --------------------------------------------------------
        y_log = 32'hFFFF_FFFF;
        op = 4'd6;  // AND/OR/XOR/NOR
        #10;

        // --------------------------------------------------------
        // Compare results
        // --------------------------------------------------------
        eq = 1; lt = 0; le = 1;
        op = 4'd10; // EQ
        #10;

        eq = 0; lt = 1; le = 1;
        op = 4'd11; // LT
        #10;

        eq = 0; lt = 0; le = 1;
        op = 4'd12; // LE
        #10;

        $finish;
    end
endmodule
