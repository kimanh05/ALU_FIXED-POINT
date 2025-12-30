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



`timescale 1ns / 1ps

module tb_alu_fixed_point;

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
  logic ovf, z, n;
  logic valid_out;

  // ------------------------------------------------------------
  // Clock (10ns period)
  // ------------------------------------------------------------
  always #5 clk = ~clk;

  // ------------------------------------------------------------
  // DUT (override params for safety)
  // ------------------------------------------------------------
  alu_fixed_point #(
    .N(N),
    .F(F),
    .PIPE(PIPE)
  ) dut (
    .clk       (clk),
    .rst_n     (rst_n),
    .en        (en),
    .a         (a),
    .b         (b),
    .op        (op),
    .y         (y),
    .ovf       (ovf),
    .z         (z),
    .n         (n),
    .valid_out (valid_out)
  );

  // ------------------------------------------------------------
  // Helper: wait for valid_out safely (clocked)
  // ------------------------------------------------------------
  task automatic wait_valid();
    begin
      // wait until valid_out becomes 1 on a clock edge
      do @(posedge clk); while (valid_out !== 1'b1);
    end
  endtask

  // ------------------------------------------------------------
  // Task: send one operation (1-cycle en pulse)
  // ------------------------------------------------------------
  task automatic send_op(
    input logic [3:0] op_i,
    input logic signed [N-1:0] a_i,
    input logic signed [N-1:0] b_i,
    input string name
  );
  begin
    // drive input + pulse en for exactly 1 cycle
    @(posedge clk);
    en <= 1'b1;
    op <= op_i;
    a  <= a_i;
    b  <= b_i;

    @(posedge clk);
    en <= 1'b0;

    // optional: clean bus (waveform nicer)
    op <= '0;
    a  <= '0;
    b  <= '0;

    // wait output valid
    wait_valid();

    $display("[%0t] %-7s op=%0d | a=%h b=%h | y=%h ovf=%b z=%b n=%b",
             $time, name, op_i, a_i, b_i, y, ovf, z, n);
  end
  endtask

  // ------------------------------------------------------------
  // Monitor: print whenever valid_out asserted (useful for burst)
  // ------------------------------------------------------------
  always_ff @(posedge clk) begin
    if (rst_n && valid_out) begin
      $display("[%0t] >>> VALID_OUT | y=%h ovf=%b z=%b n=%b", $time, y, ovf, z, n);
    end
  end

  // ------------------------------------------------------------
  // Test sequence
  // ------------------------------------------------------------
  initial begin
    // init
    en = 0; a = 0; b = 0; op = 0;

    // reset
    rst_n = 0;
    repeat (4) @(posedge clk);
    rst_n = 1;

    // ==========================================================
    // ADD / SUB
    // ==========================================================
    send_op(4'd0, 32'sh4000_0000, 32'sh2000_0000, "ADD");      // 0.75 (Q1.31)
    send_op(4'd1, 32'sh4000_0000, 32'sh2000_0000, "SUB");      // 0.25
    send_op(4'd0, -32'sh4000_0000, 32'sh2000_0000, "ADD_NEG"); // -0.25
    send_op(4'd1, -32'sh4000_0000, -32'sh2000_0000, "SUB_NEG");// -0.25

    // overflow (depends on SAT policy)
    send_op(4'd0, 32'sh7FFF_FFFF, 32'sh7FFF_FFFF, "ADD_OVF");

    // ==========================================================
    // MUL
    // ==========================================================
    send_op(4'd2, 32'sh4000_0000, 32'sh4000_0000, "MUL");      // 0.25
    send_op(4'd2, -32'sh4000_0000, 32'sh4000_0000, "MUL_NEG"); // -0.25
    send_op(4'd2, -32'sh4000_0000, -32'sh4000_0000, "MUL_POS");// 0.25

    // ==========================================================
    // DIV
    // ==========================================================
    send_op(4'd3, 32'sh4000_0000, 32'sh2000_0000, "DIV");      // 2.0
    send_op(4'd3, -32'sh4000_0000, 32'sh2000_0000, "DIV_NEG"); // -2.0
    send_op(4'd3, 32'sh4000_0000, 32'sh0000_0000, "DIV0");     // ovf=1 expected

    // ==========================================================
    // SHIFT
    // ==========================================================
    send_op(4'd4, 32'd1,  32'd0, "SHL0"); // 1<<0 = 1
    send_op(4'd4, 32'd1,  32'd3, "SHL3"); // 1<<3 = 8
    send_op(4'd5, 32'd16, 32'd2, "SHR2"); // 16>>2 = 4
    send_op(4'd5, -32'd8, 32'd1, "ASHR"); // arithmetic shift right expected

    // ==========================================================
    // LOGIC
    // ==========================================================
    send_op(4'd6, 32'hFFFF_0000, 32'h0F0F_0F0F, "AND");
    send_op(4'd7, 32'hFFFF_0000, 32'h0F0F_0F0F, "OR");
    send_op(4'd8, 32'hAAAA_AAAA, 32'h5555_5555, "XOR");
    send_op(4'd9, 32'h0000_0000, 32'h0000_0000, "NOR"); // expect all 1s

    // ==========================================================
    // COMPARE
    // ==========================================================
    send_op(4'd10, 32'd10, 32'd10, "EQ"); // y=1
    send_op(4'd11, 32'd5 , 32'd10, "LT"); // y=1
    send_op(4'd12, 32'd5 , 32'd10, "LE"); // y=1
    send_op(4'd11, -32'd5, 32'd3 , "LT2");// y=1

    // ==========================================================
    // FLAGS
    // ==========================================================
    send_op(4'd1, 32'd5,  32'd5, "ZERO"); // y=0 => z=1
    send_op(4'd1, -32'd5, 32'd3, "NEG");  // y<0 => n=1

    // ==========================================================
    // PIPELINE stress (back-to-back 3 ops)
    // -> outputs will be printed by the VALID monitor above
    // ==========================================================
    @(posedge clk);
    en <= 1;
    op <= 4'd0; a <= 32'd1;        b <= 32'd2;         // ADD

    @(posedge clk);
    op <= 4'd2; a <= 32'sh4000_0000; b <= 32'sh4000_0000; // MUL

    @(posedge clk);
    op <= 4'd4; a <= 32'd1;        b <= 32'd4;         // SHL

    @(posedge clk);
    en <= 0;
    op <= '0; a <= '0; b <= '0;

    // wait enough cycles to flush pipe
    repeat (PIPE + 6) @(posedge clk);

    $display("=== FULL ALU TEST DONE ===");
    $finish;
  end

endmodule


