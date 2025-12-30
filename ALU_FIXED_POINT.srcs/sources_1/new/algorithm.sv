`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 05:21:35 AM
// Design Name: 
// Module Name: algorithm
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



//module algorithm #(
//    parameter int N    = 32,
//    parameter int F    = 31,
//    parameter bit SAT  = 1,
//    parameter int PIPE = 2
//)(
//    input  logic                 clk,
//    input  logic                 rst_n,
//    input  logic                 en,        // treat as "valid_in" for a new transaction

//    input  logic signed [N-1:0]  a,
//    input  logic signed [N-1:0]  b,
//    input  logic        [3:0]    op,        // 0:add 1:sub 2:mul 3:div

//    output logic signed [N-1:0]  y,
//    output logic                 ovf,
//    output logic                 valid_out
//);

//    // ============================================================
//    // Datapath blocks (unchanged)
//    // ============================================================

//    logic signed [N-1:0] y_add, y_sub, y_mul, y_div;
//    logic ovf_add, ovf_sub, ovf_div;

//    add32 #(.N(N), .SAT(SAT)) u_add (
//        .a(a), .b(b), .y(y_add), .ovf(ovf_add)
//    );

//    sub32 #(.N(N), .SAT(SAT)) u_sub (
//        .a(a), .b(b), .y(y_sub), .ovf(ovf_sub)
//    );

//    mul_unit #(.N(N), .F(F), .PIPE(PIPE)) u_mul (
//        .clk(clk), .rst_n(rst_n), .en(en),
//        .a(a), .b(b), .y(y_mul)
//    );

//    div_unit #(.N(N), .F(F)) u_div (
//        .clk(clk), .rst_n(rst_n), .en(en),
//        .a(a), .b(b), .y(y_div), .ovf(ovf_div)
//    );

//    // ============================================================
//    // Control pipeline: op + valid (delayed to stage PIPE)
//    // ============================================================

//    logic [3:0] op_q   [0:PIPE];
//    logic       vld_q  [0:PIPE];

//    // ============================================================
//    // Data pipelines for operations that are NOT already PIPE-latent
//    // - ADD/SUB: captured at stage 0 then shifted to stage PIPE
//    // - DIV: capture at stage 1 (because div_unit output is 1-cycle later)
//    //        then shift to stage PIPE
//    // ============================================================

//    logic signed [N-1:0] add_q [0:PIPE];
//    logic signed [N-1:0] sub_q [0:PIPE];
//    logic signed [N-1:0] div_q [0:PIPE];

//    logic ovf_add_q [0:PIPE];
//    logic ovf_sub_q [0:PIPE];
//    logic ovf_div_q [0:PIPE];

//    integer i;

//    // ============================================================
//    // Pipeline registers
//    // ============================================================
//    always_ff @(posedge clk or negedge rst_n) begin
//        if (!rst_n) begin
//            for (i = 0; i <= PIPE; i++) begin
//                op_q[i]      <= '0;
//                vld_q[i]     <= 1'b0;

//                add_q[i]     <= '0;
//                sub_q[i]     <= '0;
//                div_q[i]     <= '0;

//                ovf_add_q[i] <= 1'b0;
//                ovf_sub_q[i] <= 1'b0;
//                ovf_div_q[i] <= 1'b0;
//            end
//        end else begin
//            // shift control + data every clock; insert bubble if en=0
//            op_q[0]  <= op;
//            vld_q[0] <= en;

//            // stage 0 capture for add/sub (combinational)
//            add_q[0]     <= y_add;
//            sub_q[0]     <= y_sub;
//            ovf_add_q[0] <= ovf_add;
//            ovf_sub_q[0] <= ovf_sub;

//            // shift forward
//            for (i = 1; i <= PIPE; i++) begin
//                op_q[i]  <= op_q[i-1];
//                vld_q[i] <= vld_q[i-1];

//                add_q[i]     <= add_q[i-1];
//                sub_q[i]     <= sub_q[i-1];
//                ovf_add_q[i] <= ovf_add_q[i-1];
//                ovf_sub_q[i] <= ovf_sub_q[i-1];

//                // default shift div pipe
//                div_q[i]     <= div_q[i-1];
//                ovf_div_q[i] <= ovf_div_q[i-1];
//            end

//            // IMPORTANT: DIV result becomes valid after 1 cycle from input.
//            // So at stage 1 we overwrite div_q[1] with current y_div (which corresponds to op_q[1]).
//            if (PIPE >= 1) begin
//                div_q[1]     <= y_div;
//                ovf_div_q[1] <= ovf_div;
//            end
//        end
//    end

//    // ============================================================
//    // Output MUX at the aligned stage (PIPE)
//    // ============================================================

//    logic signed [N-1:0] y_next;
//    logic                ovf_next;
//    logic                valid_next;

//    always_comb begin
//        y_next     = '0;
//        ovf_next   = 1'b0;
//        valid_next = vld_q[PIPE]; // output valid exactly when transaction reaches stage PIPE

//        unique case (op_q[PIPE])
//            4'd0: begin // ADD
//                y_next   = add_q[PIPE];
//                ovf_next = ovf_add_q[PIPE];
//            end
//            4'd1: begin // SUB
//                y_next   = sub_q[PIPE];
//                ovf_next = ovf_sub_q[PIPE];
//            end
//            4'd2: begin // MUL (already PIPE-latent)
//                y_next   = y_mul;
//                ovf_next = 1'b0; // keep your original policy
//            end
//            4'd3: begin // DIV (captured at stage1 then delayed to PIPE)
//                y_next   = div_q[PIPE];
//                ovf_next = ovf_div_q[PIPE];
//            end
//            default: begin
//                y_next   = '0;
//                ovf_next = 1'b0;
//            end
//        endcase

//        // If bubble => force outputs invalid (data don't-care)
//        if (!valid_next) begin
//            y_next   = y;      // or '0; choose hold to make waveform nicer
//            ovf_next = ovf;
//        end
//    end

//    // ============================================================
//    // Registered outputs (glitch-free valid_out)
//    // ============================================================

//    always_ff @(posedge clk or negedge rst_n) begin
//        if (!rst_n) begin
//            y         <= '0;
//            ovf       <= 1'b0;
//            valid_out <= 1'b0;
//        end else begin
//            valid_out <= valid_next;

//            if (valid_next) begin
//                y   <= y_next;
//                ovf <= ovf_next;
//            end
//        end
//    end

//endmodule



module algorithm #(
    parameter int N    = 32,
    parameter int F    = 31,
    parameter bit SAT  = 1,
    parameter int PIPE = 2
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 en,        // valid_in

    input  logic signed [N-1:0]  a,
    input  logic signed [N-1:0]  b,
    input  logic        [3:0]    op,        // 0..12

    output logic signed [N-1:0]  y,
    output logic                 ovf,
    output logic                 valid_out
);

    // ============================================================
    // Combinational functional units
    // ============================================================

    logic signed [N-1:0] y_add, y_sub, y_shf, y_log;
    logic eq, lt, le;
    logic ovf_add, ovf_sub;

    add32 #(.N(N), .SAT(SAT)) u_add (.a(a), .b(b), .y(y_add), .ovf(ovf_add));
    sub32 #(.N(N), .SAT(SAT)) u_sub (.a(a), .b(b), .y(y_sub), .ovf(ovf_sub));

    shift_unit #(.N(N)) u_shift (
        .a(a),
        .shamt(b[$clog2(N)-1:0]),
        .do_left(op == 4'd4), // 4:SHL, 5:SHR
        .y(y_shf)
    );

    logic_unit   #(.N(N)) u_logic (.a(a), .b(b), .op(op), .y(y_log));
    compare_unit #(.N(N)) u_cmp   (.a(a), .b(b), .eq(eq), .lt(lt), .le(le));

    // ============================================================
    // MUL / DIV (latency blocks)
    // ============================================================

    logic signed [N-1:0] y_mul, y_div;
    logic ovf_div;

    mul_unit #(.N(N), .F(F), .PIPE(PIPE)) u_mul (
        .clk(clk), .rst_n(rst_n), .en(en),
        .a(a), .b(b), .y(y_mul)
    );

    div_unit #(.N(N), .F(F)) u_div (
        .clk(clk), .rst_n(rst_n), .en(en),
        .a(a), .b(b), .y(y_div), .ovf(ovf_div)
    );

    // ============================================================
    // Control + data pipelines
    // ============================================================

    logic [3:0] op_q  [0:PIPE];
    logic       vld_q [0:PIPE];

    logic signed [N-1:0] add_q [0:PIPE];
    logic signed [N-1:0] sub_q [0:PIPE];
    logic signed [N-1:0] shf_q [0:PIPE];
    logic signed [N-1:0] log_q [0:PIPE];
    logic signed [N-1:0] div_q [0:PIPE];

    logic eq_q [0:PIPE];
    logic lt_q [0:PIPE];
    logic le_q [0:PIPE];

    logic ovf_add_q [0:PIPE];
    logic ovf_sub_q [0:PIPE];
    logic ovf_div_q [0:PIPE];

    integer i;

    // ============================================================
    // Pipeline registers
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= PIPE; i++) begin
                op_q[i] <= '0; vld_q[i] <= 1'b0;
                add_q[i] <= '0; sub_q[i] <= '0; shf_q[i] <= '0;
                log_q[i] <= '0; div_q[i] <= '0;
                eq_q[i]  <= 1'b0; lt_q[i] <= 1'b0; le_q[i] <= 1'b0;
                ovf_add_q[i] <= 1'b0; ovf_sub_q[i] <= 1'b0; ovf_div_q[i] <= 1'b0;
            end
        end else begin
            // stage 0 capture
            op_q[0]  <= op;
            vld_q[0] <= en;

            add_q[0] <= y_add;
            sub_q[0] <= y_sub;
            shf_q[0] <= y_shf;
            log_q[0] <= y_log;

            eq_q[0]  <= eq;
            lt_q[0]  <= lt;
            le_q[0]  <= le;

            ovf_add_q[0] <= ovf_add;
            ovf_sub_q[0] <= ovf_sub;

            // shift pipeline
            for (i = 1; i <= PIPE; i++) begin
                op_q[i]  <= op_q[i-1];
                vld_q[i] <= vld_q[i-1];

                add_q[i] <= add_q[i-1];
                sub_q[i] <= sub_q[i-1];
                shf_q[i] <= shf_q[i-1];
                log_q[i] <= log_q[i-1];

                eq_q[i]  <= eq_q[i-1];
                lt_q[i]  <= lt_q[i-1];
                le_q[i]  <= le_q[i-1];

                ovf_add_q[i] <= ovf_add_q[i-1];
                ovf_sub_q[i] <= ovf_sub_q[i-1];

                div_q[i]     <= div_q[i-1];
                ovf_div_q[i] <= ovf_div_q[i-1];
            end

            // DIV becomes valid after 1 cycle
            if (PIPE >= 1) begin
                div_q[1]     <= y_div;
                ovf_div_q[1] <= ovf_div;
            end
        end
    end

    // ============================================================
    // Final output select (aligned with PIPE)
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y <= '0;
            ovf <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= vld_q[PIPE];

            if (vld_q[PIPE]) begin
                unique case (op_q[PIPE])
                    4'd0:  begin y <= add_q[PIPE]; ovf <= ovf_add_q[PIPE]; end
                    4'd1:  begin y <= sub_q[PIPE]; ovf <= ovf_sub_q[PIPE]; end
                    4'd2:  begin y <= y_mul;       ovf <= 1'b0;            end
                    4'd3:  begin y <= div_q[PIPE]; ovf <= ovf_div_q[PIPE]; end
                    4'd4,4'd5: y <= shf_q[PIPE];
                    4'd6,4'd7,4'd8,4'd9: y <= log_q[PIPE];
                    4'd10: y <= {{(N-1){1'b0}}, eq_q[PIPE]};
                    4'd11: y <= {{(N-1){1'b0}}, lt_q[PIPE]};
                    4'd12: y <= {{(N-1){1'b0}}, le_q[PIPE]};
                    default: y <= '0;
                endcase
            end
        end
    end

endmodule

