`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2021 09:49:14 AM
// Design Name: 
// Module Name: calculate_norm_2
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


module calculate_norm_2(
    input clk,

    input en,

    input[31:0] a_0,
    /* input[31:0] a_1,
    input[31:0] a_2,
    input[31:0] a_3,
    input[31:0] a_4,
    input[31:0] a_5,
    input[31:0] a_6,
    input[31:0] a_7,
    input[31:0] a_8,
    input[31:0] a_9,
    input[31:0] a_10,
    input[31:0] a_11,
    input[31:0] a_12,
    input[31:0] a_13,
    input[31:0] a_14,
    input[31:0] a_15, */

    input[31:0] b_0,
   /*  input[31:0] b_1,
    input[31:0] b_2,
    input[31:0] b_3,
    input[31:0] b_4,
    input[31:0] b_5,
    input[31:0] b_6,
    input[31:0] b_7,
    input[31:0] b_8,
    input[31:0] b_9,
    input[31:0] b_10,
    input[31:0] b_11,
    input[31:0] b_12,
    input[31:0] b_13,
    input[31:0] b_14,
    input[31:0] b_15, */

    output[31:0] result_0,
    // output[1:0] result_1,
    // output[1:0] result_2,
    //output[31:0] result_3,
    output finished
    );
    
    wire a_0_valid;
    wire b_0_valid;
    wire[31:0] sub_result_0;
    wire sub_result_0_valid;
    floating_point_sub floating_point_sub_0(
        .aclk(clk),                                        // input wire aclk
        .s_axis_a_tvalid(en),                  // input wire s_axis_a_tvalid
        .s_axis_a_tready(),                  // output wire s_axis_a_tready
        .s_axis_a_tdata(a_0),                    // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tvalid(en),                  // input wire s_axis_b_tvalid
        .s_axis_b_tready(),                  // output wire s_axis_b_tready
        .s_axis_b_tdata(b_0),                    // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tvalid(sub_result_0_valid),        // output wire m_axis_result_tvalid
        .m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
        .m_axis_result_tdata(sub_result_0)           // output wire [31 : 0] m_axis_result_tdata
    );
    wire a_1_valid;
    wire b_1_valid;
    wire[31:0] sub_result_1;
    wire sub_result_1_valid;
    floating_point_sub floating_point_sub_1(
        .aclk(clk),                                        // input wire aclk
        .s_axis_a_tvalid(en),                  // input wire s_axis_a_tvalid
        .s_axis_a_tready(),                  // output wire s_axis_a_tready
        .s_axis_a_tdata(a_0),                    // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tvalid(en),                  // input wire s_axis_b_tvalid
        .s_axis_b_tready(),                  // output wire s_axis_b_tready
        .s_axis_b_tdata(b_0),                    // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tvalid(sub_result_1_valid),        // output wire m_axis_result_tvalid
        .m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
        .m_axis_result_tdata(sub_result_1)           // output wire [31 : 0] m_axis_result_tdata
    );
    /* wire a_2_valid;
    wire b_2_valid;
    wire[1:0] sub_result_2;
    wire sub_result_2_valid;
    floating_point_sub floating_point_sub_2(
        .aclk(clk),                                        // input wire aclk
        .s_axis_a_tvalid(en),                  // input wire s_axis_a_tvalid
        .s_axis_a_tready(),                  // output wire s_axis_a_tready
        .s_axis_a_tdata(a_0),                    // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tvalid(en),                  // input wire s_axis_b_tvalid
        .s_axis_b_tready(),                  // output wire s_axis_b_tready
        .s_axis_b_tdata(b_0),                    // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tvalid(sub_result_2_valid),        // output wire m_axis_result_tvalid
        .m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
        .m_axis_result_tdata(sub_result_2)           // output wire [31 : 0] m_axis_result_tdata
    );
    wire a_3_valid;
    wire b_3_valid;
    wire[1:0] sub_result_3;
    wire sub_result_3_valid;
    floating_point_sub floating_point_sub_3(
        .aclk(clk),                                        // input wire aclk
        .s_axis_a_tvalid(en),                  // input wire s_axis_a_tvalid
        .s_axis_a_tready(),                  // output wire s_axis_a_tready
        .s_axis_a_tdata(a_0),                    // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tvalid(en),                  // input wire s_axis_b_tvalid
        .s_axis_b_tready(),                  // output wire s_axis_b_tready
        .s_axis_b_tdata(b_0),                    // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tvalid(sub_result_3_valid),        // output wire m_axis_result_tvalid
        .m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
        .m_axis_result_tdata(sub_result_3)           // output wire [31 : 0] m_axis_result_tdata
    ); */

    wire[31:0] mul_result_0;
    wire mul_result_0_valid;
    floating_point_mul floating_point_mul_0(
        .aclk(clk),                                        // input wire aclk
        .s_axis_a_tvalid(sub_result_0_valid),                  // input wire s_axis_a_tvalid
        .s_axis_a_tready(),                  // output wire s_axis_a_tready
        .s_axis_a_tdata(sub_result_0),                    // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tvalid(sub_result_0_valid),                  // input wire s_axis_b_tvalid
        .s_axis_b_tready(),                  // output wire s_axis_b_tready
        .s_axis_b_tdata(sub_result_0),                    // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tvalid(mul_result_0_valid),        // output wire m_axis_result_tvalid
        .m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
        .m_axis_result_tdata(mul_result_0)           // output wire [31 : 0] m_axis_result_tdata
    );
    wire[31:0] mul_result_1;
    wire mul_result_1_valid;
    floating_point_mul floating_point_mul_1(
        .aclk(clk),                                        // input wire aclk
        .s_axis_a_tvalid(sub_result_1_valid),                  // input wire s_axis_a_tvalid
        .s_axis_a_tready(),                  // output wire s_axis_a_tready
        .s_axis_a_tdata(sub_result_1),                    // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tvalid(sub_result_1_valid),                  // input wire s_axis_b_tvalid
        .s_axis_b_tready(),                  // output wire s_axis_b_tready
        .s_axis_b_tdata(sub_result_1),                    // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tvalid(mul_result_1_valid),        // output wire m_axis_result_tvalid
        .m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
        .m_axis_result_tdata(mul_result_1)           // output wire [31 : 0] m_axis_result_tdata
    );
    // wire[31:0] mul_result_2;
    // wire mul_result_2_valid;
    // floating_point_mul floating_point_mul_2(
    //     .aclk(clk),                                        // input wire aclk
    //     .s_axis_a_tvalid(sub_result_2_valid),                  // input wire s_axis_a_tvalid
    //     .s_axis_a_tready(),                  // output wire s_axis_a_tready
    //     .s_axis_a_tdata(sub_result_2),                    // input wire [31 : 0] s_axis_a_tdata
    //     .s_axis_b_tvalid(sub_result_2_valid),                  // input wire s_axis_b_tvalid
    //     .s_axis_b_tready(),                  // output wire s_axis_b_tready
    //     .s_axis_b_tdata(sub_result_2),                    // input wire [31 : 0] s_axis_b_tdata
    //     .m_axis_result_tvalid(mul_result_2_valid),        // output wire m_axis_result_tvalid
    //     .m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
    //     .m_axis_result_tdata(mul_result_2)           // output wire [31 : 0] m_axis_result_tdata
    // );
    // wire[31:0] mul_result_3;
    // wire mul_result_3_valid;
    // floating_point_mul floating_point_mul_3(
    //     .aclk(clk),                                        // input wire aclk
    //     .s_axis_a_tvalid(sub_result_3_valid),                  // input wire s_axis_a_tvalid
    //     .s_axis_a_tready(),                  // output wire s_axis_a_tready
    //     .s_axis_a_tdata(sub_result_3),                    // input wire [31 : 0] s_axis_a_tdata
    //     .s_axis_b_tvalid(sub_result_3_valid),                  // input wire s_axis_b_tvalid
    //     .s_axis_b_tready(),                  // output wire s_axis_b_tready
    //     .s_axis_b_tdata(sub_result_3),                    // input wire [31 : 0] s_axis_b_tdata
    //     .m_axis_result_tvalid(mul_result_3_valid),        // output wire m_axis_result_tvalid
    //     .m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
    //     .m_axis_result_tdata(mul_result_3)           // output wire [31 : 0] m_axis_result_tdata
    // );
   

   /*  assign result_0 = mul_result_0;
    assign result_1 = mul_result_1;
    assign result_2 = mul_result_2;
    assign result_3 = mul_result_3; */
    assign result_0 = sub_result_0;
    assign finished = sub_result_0_valid;
endmodule
