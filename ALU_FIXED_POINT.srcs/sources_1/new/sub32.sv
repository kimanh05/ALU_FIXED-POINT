`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 04:54:54 AM
// Design Name: 
// Module Name: sub32
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


module sub32 #(
    parameter int N   = 32,
    parameter bit SAT = 1
)(
    input  logic signed [N-1:0] a,
    input  logic signed [N-1:0] b,
    output logic signed [N-1:0] y,
    output logic                ovf
);
    // Extended subtraction (N+1 bits) with sign extension
    logic signed [N:0] s_ext;

    // Perform signed subtraction with sign extension
    assign s_ext = {a[N-1], a} - {b[N-1], b};

    // Signed overflow detection:
    // Overflow occurs when the extended MSB differs from the result sign bit
    assign ovf = (s_ext[N] != s_ext[N-1]);

    // Saturation logic (optional)
    if (SAT) begin : WITH_SAT
        // Maximum and minimum signed values for N-bit data
        localparam logic signed [N-1:0] MAXV = {1'b0, {(N-1){1'b1}}};
        localparam logic signed [N-1:0] MINV = {1'b1, {(N-1){1'b0}}};

        always_comb begin
            if (ovf) begin
                // Negative overflow -> clamp to MINV
                // Positive overflow -> clamp to MAXV
                y = s_ext[N] ? MINV : MAXV;
            end else begin
                // No overflow: take the lower N bits as result
                y = s_ext[N-1:0];
            end
        end
    end else begin : NO_SAT
        always_comb begin
            // No saturation: wrap-around behavior
            y = s_ext[N-1:0];
        end
    end

endmodule
