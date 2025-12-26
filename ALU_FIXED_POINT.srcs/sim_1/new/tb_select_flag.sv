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

    select_unit #(.N(N)) u_sel (
        .op(op),
        .y_algo(y_algo),
        .y_shf(y_shf),
        .y_log(y_log),
        .eq(eq), .lt(lt), .le(le),
        .y(y)
    );

    flag_unit #(.N(N)) u_flag (
        .y(y), .ovf_in(1'b0),
        .ovf(ovf), .z(z), .n(n)
    );

    initial begin
        y_algo = 100;
        y_shf  = 8;
        y_log  = 32'hFF;
        eq = 1; lt = 0; le = 1;

        op = 0; #10;
        op = 4; #10;
        op = 6; #10;
        op = 10; #10;

        $finish;
    end
endmodule

