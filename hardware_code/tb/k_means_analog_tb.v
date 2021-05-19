`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2021 10:03:59 PM
// Design Name: 
// Module Name: k_means_analog_tb
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


module k_means_analog_tb();

    localparam period = 10;

    wire [31:0] traing_num_test;
    wire [9:0] dimension_test;
    wire [9:0] k_num_test;
    wire [31:0] iteration_times_test;
    wire [27:0] belong_start_addr_test;
    wire [27:0] data_start_addr_test;
    wire [27:0] center_start_addr_test;
    wire [27:0] data_step_test;
    wire [27:0] cur_belong_addr_test;
    wire [27:0] cur_center_mix_mux_addr_test;
    wire [27:0] cur_data_addr_test;
    wire [27:0] cur_center_addr_test;
    wire [27:0] cur_center_sum_addr_test;
    wire [31:0] cur_times_test;
    wire [31:0] max_drift_test;
    wire [511:0] opreand_data_0_test;
    wire [511:0] opreand_data_1_test;
    wire [511:0] opreand_data_2_test;
    wire [31:0] opreand_data_1_choose_32b_test;
    wire [31:0] opreand_data_2_choose_32b_test;
    wire [31:0] cnt_iteration_test;
    wire [31:0] cnt_training_test;
    wire [9:0] cnt_k_test;
    wire [9:0] cnt_dimension_test;
    wire [1:0] cnt_is_new_belong_test;
    wire [31:0] min_0_test;
    wire [9:0] min_pos_test;
    wire [9:0] drift_addr_test;
    wire [31:0] drift_test;
    wire  drift_valid_test;
    wire  drift_cmd_test;
    wire  drift_cmd_en_test;
    wire [9:0] center_num_addr_test;
    wire [9:0] center_num_test;
    wire [9:0] center_num_reg_test;
    wire  center_num_rd_data_valid_test;
    wire [31:0] center_num_rd_data_test;
    wire [9:0] center_num_wr_data_test;
    wire [31:0] center_num_float_test;
    wire  center_num_cmd_test;
    wire  center_num_cmd_en_test;
    wire  center_sum_cmd_test;
    wire  center_sum_cmd_en_test;
    wire [9:0] center_sum_addr_test;
    wire [511:0] center_sum_rd_data_test;
    wire [511:0] center_sum_reg_test;
    wire [31:0] center_sum_reg_choose_32b_test;
    wire  center_sum_rd_data_valid_test;
    wire [511:0] center_sum_wr_data_test;
    wire [31:0] add_sub_data_a_0_test;
    wire [31:0] add_sub_data_b_0_test;
    wire  op_test;
    wire  add_sub_data_valid_test;
    wire  add_sub_result_valid_test;
    wire [31:0] add_sub_result_0_test;
    wire [31:0] add_sub_result_0_reg_test;
    wire  compare_valid_test;
    wire [31:0] compare_data_a_0_test;
    wire [31:0] compare_data_b_0_test;
    wire  compare_result_test;
    wire  compare_result_valid_test;
    wire  mul_valid_test;
    wire [31:0] mul_data_a_0_test;
    wire [31:0] mul_data_b_0_test;
    wire [31:0] mul_result_0_test;
    wire  mul_result_valid_test;
    wire  acc_valid_test;
    wire [31:0] acc_data_test;
    wire  acc_last_test;
    wire  acc_result_valid_test;
    wire [31:0] acc_result_data_test;
    wire  sqrt_data_valid_test;
    wire [31:0] sqrt_data_test;
    wire  sqrt_result_valid_test;
    wire [31:0] sqrt_result_data_test;
    wire [31:0] sqrt_result_reg_test;
    wire  uint_to_float_data_valid_test;
    wire [31:0] uint_to_float_data_0_test;
    wire  uint_to_float_result_valid_test;
    wire [31:0] uint_to_float_result_data_0_test;
    wire  divide_valid_test;
    wire [31:0] divide_data_a_0_test;
    wire [31:0] divide_data_b_0_test;
    wire [31:0] divide_result_0_test;
    wire  divide_result_valid_test;
    wire [43:0] state_test;
    wire [27:0] app_addr_choose_test;
    wire [2:0] app_cmd_choose_test;
    wire  app_en_choose_test;
    wire [511:0] app_wdf_data_choose_test;
    wire  app_wdf_wren_choose_test;
    wire [511:0] app_rd_data_test;
    wire  app_rd_data_valid_test;
    wire  app_wdf_rdy_test;
    wire  app_rdy_test;
    wire [27:0] app_addr_k_means_test;
    wire [2:0] app_cmd_k_means_test;
    wire  app_en_k_means_test;
    wire [511:0] app_wdf_data_k_means_test;
    wire  app_wdf_wren_k_means_test;
    wire  init_test;
    reg  clk;
    reg  rst_n;
    reg [27:0] addr;
    reg [27:0] app_addr_pcie;
    reg [2:0] app_cmd_pcie;
    reg  app_en_pcie;
    reg [511:0] app_wdf_data_pcie;
    reg  app_wdf_wren_pcie;

    k_means_analog k_means_analog_1(
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
        . app_addr_choose_test (app_addr_choose_test),
        . app_cmd_choose_test (app_cmd_choose_test),
        . app_en_choose_test (app_en_choose_test),
        . app_wdf_data_choose_test (app_wdf_data_choose_test),
        . app_wdf_wren_choose_test (app_wdf_wren_choose_test),
        . app_rd_data_test (app_rd_data_test),
        . app_rd_data_valid_test (app_rd_data_valid_test),
        . app_wdf_rdy_test (app_wdf_rdy_test),
        . app_rdy_test (app_rdy_test),
        . app_addr_k_means_test (app_addr_k_means_test),
        . app_cmd_k_means_test (app_cmd_k_means_test),
        . app_en_k_means_test (app_en_k_means_test),
        . app_wdf_data_k_means_test (app_wdf_data_k_means_test),
        . app_wdf_wren_k_means_test (app_wdf_wren_k_means_test),
        . init_test (init_test),
        . clk (clk),
        . rst_n (rst_n),
        . addr (addr),
        . app_addr_pcie (app_addr_pcie),
        . app_cmd_pcie (app_cmd_pcie),
        . app_en_pcie (app_en_pcie),
        . app_wdf_data_pcie (app_wdf_data_pcie),
        . app_wdf_wren_pcie (app_wdf_wren_pcie)
    );

    reg[31:0] float_num_1 = 32'h3f800000;
    reg[31:0] float_num_2 = 32'h40000000;
    reg[31:0] float_num_3 = 32'h40400000;
    reg[31:0] float_num_4 = 32'h40800000;
    reg[31:0] float_num_5 = 32'h40a00000;
    reg[31:0] float_num_6 = 32'h40c00000;
    reg[31:0] float_num_7 = 32'h40e00000;
    reg[31:0] float_num_8 = 32'h41000000;
    reg[31:0] float_num_9 = 32'h41100000;
    reg[31:0] float_num_10 = 32'h41200000;
    reg[31:0] float_num_11 = 32'h41300000;
    reg[31:0] float_num_12 = 32'h41400000;
    reg[31:0] float_num_13 = 32'h41500000;
    reg[31:0] float_num_14 = 32'h41600000;
    reg[31:0] float_num_15 = 32'h41700000;
    reg[31:0] float_num_16 = 32'h41800000;
    reg[31:0] float_num_max = 32'h7f7fffff;
    reg[31:0] float_num_sum = 32'h42340000;


    //mix所占空间 97/4 = 24.25 ≈ 25 * 8 = 200
    //data所占空间（97*2)/16=12.125≈13 * 8 = 104
    //center所占空间 11*2 / 16 = 1.375 ≈2 * 8 = 16
    //center_sum所占空间 =  
    //数据step就等于维度/16 根据余数判断是否加一，data_step暂时保留
    //
    //严格验证
    // reg[31:0] traing_num = 32'd97;
    // reg[31:0] dimension = 32'd4;
    // reg[31:0] k_num = 32'd11;
    // reg[31:0] iteration_times = 32'd5;
    // reg[31:0] mix_start_addr = 32'd8;//512_bit  每512位,但是对app_addr是64
    // reg[31:0] data_start_addr = 32'd208;
    // reg[31:0] center_start_addr = 32'd312;//数据维度是5 
    // reg[31:0] data_step = 32'b11_000;//这个大数据会有用

    //center_sum所占空间 =   2 * 4 /16 *8 =8；
    reg[31:0] traing_num = 32'd5;
    reg[31:0] dimension = 32'd2;
    reg[31:0] k_num = 32'd2;
    reg[31:0] iteration_times = 32'd2;
    reg[31:0] center_sum_init_value_addr = 32'd8 ;//这个地址其实不用存，因为常量地址是固定的
    reg[31:0] belong_start_addr = 32'd16;//512_bit  每512位,但是对app_addr是64
    reg[31:0] data_start_addr = 32'd56; //+ 5*（4/16*8）
    reg[31:0] center_start_addr = 32'd96;//+5*（4/16*8）
    reg[31:0] data_step = 32'd8;//这个大数据会有用
    //距离测试14，16，8，10，2，4，4，2，10，8
    reg belong_0 = 32'h0;
    reg belong_1 = 32'h1;
    initial begin
        clk = 1'b0;

        rst_n = 1'b1;
        #(period)
        rst_n = 1'b0;
        #(period)
        rst_n = 1'b1;

        #(period * 10)//iniitial
            addr = 28'd0;
            app_addr_pcie = 28'd0;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
            
            app_wdf_data_pcie = {256'h0,
                                        data_step,center_start_addr,
                                        data_start_addr,belong_start_addr,
                                        iteration_times,k_num,
                                        dimension,traing_num};
            app_wdf_wren_pcie = 1'b1;
        #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;
            
        #(period * 1) //belong
            addr = belong_start_addr;
            app_addr_pcie = belong_start_addr;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
            app_wdf_wren_pcie = 1'b1;

           app_wdf_data_pcie = 512'b0;
         #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;


        #(period * 1) //belong
            addr = belong_start_addr + 1*data_step;
            app_addr_pcie = belong_start_addr + 1*data_step;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
            app_wdf_wren_pcie = 1'b1;

            app_wdf_data_pcie = 512'b0; 
         #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;

        #(period * 1) //belong
            addr = belong_start_addr + 2*data_step;
            app_addr_pcie = belong_start_addr + 2*data_step;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
            app_wdf_wren_pcie = 1'b1;

            app_wdf_data_pcie = {512'b0};
         #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;

        #(period * 1) //belong
            addr = belong_start_addr + 3*data_step;
            app_addr_pcie = belong_start_addr + 3*data_step;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
            app_wdf_wren_pcie = 1'b1;

            app_wdf_data_pcie = 512'b0;
         #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;

        #(period * 1) //belong
            addr = belong_start_addr + 4*data_step;
            app_addr_pcie = belong_start_addr + 4*data_step;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
            app_wdf_wren_pcie = 1'b1;

            app_wdf_data_pcie = 512'b0;
         #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;

        #(period * 1) //data
            addr = data_start_addr;
            app_addr_pcie = data_start_addr;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
            app_wdf_wren_pcie = 1'b1;

            app_wdf_data_pcie = {128'h0,belong_1,belong_1,
                                        belong_1, belong_1,
                                        float_num_15,float_num_15,
                                        float_num_15,float_num_15,
                                        float_num_15,float_num_15,
                                        float_num_14,float_num_15};
        #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;
        #(period * 1) //data
            addr = data_start_addr + data_step;
            app_addr_pcie = data_start_addr +data_step;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
            app_wdf_wren_pcie = 1'b1;

            app_wdf_data_pcie = {128'h0,belong_1,belong_1,
                                        belong_1, belong_1,
                                        float_num_12,float_num_12,
                                        float_num_12,float_num_12,
                                        float_num_12,float_num_12,
                                        float_num_11,float_num_12};
        #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;
        #(period * 1) //data
            addr = data_start_addr + data_step*2;
            app_addr_pcie = data_start_addr + data_step*2;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
             app_wdf_wren_pcie = 1'b1;

            app_wdf_data_pcie = {128'h0,belong_1,belong_1,
                                        belong_1, belong_1,
                                        float_num_9,float_num_9,
                                        float_num_9,float_num_9,
                                        float_num_9,float_num_9,
                                        float_num_8,float_num_9};
        #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;
        #(period * 1) //data
            addr = data_start_addr + data_step*3;
            app_addr_pcie = data_start_addr + data_step*3;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
             app_wdf_wren_pcie = 1'b1;

            app_wdf_data_pcie = {128'h0,belong_1,belong_1,
                                        belong_1, belong_1,
                                        float_num_6,float_num_6,
                                        float_num_6,float_num_6,
                                        float_num_6,float_num_6,
                                        float_num_3,float_num_6};
        #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;
        #(period * 1) //data
            addr = data_start_addr + data_step*4;
            app_addr_pcie = data_start_addr + data_step*4;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;
             app_wdf_wren_pcie = 1'b1;

            app_wdf_data_pcie = {128'h0,belong_1,belong_1,
                                        belong_1, belong_1,
                                        float_num_3,float_num_3,
                                        float_num_3,float_num_3,
                                        float_num_3,float_num_3,
                                        float_num_2,float_num_3};
        #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;

        #(period * 1) //center
            addr = center_start_addr;
            app_addr_pcie = center_start_addr;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;

            app_wdf_data_pcie = {128'h0,belong_1,belong_1,
                                        belong_1, belong_1,
                                        float_num_3,float_num_3,
                                        float_num_3,float_num_3,
                                        float_num_7,float_num_7,
                                        float_num_7,float_num_7};
            app_wdf_wren_pcie = 1'b1;
        #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;
        #(period * 1) //center
            addr = center_start_addr + data_step;
            app_addr_pcie = center_start_addr + data_step;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;

            app_wdf_data_pcie = {128'h0,belong_1,belong_1,
                                        belong_1, belong_1,
                                        float_num_3,float_num_3,
                                        float_num_3,float_num_3,
                                        float_num_8,float_num_8,
                                        float_num_8,float_num_8};
            app_wdf_wren_pcie = 1'b1;
        #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;

         #(period * 1) //center_sum
            addr = 28'd8;
            app_addr_pcie = 28'd8;

            app_cmd_pcie = 3'd1;
            app_en_pcie = 1'b1;

            app_wdf_data_pcie = {128'h0,belong_1,belong_1,
                                        belong_1, belong_1,
                                        float_num_3,float_num_3,
                                        float_num_3,float_num_3,
                                        float_num_sum,float_num_sum,
                                        float_num_sum,float_num_sum};
            app_wdf_wren_pcie = 1'b1;
         #(period)
            app_en_pcie = 1'b0;
            app_wdf_wren_pcie = 1'b0;


        #(period * 5)//开启
            addr = 28'b0;
            app_addr_pcie = 28'b0;

            app_cmd_pcie = 3'd0;
            app_en_pcie = 1'b1;
            app_wdf_wren_pcie = 1'b0;
        #(period)
            app_en_pcie = 1'b0;


         #(period * 5000) //center
            addr = center_start_addr;
            app_addr_pcie = center_start_addr;

            app_cmd_pcie = 3'd0;
            app_en_pcie = 1'b1;

            app_wdf_wren_pcie = 1'b0;
            app_wdf_data_pcie = 512'b0;
        
            #(period)
                app_en_pcie = 1'b0;
                app_wdf_wren_pcie = 1'b0;

        #(period * 1) //center
            addr = center_start_addr + data_step;
            app_addr_pcie = center_start_addr + data_step;

            app_cmd_pcie = 3'd0;
            app_en_pcie = 1'b1;

            app_wdf_data_pcie = 512'b0;
            app_wdf_wren_pcie = 1'b0;
            #(period)
                app_en_pcie = 1'b0;
                app_wdf_wren_pcie = 1'b0;
        
    end

    always #(period / 2) clk = ~clk;

endmodule
