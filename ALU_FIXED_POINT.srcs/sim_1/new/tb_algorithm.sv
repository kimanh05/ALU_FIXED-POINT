`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2025 07:16:54 PM
// Design Name: 
// Module Name: tb_algorithm
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





module tb_algorithm;

  // ------------------------------------------------------------
  // Parameters
  // ------------------------------------------------------------
  localparam int N    = 32;
  localparam int F    = 31;
  localparam int PIPE = 2;

  // ------------------------------------------------------------
  // Signals
  // ------------------------------------------------------------
  logic clk = 0;
  logic rst_n = 0;
  logic en;

  logic signed [N-1:0] a, b;
  logic [3:0] op;

  logic signed [N-1:0] y;
  logic ovf, valid_out;

  // ------------------------------------------------------------
  // Clock: 10 ns period
  // ------------------------------------------------------------
  always #5 clk = ~clk;

  // ------------------------------------------------------------
  // DUT
  // ------------------------------------------------------------
  algorithm #(
    .N(N),
    .F(F),
    .PIPE(PIPE)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .a(a),
    .b(b),
    .op(op),
    .y(y),
    .ovf(ovf),
    .valid_out(valid_out)
  );

  // ------------------------------------------------------------
  // Task: send one operation (1-cycle valid)
  // ------------------------------------------------------------
  task send_op(
    input logic [3:0] op_i,
    input logic signed [N-1:0] a_i,
    input logic signed [N-1:0] b_i,
    input string name
  );
  begin
    @(posedge clk);
    en <= 1'b1;
    op <= op_i;
    a  <= a_i;
    b  <= b_i;

    @(posedge clk);
    en <= 1'b0;

    // wait for result
    @(posedge valid_out);
    $display("[%0t] %-6s | y = %h | ovf = %b",
             $time, name, y, ovf);
  end
  endtask

  // ------------------------------------------------------------
  // Test sequence
  // ------------------------------------------------------------
  initial begin
    // init
    en = 0;
    a  = 0;
    b  = 0;
    op = 0;

    // reset
    rst_n = 0;
    repeat (3) @(posedge clk);
    rst_n = 1;

    // ==========================================================
    // Arithmetic (Q1.31)
    // ==========================================================
    send_op(4'd0, 32'sh4000_0000, 32'sh2000_0000, "ADD"); // 0.5 + 0.25 = 0.75
    send_op(4'd1, 32'sh4000_0000, 32'sh2000_0000, "SUB"); // 0.5 - 0.25 = 0.25
    send_op(4'd2, 32'sh4000_0000, 32'sh4000_0000, "MUL"); // 0.5 * 0.5 = 0.25
    send_op(4'd3, 32'sh4000_0000, 32'sh2000_0000, "DIV"); // 0.5 / 0.25 = 2.0

    // ==========================================================
    // Shift
    // ==========================================================
    send_op(4'd4, 32'sh0000_0001, 32'd3, "SHL"); // 1 << 3 = 8
    send_op(4'd5, 32'sh0000_0010, 32'd2, "SHR"); // 16 >> 2 = 4

    // ==========================================================
    // Logic
    // ==========================================================
    send_op(4'd6, 32'h0F0F_0F0F, 32'h00FF_00FF, "AND");
    send_op(4'd7, 32'h0F0F_0F0F, 32'h00FF_00FF, "OR ");
    send_op(4'd8, 32'h0F0F_0F0F, 32'h00FF_00FF, "XOR");
    send_op(4'd9, 32'h0F0F_0F0F, 32'h00FF_00FF, "NOR");

    // ==========================================================
    // Compare (result in bit[0])
    // ==========================================================
    send_op(4'd10, 32'd10, 32'd10, "EQ "); // = 1
    send_op(4'd11, 32'd5 , 32'd10, "LT "); // = 1
    send_op(4'd12, 32'd5 , 32'd10, "LE "); // = 1

    #20;
    $display("=== ALL TESTS DONE ===");
    $finish;
  end

endmodule

