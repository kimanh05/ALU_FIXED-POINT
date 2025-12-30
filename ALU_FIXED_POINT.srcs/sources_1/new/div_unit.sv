`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:14:01 AM
// Design Name: 
// Module Name: div_unit
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

module div_unit #(
    parameter int N = 32,
    parameter int F = 31
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 en,
    input  logic signed [N-1:0]  a,
    input  logic signed [N-1:0]  b,
    output logic signed [N-1:0]  y,
    output logic                 ovf
);

    // Maximum and minimum signed values for saturation
    localparam logic signed [N-1:0] MAXV = {1'b0, {(N-1){1'b1}}};
    localparam logic signed [N-1:0] MINV = {1'b1, {(N-1){1'b0}}};

    // Extended numerator to hold the scaled value
    logic signed [2*N-1:0] num;

    // Scale numerator by shifting left F bits
    always_comb begin
        num = $signed(a) <<< F;
    end

    // Registered output
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y   <= '0;
            ovf <= 1'b0;
        end else if (en) begin
            if (b == '0) begin
                // Division by zero: assert overflow and saturate output
                ovf <= 1'b1;
                y   <= a[N-1] ? MINV : MAXV;
            end else begin
                ovf <= 1'b0;
                y   <= num / $signed(b);
            end
        end
    end

endmodule
