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

module flag_unit #(
    parameter int N = 32
)(
    input  logic signed [N-1:0] y,
    input  logic                ovf_in,
    output logic                ovf,
    output logic                z,
    output logic                n
);

    // Overflow flag is forwarded from arithmetic/division unit
    assign ovf = ovf_in;

    // Zero flag is asserted when result equals zero
    assign z   = (y == '0);

    // Negative flag reflects the sign bit of the result
    assign n   = y[N-1];

endmodule
