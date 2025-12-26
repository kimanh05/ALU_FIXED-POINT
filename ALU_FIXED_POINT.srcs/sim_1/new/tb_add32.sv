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

    add32 #(.N(N), .SAT(1)) dut (
        .a(a), .b(b), .y(y), .ovf(ovf)
    );

    initial begin
        // bình th??ng
        a = 10; b = 20; #10;
        // overflow d??ng
        a = 32'sh7FFFFFFF; b = 1; #10;
        // overflow âm
        a = 32'sh80000000; b = -1; #10;
        // âm + d??ng
        a = -100; b = 50; #10;

        $finish;
    end
endmodule

