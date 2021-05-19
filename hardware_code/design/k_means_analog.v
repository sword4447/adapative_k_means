`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/01/2021 09:28:50 PM
// Design Name:
// Module Name: k_means_analog
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


module k_means_analog(
           output [31:0]traing_num_test,
           output [9:0]dimension_test,
           output [9:0]k_num_test,
           output [31:0]iteration_times_test,
           output [27:0]belong_start_addr_test,
           output [27:0]data_start_addr_test,
           output [27:0]center_start_addr_test,
           output [27:0]data_step_test,
           output [27:0]cur_belong_addr_test,
           output [27:0]cur_center_mix_mux_addr_test,
           output [27:0]cur_data_addr_test,
           output [27:0]cur_center_addr_test,
           output [27:0]cur_center_sum_addr_test,
           output [31:0]cur_times_test,
           output [31:0]max_drift_test,
           output [511:0]opreand_data_0_test,
           output [511:0]opreand_data_1_test,
           output [511:0]opreand_data_2_test,
           output [31:0]opreand_data_1_choose_32b_test,
           output [31:0]opreand_data_2_choose_32b_test,
           output [31:0]cnt_iteration_test,
           output [31:0]cnt_training_test,
           output [9:0]cnt_k_test,
           output [9:0]cnt_dimension_test,
           output [1:0]cnt_is_new_belong_test,
           output [31:0]min_0_test,
           output [9:0]min_pos_test,
           output [9:0]drift_addr_test,
           output [31:0]drift_test,
           output drift_valid_test,
           output drift_cmd_test,
           output drift_cmd_en_test,
           output [9:0]center_num_addr_test,
           output [9:0]center_num_test,
           output [9:0]center_num_reg_test,
           output center_num_rd_data_valid_test,
           output [31:0]center_num_rd_data_test,
           output [9:0]center_num_wr_data_test,
           output [31:0]center_num_float_test,
           output center_num_cmd_test,
           output center_num_cmd_en_test,
           output center_sum_cmd_test,
           output center_sum_cmd_en_test,
           output [9:0]center_sum_addr_test,
           output [511:0]center_sum_rd_data_test,
           output [511:0]center_sum_reg_test,
           output [31:0]center_sum_reg_choose_32b_test,
           output center_sum_rd_data_valid_test,
           output [511:0]center_sum_wr_data_test,
           output [31:0]add_sub_data_a_0_test,
           output [31:0]add_sub_data_b_0_test,
           output op_test,
           output add_sub_data_valid_test,
           output add_sub_result_valid_test,
           output [31:0]add_sub_result_0_test,
           output [31:0]add_sub_result_0_reg_test,
           output compare_valid_test,
           output [31:0]compare_data_a_0_test,
           output [31:0]compare_data_b_0_test,
           output compare_result_test,
           output compare_result_valid_test,
           output mul_valid_test,
           output [31:0]mul_data_a_0_test,
           output [31:0]mul_data_b_0_test,
           output [31:0]mul_result_0_test,
           output mul_result_valid_test,
           output acc_valid_test,
           output [31:0]acc_data_test,
           output acc_last_test,
           output acc_result_valid_test,
           output [31:0]acc_result_data_test,
           output sqrt_data_valid_test,
           output [31:0]sqrt_data_test,
           output sqrt_result_valid_test,
           output [31:0]sqrt_result_data_test,
           output [31:0]sqrt_result_reg_test,
           output uint_to_float_data_valid_test,
           output [31:0]uint_to_float_data_0_test,
           output uint_to_float_result_valid_test,
           output [31:0]uint_to_float_result_data_0_test,
           output divide_valid_test,
           output [31:0]divide_data_a_0_test,
           output [31:0]divide_data_b_0_test,
           output [31:0]divide_result_0_test,
           output divide_result_valid_test,
           output [43:0]state_test,

           output [27:0] app_addr_choose_test,
           output [2:0] app_cmd_choose_test,
           output  app_en_choose_test,
           output [511:0] app_wdf_data_choose_test,
           output  app_wdf_wren_choose_test,
           output [511:0] app_rd_data_test,
           output  app_rd_data_valid_test,
           output  app_wdf_rdy_test,
           output  app_rdy_test,
           output [27:0] app_addr_k_means_test,
           output [2:0] app_cmd_k_means_test,
           output  app_en_k_means_test,
           output [511:0] app_wdf_data_k_means_test,
           output  app_wdf_wren_k_means_test,
           output init_test,

           input clk,
           input rst_n,
           input [27:0]addr,
           input[27:0] app_addr_pcie,
           input[2:0] app_cmd_pcie,
           input app_en_pcie,
           input[511:0] app_wdf_data_pcie,
           input app_wdf_wren_pcie);

    wire [27:0] app_addr_choose;
    wire [2:0] app_cmd_choose;
    wire  app_en_choose;
    wire [511:0] app_wdf_data_choose;
    wire  app_wdf_wren_choose;
    wire [63:0] app_wdf_mask_choose;

    wire [511:0] app_rd_data;
    wire  app_rd_data_valid;
    wire  app_wdf_rdy;
    wire  app_rdy;

    wire [27:0] app_addr_k_means;
    wire [2:0] app_cmd_k_means;
    wire  app_en_k_means;
    wire [511:0] app_wdf_data_k_means;
    wire  app_wdf_wren_k_means;

    wire init;

    blcok_mem_ddr blcok_mem_ddr_1(
                    . clk(clk),

                    . app_addr(app_addr_choose),
                    . app_cmd(app_cmd_choose),
                    . app_en(app_en_choose),
                    . app_wdf_data(app_wdf_data_choose),
                    . app_wdf_mask(app_wdf_mask_choose),
                    . app_wdf_wren(app_wdf_wren_choose),
                    . app_wdf_end(app_wdf_wren_choose),

                    . app_wdf_rdy(app_wdf_rdy),
                    . app_rdy(app_rdy),
                    . app_rd_data(app_rd_data),
                    . app_rd_data_end(),
                    . app_rd_data_valid(app_rd_data_valid)
                );

    recursive_analog recursive_1(
                        . traing_num_test (traing_num_test),
                        . dimension_test (dimension_test),
                        . k_num_test (k_num_test),
                        . iteration_times_test (iteration_times_test),
                        . belong_start_addr_test (belong_start_addr_test),
                        . data_start_addr_test (data_start_addr_test),
                        . center_start_addr_test (center_start_addr_test),
                        . data_step_test (data_step_test),
                        . cur_belong_addr_test (cur_belong_addr_test),
                        . cur_center_mix_mux_addr_test (cur_center_mix_mux_addr_test),
                        . cur_data_addr_test (cur_data_addr_test),
                        . cur_center_addr_test (cur_center_addr_test),
                        . cur_center_sum_addr_test (cur_center_sum_addr_test),
                        . cur_times_test (cur_times_test),
                        . max_drift_test (max_drift_test),
                        . opreand_data_0_test (opreand_data_0_test),
                        . opreand_data_1_test (opreand_data_1_test),
                        . opreand_data_2_test (opreand_data_2_test),
                        . opreand_data_1_choose_32b_test (opreand_data_1_choose_32b_test),
                        . opreand_data_2_choose_32b_test (opreand_data_2_choose_32b_test),
                        . cnt_iteration_test (cnt_iteration_test),
                        . cnt_training_test (cnt_training_test),
                        . cnt_k_test (cnt_k_test),
                        . cnt_dimension_test (cnt_dimension_test),
                        . cnt_is_new_belong_test (cnt_is_new_belong_test),
                        . min_0_test (min_0_test),
                        . min_pos_test (min_pos_test),
                        . drift_addr_test (drift_addr_test),
                        . drift_test (drift_test),
                        . drift_valid_test (drift_valid_test),
                        . drift_cmd_test (drift_cmd_test),
                        . drift_cmd_en_test (drift_cmd_en_test),
                        . center_num_addr_test (center_num_addr_test),
                        . center_num_test (center_num_test),
                        . center_num_reg_test (center_num_reg_test),
                        . center_num_rd_data_valid_test (center_num_rd_data_valid_test),
                        . center_num_rd_data_test (center_num_rd_data_test),
                        . center_num_wr_data_test (center_num_wr_data_test),
                        . center_num_float_test (center_num_float_test),
                        . center_num_cmd_test (center_num_cmd_test),
                        . center_num_cmd_en_test (center_num_cmd_en_test),
                        . center_sum_cmd_test (center_sum_cmd_test),
                        . center_sum_cmd_en_test (center_sum_cmd_en_test),
                        . center_sum_addr_test (center_sum_addr_test),
                        . center_sum_rd_data_test (center_sum_rd_data_test),
                        . center_sum_reg_test (center_sum_reg_test),
                        . center_sum_reg_choose_32b_test (center_sum_reg_choose_32b_test),
                        . center_sum_rd_data_valid_test (center_sum_rd_data_valid_test),
                        . center_sum_wr_data_test (center_sum_wr_data_test),
                        . add_sub_data_a_0_test (add_sub_data_a_0_test),
                        . add_sub_data_b_0_test (add_sub_data_b_0_test),
                        . op_test (op_test),
                        . add_sub_data_valid_test (add_sub_data_valid_test),
                        . add_sub_result_valid_test (add_sub_result_valid_test),
                        . add_sub_result_0_test (add_sub_result_0_test),
                        . add_sub_result_0_reg_test (add_sub_result_0_reg_test),
                        . compare_valid_test (compare_valid_test),
                        . compare_data_a_0_test (compare_data_a_0_test),
                        . compare_data_b_0_test (compare_data_b_0_test),
                        . compare_result_test (compare_result_test),
                        . compare_result_valid_test (compare_result_valid_test),
                        . mul_valid_test (mul_valid_test),
                        . mul_data_a_0_test (mul_data_a_0_test),
                        . mul_data_b_0_test (mul_data_b_0_test),
                        . mul_result_0_test (mul_result_0_test),
                        . mul_result_valid_test (mul_result_valid_test),
                        . acc_valid_test (acc_valid_test),
                        . acc_data_test (acc_data_test),
                        . acc_last_test (acc_last_test),
                        . acc_result_valid_test (acc_result_valid_test),
                        . acc_result_data_test (acc_result_data_test),
                        . sqrt_data_valid_test (sqrt_data_valid_test),
                        . sqrt_data_test (sqrt_data_test),
                        . sqrt_result_valid_test (sqrt_result_valid_test),
                        . sqrt_result_data_test (sqrt_result_data_test),
                        . sqrt_result_reg_test (sqrt_result_reg_test),
                        . uint_to_float_data_valid_test (uint_to_float_data_valid_test),
                        . uint_to_float_data_0_test (uint_to_float_data_0_test),
                        . uint_to_float_result_valid_test (uint_to_float_result_valid_test),
                        . uint_to_float_result_data_0_test (uint_to_float_result_data_0_test),
                        . divide_valid_test (divide_valid_test),
                        . divide_data_a_0_test (divide_data_a_0_test),
                        . divide_data_b_0_test (divide_data_b_0_test),
                        . divide_result_0_test (divide_result_0_test),
                        . divide_result_valid_test (divide_result_valid_test),
                        . state_test (state_test),

                        . clk (clk),
                        . rst_n (rst_n),
                        . app_wdf_rdy (app_wdf_rdy),
                        . app_rdy (app_rdy),
                        . app_addr (app_addr_k_means),
                        . app_cmd (app_cmd_k_means),
                        . app_en (app_en_k_means),
                        . app_wdf_data (app_wdf_data_k_means),
                        . app_wdf_mask (),
                        . app_wdf_wren (app_wdf_wren_k_means),
                        . app_rd_data (app_rd_data),
                        . app_rd_data_end (),
                        . app_rd_data_valid (app_rd_data_valid),
                        . addr (addr),
                        . init (init)
                    );

    mux_2i1o_28b mux_2i1o_28b_0
                (
                    .sel_i (init),
                    .in_0_i (app_addr_pcie),
                    .in_1_i (app_addr_k_means),

                    .out (app_addr_choose)
                );
    mux_2i1o_1b mux_2i1o_1b_0
                (
                    .sel_i (init),
                    .in_0_i (app_en_pcie),
                    .in_1_i (app_en_k_means),

                    .out (app_en_choose)
                );
    mux_2i1o_3b mux_2i1o_3b_0
                (
                    .sel_i (init),
                    .in_0_i (app_cmd_pcie),
                    .in_1_i (app_cmd_k_means),

                    .out (app_cmd_choose)
                );
    mux_2i1o_512b mux_2i1o_512b_0
                (
                    .sel_i (init),
                    .in_0_i (app_wdf_data_pcie),
                    .in_1_i (app_wdf_data_k_means),

                    .out (app_wdf_data_choose)
                );
    mux_2i1o_1b mux_2i1o_1b_2
                (
                    .sel_i (init),
                    .in_0_i (app_wdf_wren_pcie),
                    .in_1_i (app_wdf_wren_k_means),

                    .out (app_wdf_wren_choose)
                );

    assign app_addr_choose_test = app_addr_choose;
    assign app_cmd_choose_test = app_cmd_choose;
    assign app_en_choose_test = app_en_choose;
    assign app_wdf_data_choose_test = app_wdf_data_choose;
    assign app_wdf_wren_choose_test = app_wdf_wren_choose;
    assign app_rd_data_test = app_rd_data;
    assign app_rd_data_valid_test = app_rd_data_valid;
    assign app_wdf_rdy_test = app_wdf_rdy;
    assign app_rdy_test = app_rdy;
    assign app_addr_k_means_test = app_addr_k_means;
    assign app_cmd_k_means_test = app_cmd_k_means;
    assign app_en_k_means_test = app_en_k_means;
    assign app_wdf_data_k_means_test = app_wdf_data_k_means;
    assign app_wdf_wren_k_means_test = app_wdf_wren_k_means;
    assign init_test = init;
endmodule