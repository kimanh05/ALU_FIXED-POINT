`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:14:01 AM
// Design Name: 
// Module Name: shift_unit
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



module shift_unit #(
    parameter int N = 32
)(
    input  logic signed [N-1:0]  a,
    input  logic [$clog2(N)-1:0] shamt,
    input  logic                 do_left,
    output logic signed [N-1:0]  y
);

    // Combinational shift logic
    always_comb begin
        y = do_left ? (a <<< shamt) : (a >>> shamt);
    end

endmodule
