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

    logic signed [N-1:0] a, b, y;
    logic [3:0] op;

    logic_unit #(.N(N)) dut (
        .a(a), .b(b), .op(op), .y(y)
    );

    initial begin
        a = 32'h0F0F_0F0F;
        b = 32'h00FF_00FF;

        op = 6; #10; // AND
        op = 7; #10; // OR
        op = 8; #10; // XOR
        op = 9; #10; // NOR

        $finish;
    end
endmodule

