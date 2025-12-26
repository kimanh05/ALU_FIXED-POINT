`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:00:58 AM
// Design Name: 
// Module Name: mul_core
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


module mul_core #(
    parameter int N = 32
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 en,
    input  logic signed [N-1:0]  a,
    input  logic signed [N-1:0]  b,
    output logic signed [2*N-1:0] p
);
    (* use_dsp = "yes" *)
    logic signed [2*N-1:0] p_next;

    // combinational multiply -> DSP
    always_comb begin
        p_next = a * b;
    end

    // 1-stage pipeline
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p <= '0;
        end else if (en) begin
            p <= p_next;
        end
    end

endmodule
