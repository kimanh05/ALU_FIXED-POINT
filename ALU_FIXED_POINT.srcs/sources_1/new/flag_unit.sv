`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:19:18 AM
// Design Name: 
// Module Name: flag_unit
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

// ============================================================
// C? tr?ng thái:
//   ovf: t? add/sub ho?c div (chia 0)
//   z  : y == 0
//   n  : bit d?u c?a y
// ============================================================
module flag_unit #(
    parameter int N = 32
)(
    input  logic signed [N-1:0] y,
    input  logic                ovf_in,
    output logic                ovf,
    output logic                z,
    output logic                n
);
    assign ovf = ovf_in;
    assign z   = (y == '0);
    assign n   = y[N-1];

endmodule

