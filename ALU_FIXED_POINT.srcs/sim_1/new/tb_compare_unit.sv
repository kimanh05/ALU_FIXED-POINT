`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:57:24 AM
// Design Name: 
// Module Name: tb_compare_unit
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


module tb_compare_unit;
    localparam int N = 32;

    logic signed [N-1:0] a, b;
    logic eq, lt, le;

    compare_unit #(.N(N)) dut (
        .a(a), .b(b), .eq(eq), .lt(lt), .le(le)
    );

    initial begin
        a = 10; b = 10; #10;
        a = 5;  b = 10; #10;
        a = -3; b = -5; #10;
        $finish;
    end
endmodule

