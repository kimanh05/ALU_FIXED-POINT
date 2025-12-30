`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_logic_unit
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


module tb_logic_unit;
    localparam int N = 32;

    logic signed [N-1:0] a, b;
    logic signed [N-1:0] y;
    logic [3:0] op;

    // DUT
    logic_unit #(.N(N)) dut (
        .a(a),
        .b(b),
        .op(op),
        .y(y)
    );

    initial begin
        // =====================================================
        // Test set 1: Pattern values
        // =====================================================
        a = 32'h0F0F_0F0F;
        b = 32'h00FF_00FF;

        op = 4'd6; #10; // AND
        op = 4'd7; #10; // OR
        op = 4'd8; #10; // XOR
        op = 4'd9; #10; // NOR

        // =====================================================
        // Test set 2: Zero values
        // =====================================================
        a = 32'd0;
        b = 32'd0;

        op = 4'd6; #10; // AND -> 0
        op = 4'd7; #10; // OR  -> 0
        op = 4'd8; #10; // XOR -> 0
        op = 4'd9; #10; // NOR -> all 1s

        // =====================================================
        // Test set 3: All ones (-1)
        // =====================================================
        a = -32'sd1;     // 0xFFFF_FFFF
        b = -32'sd1;

        op = 4'd6; #10; // AND -> all 1s
        op = 4'd7; #10; // OR  -> all 1s
        op = 4'd8; #10; // XOR -> 0
        op = 4'd9; #10; // NOR -> 0

        // =====================================================
        // Test set 4: Mixed sign
        // =====================================================
        a = -32'sd1;
        b = 32'd0;

        op = 4'd6; #10; // AND -> 0
        op = 4'd7; #10; // OR  -> all 1s
        op = 4'd8; #10; // XOR -> all 1s
        op = 4'd9; #10; // NOR -> 0

        // =====================================================
        // Test set 5: Invalid opcode
        // =====================================================
        a = 32'h1234_5678;
        b = 32'hFFFF_0000;
        op = 4'd0; #10; // default -> 0

        $finish;
    end
endmodule

