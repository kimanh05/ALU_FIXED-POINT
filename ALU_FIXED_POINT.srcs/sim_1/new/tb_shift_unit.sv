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

    shift_unit #(.N(N)) dut (
        .a(a), .shamt(shamt), .do_left(do_left), .y(y)
    );

    initial begin
        a = 32'h0000_0001;
        shamt = 5;
        do_left = 1;
        #10;

        do_left = 0;
        #10;

        $finish;
    end
endmodule

