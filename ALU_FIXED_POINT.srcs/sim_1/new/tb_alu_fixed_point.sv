`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2025 05:16:56 PM
// Design Name: 
// Module Name: tb_alu_fixed_point
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


`timescale 1ns/1ps

module tb_alu_fixed_point;

    // ================== PARAMETER ==================
    localparam int N = 32;
    localparam int F = 31;   // Q1.31

    // ================== SIGNAL ==================
    logic clk;
    logic rst_n;
    logic en;

    logic signed [N-1:0] a, b;
    logic [3:0] op;

    logic signed [N-1:0] y;
    logic ovf, z, n;

    // ================== DUT ==================
    alu_fixed_point #(
        .N(N),
        .F(F),
        .SAT(1),
        .PIPE(2)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .a(a),
        .b(b),
        .op(op),
        .y(y),
        .ovf(ovf),
        .z(z),
        .n(n)
    );

    // ================== CLOCK ==================
    always #5 clk = ~clk;   // 100 MHz

    // ================== TASK ==================
    task apply_op(
        input [3:0] opcode,
        input signed [N-1:0] va,
        input signed [N-1:0] vb
    );
    begin
        @(negedge clk);
        op <= opcode;
        a  <= va;
        b  <= vb;
        en <= 1'b1;
    end
    endtask

    // ================== TEST SEQUENCE ==================
    initial begin
        // init
        clk   = 0;
        rst_n = 0;
        en    = 0;
        a     = 0;
        b     = 0;
        op    = 0;

        // reset
        #20;
        rst_n = 1;

        // ================= ADD =================
        // 0.5 + 0.25 = 0.75
        apply_op(4'd0, 32'sh4000_0000, 32'sh2000_0000);
        #20;

        // ================= SUB =================
        // 0.5 - 0.25 = 0.25
        apply_op(4'd1, 32'sh4000_0000, 32'sh2000_0000);
        #20;

        // ================= MUL =================
        // 0.5 * 0.5 = 0.25
        apply_op(4'd2, 32'sh4000_0000, 32'sh4000_0000);
        #40; // mul có pipeline

        // ================= DIV =================
        // 0.5 / 0.25 = 2.0
        apply_op(4'd3, 32'sh4000_0000, 32'sh2000_0000);
        #40;

        // ================= SHL =================
        apply_op(4'd4, 32'sh0000_0001, 32'sd2); // 1 << 2 = 4
        #20;

        // ================= SHR =================
        apply_op(4'd5, -32'sd8, 32'sd1); // -8 >> 1 = -4
        #20;

        // ================= AND =================
        apply_op(4'd6, 32'hAA55_AA55, 32'h0F0F_0F0F);
        #20;

        // ================= OR =================
        apply_op(4'd7, 32'hAA55_AA55, 32'h0F0F_0F0F);
        #20;

        // ================= XOR =================
        apply_op(4'd8, 32'hFFFF_0000, 32'h00FF_00FF);
        #20;

        // ================= NOR =================
        apply_op(4'd9, 32'hFFFF_0000, 32'h0000_FFFF);
        #20;

        // ================= EQ =================
        apply_op(4'd10, 32'sd10, 32'sd10);
        #20;

        // ================= LT =================
        apply_op(4'd11, -32'sd5, 32'sd3);
        #20;

        // ================= LE =================
        apply_op(4'd12, 32'sd7, 32'sd7);
        #20;

        // ================= END =================
        en = 0;
        #50;
        $finish;
    end

endmodule

