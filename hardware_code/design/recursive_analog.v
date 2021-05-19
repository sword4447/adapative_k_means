`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2021 04:19:36 PM
// Design Name: 
// Module Name: recursive_analog
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


module recursive_analog(
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

           input clk,
           input rst_n,
           input app_wdf_rdy,
           input app_rdy,
           input[27:0] addr,
           input [511:0] app_rd_data,
           input app_rd_data_end,
           input app_rd_data_valid,

           output reg [27:0] app_addr,
           output reg [2:0] app_cmd,
           output reg app_en,
           output reg [511:0] app_wdf_data,
           output [63:0] app_wdf_mask,
           output reg app_wdf_wren,

           output reg init);

	reg[31:0]  traing_num;
	reg[9:0]  dimension;
	reg[9:0]  k_num;
	reg[31:0]  iteration_times;
	reg[27:0] belong_start_addr;
	reg[27:0] data_start_addr;
	reg[27:0] center_start_addr;
	reg[27:0] data_step;

	reg[27:0] cur_belong_addr;
	reg[27:0] cur_center_mix_mux_addr;
	reg[27:0] cur_data_addr;
	reg[27:0] cur_center_addr;
	reg[27:0] cur_center_sum_addr;
	reg[31:0] cur_times;
	reg[31:0] max_drift;

	reg[511:0] opreand_data_0;
	reg[511:0] opreand_data_1;
	reg[511:0] opreand_data_2;
	wire [31:0] opreand_data_1_choose_32b;
	wire [31:0] opreand_data_2_choose_32b;
	reg[31:0] cnt_iteration;
	reg[31:0] cnt_training;
	reg[9:0] cnt_k;
	reg[9:0] cnt_dimension;
	reg[1:0] cnt_is_new_belong;
	localparam float_num_max = 32'h7f7fffff;
	reg[31:0] min_0;
	reg[9:0] min_pos;
	reg[27:0] belong_addr_reserve;

	reg [9:0] drift_addr;
	wire[31:0] drift;
	wire drift_valid;
	reg drift_cmd;
	reg drift_cmd_en;

	reg [9:0] center_num_addr;
	wire[9:0] center_num;
	reg [9:0] center_num_reg;
	wire center_num_rd_data_valid;
	wire[31:0] center_num_rd_data;
	reg [9:0] center_num_wr_data;
	reg [31:0] center_num_float;
	reg center_num_cmd;
	reg center_num_cmd_en;

	reg center_sum_cmd;
	reg center_sum_cmd_en;
	reg [9:0] center_sum_addr;
	wire[511:0] center_sum_rd_data;
	reg [511:0] center_sum_reg;
	wire [31:0] center_sum_reg_choose_32b;
	wire center_sum_rd_data_valid;
	reg[511:0] center_sum_wr_data;

	wire add_sub_a_0_tready;
	wire add_sub_b_0_tready;
	reg [31:0] add_sub_data_a_0;
	reg [31:0] add_sub_data_b_0;
	reg op;//0add,1sub
	reg add_sub_data_valid;
	wire add_sub_result_valid;
	wire [31:0] add_sub_result_0;
	reg [31:0] add_sub_result_0_reg;

	wire compare_data_a_0_tready;
	wire compare_data_b_0_tready;
	reg compare_valid;
	reg[31:0] compare_data_a_0;
	reg[31:0] compare_data_b_0;
	wire compare_result;
	wire compare_result_valid;

	wire mul_data_a_0_tready;
	wire mul_data_b_0_tready;
	reg mul_valid;
	reg[31:0] mul_data_a_0;
	reg[31:0] mul_data_b_0;
	wire[31:0] mul_result_0;
	wire mul_result_valid;

	wire acc_tready;
	reg  acc_valid;
	reg [31:0] acc_data;
	reg  acc_last;
	wire  acc_result_valid;
	wire [31:0] acc_result_data;

	wire sqrt_tready;
	reg  sqrt_data_valid;
	reg [31:0] sqrt_data;
	wire  sqrt_result_valid;
	wire [31:0] sqrt_result_data;
	reg [31:0] sqrt_result_reg;// 距离需要缓冲

	wire uint_to_float_data_0_tready;
	reg  uint_to_float_data_valid;
	reg [31:0] uint_to_float_data_0;
	wire  uint_to_float_result_valid;
	wire [31:0] uint_to_float_result_data_0;

	wire divide_data_a_0_tready;
	wire divide_data_b_0_tready;
	reg divide_valid;
	reg[31:0] divide_data_a_0;
	reg[31:0] divide_data_b_0;
	wire[31:0] divide_result_0;
	reg[31:0] divide_result_0_reg;
	wire divide_result_valid;
	wire [15:0] cnt_dimension_16b;
	reg [15:0] cnt_dimension_16b_reg;

	decode_4i16o_1b decode_4i16o_1b_0(
						.a_i(cnt_dimension[3:0]),
						.a_o(cnt_dimension_16b)
					);

	localparam RST = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001; //0
	localparam RST_BLOCK_SUM_AND_NUM = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0010; //1
	localparam LOAD_CENTER_SUM_INIT_VALUE = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0100; //2
	localparam WAIT_LOAD_CENTER_SUM_INIT_VALUE = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1000; //3
	localparam STORE_CENTER_SUM_INIT_VALUE = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_0000; //4
	localparam STORE_INITI_CENTER_NUM = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0010_0000; //5
	localparam STATR_RECURSIVE = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0100_0000; //6
	localparam IS_LOAD_DATA_END = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1000_0000; //7
	localparam LOAD_BLEONG = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_0000_0000; //8
	localparam WAIT_LOAD_BLEONG = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0010_0000_0000; //9
	localparam LOAD_DATA = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0100_0000_0000; //10
	localparam WAIT_LOAD_DATA = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_1000_0000_0000; //11
	localparam IS_LOAD_COMPARE_CENTER_END = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0001_0000_0000_0000; //12
	localparam LOAD_COMPARE_CENTER = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0010_0000_0000_0000; //13
	localparam WAIT_LOAD_COMPARE_CENTER = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_0100_0000_0000_0000; //14
	localparam START_CALCULATE = 49'b0_0000_0000_0000_0000_0000_0000_0000_0000_1000_0000_0000_0000; //15
	localparam WAIT_CALCULATE_SUB = 49'b0_0000_0000_0000_0000_0000_0000_0000_0001_0000_0000_0000_0000; //16
	localparam WAIT_CALCULATE_MUL = 49'b0_0000_0000_0000_0000_0000_0000_0000_0010_0000_0000_0000_0000; //17
	localparam WAIT_CALCULATE_ACC = 49'b0_0000_0000_0000_0000_0000_0000_0000_0100_0000_0000_0000_0000; //18
	localparam WAIT_SQRT_RESULT = 49'b0_0000_0000_0000_0000_0000_0000_0000_1000_0000_0000_0000_0000; //19
	localparam WAIT_COMPARE_DATA_MIN = 49'b0_0000_0000_0000_0000_0000_0000_0001_0000_0000_0000_0000_0000; //20
	localparam IS_MOVE = 49'b0_0000_0000_0000_0000_0000_0000_0010_0000_0000_0000_0000_0000; //21
	localparam IS_UPDATE_BELONG_CENTER_END = 49'b0_0000_0000_0000_0000_0000_0000_0100_0000_0000_0000_0000_0000; //22
	localparam LOAD_BELONG_CENTER_SUM = 49'b0_0000_0000_0000_0000_0000_0000_1000_0000_0000_0000_0000_0000; //23
	localparam WAIT_LOAD_BELONG_CENTER_SUM = 49'b0_0000_0000_0000_0000_0000_0001_0000_0000_0000_0000_0000_0000; //24
	localparam IS_CENTER_DIMENSION_SUM_END = 49'b0_0000_0000_0000_0000_0000_0010_0000_0000_0000_0000_0000_0000; //25
	localparam UPDATE_BELONG_CENTER_SUM = 49'b0_0000_0000_0000_0000_0000_0100_0000_0000_0000_0000_0000_0000; //26
	localparam WAIT_UPDATE_BELONG_CENTER_SUM = 49'b0_0000_0000_0000_0000_0000_1000_0000_0000_0000_0000_0000_0000; //27
	localparam WAIT_UPDATE_BELONG_CENTER_SUM_1 = 49'b0_0000_0000_0000_0000_0001_0000_0000_0000_0000_0000_0000_0000; //28
	localparam STORE_BELONG_CENTER_SUM = 49'b0_0000_0000_0000_0000_0010_0000_0000_0000_0000_0000_0000_0000; //29
	localparam LOAD_BELONG_CENTER_NUM = 49'b0_0000_0000_0000_0000_0100_0000_0000_0000_0000_0000_0000_0000; //30
	localparam WAIT_LOAD_BELONG_CENTER_NUM = 49'b0_0000_0000_0000_0000_1000_0000_0000_0000_0000_0000_0000_0000; //31
	localparam UPDATE_BELONG_CENTER_NUM = 49'b0_0000_0000_0000_0001_0000_0000_0000_0000_0000_0000_0000_0000; //32
	localparam STORE_BELONG_CENTER_NUM = 49'b0_0000_0000_0000_0010_0000_0000_0000_0000_0000_0000_0000_0000; //33
	localparam STORE_BELONG_BELONG = 49'b0_0000_0000_0000_0100_0000_0000_0000_0000_0000_0000_0000_0000; //34
	localparam IS_UPDATE_ALL_CENTER_END = 49'b0_0000_0000_0000_1000_0000_0000_0000_0000_0000_0000_0000_0000; //35
	localparam LOAD_UPDATE_CENTER_NUM = 49'b0_0000_0000_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000; //36
	localparam WAIT_LOAD_UPDATE_CENTER_NUM = 49'b0_0000_0000_0010_0000_0000_0000_0000_0000_0000_0000_0000_0000; //37
	localparam IS_CENTER_NUM_ZERO = 49'b0_0000_0000_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000; //38
	localparam COVERT_NUM_TO_FLOAT = 49'b0_0000_0000_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000; //39
	localparam WAIT_COVERT_NUM_TO_FLOAT = 49'b0_0000_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; //40
	localparam LOAD_UPDATE_CENTER_SUM = 49'b0_0000_0010_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; //41
	localparam WAIT_LOAD_UPDATE_CENTER_SUM = 49'b0_0000_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; //42
	localparam IS_UPDATE_CENTER_DIMENSION_SUM_END = 49'b0_0000_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; //43
	localparam UPDATE_CENTER = 49'b0_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; //44
	localparam WAIT_UPDATE_CENTER = 49'b0_0010_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; //45
	localparam WAIT_UPDATE_CENTER_1 = 49'b0_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; //46
	localparam STORE_UPDATE_CENTER = 49'b0_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; //47
	localparam TEST_END = 49'b1_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; //48
	reg[48:0] state;
	reg[511:0] opreand_data_2_0;
	always @(posedge clk)
	begin
		if (!rst_n)
		begin
			state <= RST;
		end
		else
		begin
			case(state)
				RST:
				begin
					if (addr == 28'b0)
					begin
						if (app_rd_data_valid) //每次读出地址0表示迭代开始
						begin
							traing_num      <= app_rd_data[31:0];
							dimension       <= app_rd_data[63:32];
							k_num           <= app_rd_data[95:64];
							iteration_times <= app_rd_data[127:96];

							belong_start_addr    <= app_rd_data[159:128];
							data_start_addr   <= app_rd_data[191:160];
							center_start_addr <= app_rd_data[223:192];
							data_step <= app_rd_data[255:224];//待优化

							init  <= 1'b1;

							cnt_k <= 10'b0;
							state <= RST_BLOCK_SUM_AND_NUM;
						end
						else
							init <= 1'b0;
					end
					else
						init <= 1'b0;
				end
				RST_BLOCK_SUM_AND_NUM:
				begin
					if(cnt_k == 10'b11_1111_1111)
						state <= LOAD_CENTER_SUM_INIT_VALUE;
					else
						cnt_k <= cnt_k + 1;
				end

				LOAD_CENTER_SUM_INIT_VALUE:
				begin
					//1'b0 <= 1'b0;

					if(app_en)
					begin
						state <= WAIT_LOAD_CENTER_SUM_INIT_VALUE;
					end
				end
				WAIT_LOAD_CENTER_SUM_INIT_VALUE:
				begin
					if(app_rd_data_valid)
					begin
						opreand_data_0 <= app_rd_data;
						state <= STORE_CENTER_SUM_INIT_VALUE;
					end
				end
				STORE_CENTER_SUM_INIT_VALUE:
				begin
					state <= STORE_INITI_CENTER_NUM;
				end
				STORE_INITI_CENTER_NUM:
				begin
					cur_times       <= 0;

					state <= STATR_RECURSIVE;
				end

				STATR_RECURSIVE:
				begin

					if (cur_times < iteration_times)
					begin

						cnt_training <= 32'b0;
						cur_data_addr <= data_start_addr;
						cur_belong_addr <= belong_start_addr;

						state <= IS_LOAD_DATA_END;
					end
					else
					begin
						state <= RST;
					end
				end

				IS_LOAD_DATA_END:
				begin
					cur_center_addr <= center_start_addr;
					cur_center_sum_addr <= 10'b0;

					cnt_k <= 10'b0;
					min_0 <= float_num_max ;

					if(cnt_training == traing_num)
						state <= IS_UPDATE_ALL_CENTER_END;//不可能是0个中心,但是还有更新中心值，不要盲目压缩，它还有刷新寄存器的功能
					else
					begin
						state <= LOAD_BLEONG;
					end
				end
				LOAD_BLEONG:
				begin
					if(app_en)
						state <= WAIT_LOAD_BLEONG;
				end
				WAIT_LOAD_BLEONG:
				begin
					if (app_rd_data_valid)
					begin
						cnt_training <= cnt_training + 1;

						opreand_data_0 <= app_rd_data;//this part can parallel
						//cur_belong_addr <= cur_belong_addr + data_step;
						belong_addr_reserve <= cur_belong_addr;
						state <= LOAD_DATA;
					end
				end
				LOAD_DATA:
				begin
					if(app_en)
						state <= WAIT_LOAD_DATA;
				end
				WAIT_LOAD_DATA:
				begin
					if (app_rd_data_valid)
					begin
						opreand_data_1 <= app_rd_data;//this part can parallel
						cur_data_addr <= cur_data_addr + data_step;

						state <= LOAD_COMPARE_CENTER; //肯定有中心
					end
				end
				IS_LOAD_COMPARE_CENTER_END:
				begin
					if(cnt_k == k_num)
					begin
						cnt_is_new_belong <= 2'b0;

						state <= IS_MOVE; //加载完中心判断是否移动
					end
					else
						state <= LOAD_COMPARE_CENTER;
				end
				LOAD_COMPARE_CENTER://这一步可以优化，不过先暂时不理
				begin

					if(app_en)
					begin
						state <= WAIT_LOAD_COMPARE_CENTER;
					end
				end
				WAIT_LOAD_COMPARE_CENTER:
				begin
					if (app_rd_data_valid)
					begin
						opreand_data_2 <= app_rd_data;
						cur_center_addr <= cur_center_addr + data_step;

						cnt_dimension            <= 10'b0;

						state          <= START_CALCULATE;
					end
				end

				START_CALCULATE:
				begin

					cnt_dimension <= cnt_dimension + 1; //发起了命令就指向下一个维度

					state <= WAIT_CALCULATE_SUB;
				end
				WAIT_CALCULATE_SUB: //有优化空间，后期优化
				begin
					if (add_sub_result_valid)
						state <= WAIT_CALCULATE_MUL;
					//state <= WAIT_CALCULATE_MUL_READY;
				end
				WAIT_CALCULATE_MUL:
				begin
					if (mul_result_valid)
						state <= WAIT_CALCULATE_ACC;
				end

				WAIT_CALCULATE_ACC://acc这里要发起判断是否需要重新加载
				begin
					if (acc_result_valid)
					begin
						if(cnt_dimension < dimension )
						begin
							state <= START_CALCULATE;
						end
						else
							state <= WAIT_SQRT_RESULT;
					end
				end
				WAIT_SQRT_RESULT:
				begin
					sqrt_result_reg <= sqrt_result_data;

					if (sqrt_result_valid)
					begin
						state <=  WAIT_COMPARE_DATA_MIN;
					end
				end

				WAIT_COMPARE_DATA_MIN:
				begin
					if(compare_result_valid)
					begin
						if(compare_result)
						begin
							min_pos <= cnt_k; //标记

							min_0 <= sqrt_result_reg;
						end

						cnt_k <= cnt_k + 1;

						state <= IS_LOAD_COMPARE_CENTER_END;
						//state <=TEST_END;
					end
				end

				IS_MOVE:
				begin
					if(opreand_data_0[9:0] == min_pos)
					begin
						cur_belong_addr <= cur_belong_addr + data_step; //这个不在读取后立即就加的原因是后面更新会用
						state <= IS_LOAD_DATA_END;
					end
					else
					begin
						state <= IS_UPDATE_BELONG_CENTER_END;
					end
				end

				IS_UPDATE_BELONG_CENTER_END:
				begin
					cnt_dimension <= 10'b0;
					if(cnt_is_new_belong == 2'b0)//先更新老的
					begin
						cur_center_sum_addr <= opreand_data_0[9:0];
						state <= LOAD_BELONG_CENTER_SUM;

						//cnt_is_new_belong <= 2'b1;
					end
					else if(cnt_is_new_belong == 2'b1)
					begin
						cur_center_sum_addr <= min_pos;

						state <= LOAD_BELONG_CENTER_SUM;

					end
					else
						state <= STORE_BELONG_BELONG;//旧中心和新中心都比较完，当前数据比较结束,存储新的Belong

				end
				LOAD_BELONG_CENTER_SUM:
				begin
					state <= WAIT_LOAD_BELONG_CENTER_SUM;
				end
				WAIT_LOAD_BELONG_CENTER_SUM:
				begin
					if(center_sum_rd_data_valid)
					begin
						center_sum_reg <= center_sum_rd_data;
						state <= UPDATE_BELONG_CENTER_SUM;
					end
				end
				IS_CENTER_DIMENSION_SUM_END://要重新分配
				begin
					if(cnt_dimension < dimension)
						state          <= UPDATE_BELONG_CENTER_SUM;
					else
						state <= STORE_BELONG_CENTER_SUM;//更新完SUM,更新完NUM
				end
				UPDATE_BELONG_CENTER_SUM:
				begin
					state <= WAIT_UPDATE_BELONG_CENTER_SUM;
				end
				WAIT_UPDATE_BELONG_CENTER_SUM:
				begin
					cnt_dimension_16b_reg <= cnt_dimension_16b;
					add_sub_result_0_reg <= add_sub_result_0;

					if(add_sub_result_valid)
					begin
						cnt_dimension <= cnt_dimension + 1;

						state <= WAIT_UPDATE_BELONG_CENTER_SUM_1;//先看看是不是属于16维，属于的话一次存入
					end
				end
				WAIT_UPDATE_BELONG_CENTER_SUM_1:
				begin
					//state <= TEST_END;
					if(cnt_dimension_16b_reg[0])
						center_sum_reg[31:0] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[1])
						center_sum_reg[63:32] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[2])
						center_sum_reg[95:64] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[3])
						center_sum_reg[127:96] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[4])
						center_sum_reg[159:128] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[5])
						center_sum_reg[191:160] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[6])
						center_sum_reg[223:192] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[7])
						center_sum_reg[255:224] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[8])
						center_sum_reg[287:256] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[9])
						center_sum_reg[319:288] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[10])
						center_sum_reg[351:320] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[11])
						center_sum_reg[383:352] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[12])
						center_sum_reg[415:384] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[13])
						center_sum_reg[447:416] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[14])
						center_sum_reg[479:448] <= add_sub_result_0_reg;
					if(cnt_dimension_16b_reg[15])
						center_sum_reg[511:480] <= add_sub_result_0_reg;

					state <= IS_CENTER_DIMENSION_SUM_END;//先看看是不是属于16维，属于的话一次存入
				end

				STORE_BELONG_CENTER_SUM:
				begin
					state <= LOAD_BELONG_CENTER_NUM;//更新完SUM更新NUM
				end
				LOAD_BELONG_CENTER_NUM:
				begin
					state <= WAIT_LOAD_BELONG_CENTER_NUM;
				end
				WAIT_LOAD_BELONG_CENTER_NUM:
				begin
					if(center_num_rd_data_valid)
					begin
						center_num_reg <= center_num_rd_data;
						state <= UPDATE_BELONG_CENTER_NUM;
					end
				end
				UPDATE_BELONG_CENTER_NUM:
				begin
					if(cnt_is_new_belong == 2'b0)
						center_num_reg <= center_num_reg - 1 ;  //这一步想一想能不能在一个周期内完成
					else
						center_num_reg <= center_num_reg + 1;

					state <= STORE_BELONG_CENTER_NUM;
				end
				STORE_BELONG_CENTER_NUM:
				begin
					cnt_is_new_belong <= cnt_is_new_belong + 2'b1;
					//state <= TEST_END;
					state <= IS_UPDATE_BELONG_CENTER_END;
				end
				STORE_BELONG_BELONG:
				begin
					if(app_en)
					begin
						cur_belong_addr <= cur_belong_addr + data_step;
						state <= IS_LOAD_DATA_END;
					end
				end

				IS_UPDATE_ALL_CENTER_END:
				begin
					cnt_dimension <= 10'b0;

					if(cnt_k < k_num)
						state <= LOAD_UPDATE_CENTER_NUM;
					else
					begin
						cur_times <= cur_times + 1;

						state <= STATR_RECURSIVE;
					end
				end
				LOAD_UPDATE_CENTER_NUM:
				begin

					state <= WAIT_LOAD_UPDATE_CENTER_NUM;
				end
				WAIT_LOAD_UPDATE_CENTER_NUM:
				begin
					if(center_num_rd_data_valid)
					begin
						center_num_reg <= center_num_rd_data;

						state <= IS_CENTER_NUM_ZERO;
					end
				end
				IS_CENTER_NUM_ZERO:
				begin
					if(center_num_reg == 10'b0)
					begin
						opreand_data_2 <= 512'b0;
						state <= STORE_UPDATE_CENTER;
					end
					else
						state <= COVERT_NUM_TO_FLOAT;
				end
				COVERT_NUM_TO_FLOAT:
				begin
					state <= WAIT_COVERT_NUM_TO_FLOAT;
				end
				WAIT_COVERT_NUM_TO_FLOAT:
				begin
					center_num_float <= uint_to_float_result_data_0;

					if(uint_to_float_result_valid)
					begin
						state <= LOAD_UPDATE_CENTER_SUM;
					end
				end
				LOAD_UPDATE_CENTER_SUM:
				begin
					state <= WAIT_LOAD_UPDATE_CENTER_SUM;
				end
				WAIT_LOAD_UPDATE_CENTER_SUM:
				begin
					if(center_sum_rd_data_valid)
					begin
						center_sum_reg <= center_sum_rd_data;

						state <= IS_UPDATE_CENTER_DIMENSION_SUM_END;
					end
				end
				IS_UPDATE_CENTER_DIMENSION_SUM_END:
				begin
					if(cnt_dimension < dimension)
						state <= UPDATE_CENTER;
					else
						state <= STORE_UPDATE_CENTER;//取下一个中心点
				end
				UPDATE_CENTER:
				begin
					state <= WAIT_UPDATE_CENTER;
				end
				WAIT_UPDATE_CENTER:
				begin

					cnt_dimension_16b_reg <= cnt_dimension_16b;
					divide_result_0_reg <= divide_result_0;

					if(divide_result_valid)
					begin
						cnt_dimension <= cnt_dimension + 1;
						state <=  WAIT_UPDATE_CENTER_1;
					end
				end
				WAIT_UPDATE_CENTER_1:
				begin
					if(cnt_dimension_16b_reg[0])
						opreand_data_2[31:0] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[1])
						opreand_data_2[63:32] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[2])
						opreand_data_2[95:64] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[3])
						opreand_data_2[127:96] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[4])
						opreand_data_2[159:128] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[5])
						opreand_data_2[191:160] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[6])
						opreand_data_2[223:192] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[7])
						opreand_data_2[255:224] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[8])
						opreand_data_2[287:256] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[9])
						opreand_data_2[319:288] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[10])
						opreand_data_2[351:320] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[11])
						opreand_data_2[383:352] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[12])
						opreand_data_2[415:384] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[13])
						opreand_data_2[447:416] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[14])
						opreand_data_2[479:448] <= divide_result_0_reg;
					if(cnt_dimension_16b_reg[15])
						opreand_data_2[511:480] <= divide_result_0_reg;

					state <=  IS_UPDATE_CENTER_DIMENSION_SUM_END;
				end
				STORE_UPDATE_CENTER:
				begin
					if(cnt_k[0]==1'b0)
						opreand_data_2_0 <= opreand_data_2;

					cnt_k <= cnt_k + 1;
					cur_center_addr <= cur_center_addr + data_step;
					cur_center_sum_addr <= cur_center_sum_addr + 1;

					state <= IS_UPDATE_ALL_CENTER_END;
				end

				TEST_END:
				begin
					init <= 1'b0;
				end
			endcase
		end
	end


	//DDR_control
	always @(*)
	begin
		if(state == LOAD_CENTER_SUM_INIT_VALUE & app_rdy)
		begin
			app_addr = 28'd8;
			//app_cmd  = 3'b001;//读
			app_en   = 1'b1;

			app_wdf_data = 512'b0;
			app_wdf_wren = 1'b0;

			app_cmd  = 3'b000;//读analog
		end
		else if (state == LOAD_BLEONG & app_rdy)
		begin
			app_addr = cur_belong_addr;
			//app_cmd  = 3'b001;//读
			app_en   = 1'b1;

			app_wdf_data = 512'b0;
			app_wdf_wren = 1'b0;

			app_cmd  = 3'b000;//读analog
		end
		else if (state == LOAD_DATA & app_rdy)
		begin
			app_addr = cur_data_addr;
			//app_cmd  = 3'b001;//读
			app_en   = 1'b1;

			app_wdf_data = 512'b0;
			app_wdf_wren = 1'b0;

			//app_cmd  = 3'b000;//读analog
		end
		else if (state == LOAD_COMPARE_CENTER & app_rdy)
		begin
			app_addr = cur_center_addr;
			//app_cmd  = 3'b001;//读
			app_en   = 1'b1;

			app_wdf_data = 512'b0;
			app_wdf_wren = 1'b0;

			app_cmd  = 3'b000;//读analog
		end
		else if(state == STORE_UPDATE_CENTER & app_rdy & app_wdf_rdy)
		begin
			app_addr = cur_center_addr;
			//app_cmd  = 3'b000;//写
			app_en   = 1'b1;

			app_wdf_data = opreand_data_2;
			app_wdf_wren = 1'b1;

			app_cmd  = 3'b001;//写analog
		end
		else if(state == STORE_BELONG_BELONG & app_rdy & app_wdf_rdy)
		begin
			app_addr = cur_belong_addr;
			//app_cmd  = 3'b000;//写
			app_en   = 1'b1;

			app_wdf_data = {480'b0,min_pos};
			app_wdf_wren = 1'b1;

			app_cmd  = 3'b001;//写analog
		end
		else
		begin
			app_addr = 28'b0;
			app_cmd  = 3'b000;
			app_en   = 1'b0;

			app_wdf_data = 512'b0;
			app_wdf_wren = 1'b0;
		end
	end
	assign app_wdf_mask = 64'b0;

	/*center_num control*/
	always @(*)
	begin
		if(state == RST_BLOCK_SUM_AND_NUM)
		begin
			center_num_addr = cnt_k;

			center_num_cmd    = 1'b1;//写
			center_num_cmd_en = 1'b1;
			center_num_wr_data = 10'b0;
		end
		else if(state == STORE_INITI_CENTER_NUM)
		begin
			center_num_addr = 10'b0;

			center_num_cmd    = 1'b1;//写
			center_num_cmd_en = 1'b1;
			center_num_wr_data = traing_num;
		end
		else if (state == LOAD_BELONG_CENTER_NUM )
		begin
			if(cnt_is_new_belong == 2'b0)
				center_num_addr = opreand_data_0[9:0] ;
			else
				center_num_addr = min_pos;

			center_num_cmd    = 1'b0;//读
			center_num_cmd_en = 1'b1;
			center_num_wr_data = 10'b0;
		end
		else if(state == STORE_BELONG_CENTER_NUM)
		begin
			if(cnt_is_new_belong == 2'b0)
				center_num_addr = opreand_data_0[9:0] ;
			else
				center_num_addr = min_pos;

			center_num_cmd    = 1'b1;//写
			center_num_cmd_en = 1'b1;
			center_num_wr_data = center_num_reg;
		end
		else if(state == LOAD_UPDATE_CENTER_NUM)
		begin
			center_num_addr = cnt_k;

			center_num_cmd    = 1'b0;//读
			center_num_cmd_en = 1'b1;
			center_num_wr_data = 10'b0;
		end
		else
		begin
			center_num_addr   = 10'b0;
			center_num_cmd    = 1'b0;
			center_num_cmd_en = 1'b0;
			center_num_wr_data = 10'b0;
		end
	end
	mem_10b_dep1024 mem_10b_dep1024_center_num(
						. clk (clk),
						. rst(1'b0),

						. addr (center_num_addr),
						. cmd_en (center_num_cmd_en),
						. cmd (center_num_cmd),
						. wr_data (center_num_wr_data),
						. rd_data (center_num_rd_data),
						. rd_data_valid (center_num_rd_data_valid)
					);

	/*center_sum control*/
	always @(*)
	begin
		if(state == RST_BLOCK_SUM_AND_NUM)
		begin
			center_sum_addr   = cnt_k ;

			center_sum_cmd    = 1'b1;//写
			center_sum_cmd_en = 1'b1;
			center_sum_wr_data = 512'b0;
		end
		else if(state === STORE_CENTER_SUM_INIT_VALUE)
		begin
			center_sum_addr   = 10'b0;

			center_sum_cmd    = 1'b1;//写
			center_sum_cmd_en = 1'b1;

			center_sum_wr_data = opreand_data_0;
		end
		else if (state == LOAD_BELONG_CENTER_SUM )
		begin

			center_sum_addr   = cur_center_sum_addr ; //算belong地址,没办法用一个乘法器

			center_sum_cmd    = 1'b0;//读
			center_sum_cmd_en = 1'b1;
			center_sum_wr_data = 512'b0;
		end
		else if(state == STORE_BELONG_CENTER_SUM)
		begin
			center_sum_addr   = cur_center_sum_addr ; //算belong地址,没办法用一个乘法器

			center_sum_cmd    = 1'b1;//写
			center_sum_cmd_en = 1'b1;
			center_sum_wr_data = center_sum_reg;
		end
		else if (state == LOAD_UPDATE_CENTER_SUM )
		begin

			center_sum_addr   = cur_center_sum_addr ; //算belong地址,没办法用一个乘法器

			center_sum_cmd    = 1'b0;//读
			center_sum_cmd_en = 1'b1;
			center_sum_wr_data = 512'b0;
		end
		else
		begin
			center_sum_addr   = 10'b0;
			center_sum_cmd    = 1'b0;
			center_sum_cmd_en = 1'b0;
			center_sum_wr_data = 512'b0;
		end
	end
	mem_512b_dep1024 mem_512b_dep1024_center_sum(
						. clk (clk),
						. rst(1'b0),

						. addr (center_sum_addr),
						. cmd_en (center_sum_cmd_en),
						. cmd (center_sum_cmd),
						. wr_data (center_sum_wr_data),
						. rd_data (center_sum_rd_data),
						. rd_data_valid (center_sum_rd_data_valid)
					);

	/*ADD_SUB_control*/
	mux_16i1o_32b_no_dly mux_16i1o_32b_no_dly_0(
							.din_0_i(opreand_data_1[31:0]),
							.din_1_i(opreand_data_1[63:32]),
							.din_2_i(opreand_data_1[95:64]),
							.din_3_i(opreand_data_1[127:96]),
							.din_4_i(opreand_data_1[159:128]),
							.din_5_i(opreand_data_1[191:160]),
							.din_6_i(opreand_data_1[223:192]),
							.din_7_i(opreand_data_1[255:224]),
							.din_8_i(opreand_data_1[287:256]),
							.din_9_i(opreand_data_1[319:288]),
							.din_10_i(opreand_data_1[351:320]),
							.din_11_i(opreand_data_1[383:352]),
							.din_12_i(opreand_data_1[415:384]),
							.din_13_i(opreand_data_1[447:416]),
							.din_14_i(opreand_data_1[479:448]),
							.din_15_i(opreand_data_1[511:480]),
							.sel_i(cnt_dimension[3:0]),
							.dout_o(opreand_data_1_choose_32b)
						);
	mux_16i1o_32b_no_dly mux_16i1o_32b_no_dly_1(
							.din_0_i(opreand_data_2[31:0]),
							.din_1_i(opreand_data_2[63:32]),
							.din_2_i(opreand_data_2[95:64]),
							.din_3_i(opreand_data_2[127:96]),
							.din_4_i(opreand_data_2[159:128]),
							.din_5_i(opreand_data_2[191:160]),
							.din_6_i(opreand_data_2[223:192]),
							.din_7_i(opreand_data_2[255:224]),
							.din_8_i(opreand_data_2[287:256]),
							.din_9_i(opreand_data_2[319:288]),
							.din_10_i(opreand_data_2[351:320]),
							.din_11_i(opreand_data_2[383:352]),
							.din_12_i(opreand_data_2[415:384]),
							.din_13_i(opreand_data_2[447:416]),
							.din_14_i(opreand_data_2[479:448]),
							.din_15_i(opreand_data_2[511:480]),
							.sel_i(cnt_dimension[3:0]),
							.dout_o(opreand_data_2_choose_32b)
						);
	mux_16i1o_32b_no_dly mux_16i1o_32b_no_dly_2(
							.din_0_i(center_sum_reg[31:0]),
							.din_1_i(center_sum_reg[63:32]),
							.din_2_i(center_sum_reg[95:64]),
							.din_3_i(center_sum_reg[127:96]),
							.din_4_i(center_sum_reg[159:128]),
							.din_5_i(center_sum_reg[191:160]),
							.din_6_i(center_sum_reg[223:192]),
							.din_7_i(center_sum_reg[255:224]),
							.din_8_i(center_sum_reg[287:256]),
							.din_9_i(center_sum_reg[319:288]),
							.din_10_i(center_sum_reg[351:320]),
							.din_11_i(center_sum_reg[383:352]),
							.din_12_i(center_sum_reg[415:384]),
							.din_13_i(center_sum_reg[447:416]),
							.din_14_i(center_sum_reg[479:448]),
							.din_15_i(center_sum_reg[511:480]),
							.sel_i(cnt_dimension[3:0]),
							.dout_o(center_sum_reg_choose_32b)
						);
	always @(*)
	begin
		if(state == START_CALCULATE)
		begin
			add_sub_data_valid = 1'b1;
			op = 1'b1;//sub

			add_sub_data_a_0 = opreand_data_1_choose_32b;
			add_sub_data_b_0 = opreand_data_2_choose_32b;
		end
		else if(state == UPDATE_BELONG_CENTER_SUM)
		begin
			add_sub_data_valid = 1'b1;
			if(cnt_is_new_belong ==2'b0)
				op = 1'b1;//sub
			else
				op = 1'b0;//add

			add_sub_data_a_0 = center_sum_reg_choose_32b;
			add_sub_data_b_0 = opreand_data_1_choose_32b;
		end
		else
		begin
			add_sub_data_valid = 1'b0;

			op = 1'b0;

			add_sub_data_a_0 = 32'b0;
			add_sub_data_b_0 = 32'b0;
		end
	end


	floating_point_add_sub floating_point_add_sub_0 (
							.aclk(clk),                                        // input wire aclk
							.aresetn (rst_n),

							.s_axis_a_tvalid(add_sub_data_valid),                  // input wire s_axis_a_tvalid
							.s_axis_a_tready(add_sub_a_0_tready),                  // output wire s_axis_a_tready
							.s_axis_a_tdata(add_sub_data_a_0),                    // input wire [31 : 0] s_axis_a_tdata
							.s_axis_b_tvalid(add_sub_data_valid),                  // input wire s_axis_b_tvalid
							.s_axis_b_tready(add_sub_b_0_tready),                  // output wire s_axis_b_tready
							.s_axis_b_tdata(add_sub_data_b_0),                    // input wire [31 : 0] s_axis_b_tdata
							.s_axis_operation_tvalid(add_sub_data_valid),  // input wire s_axis_operation_tvalid
							.s_axis_operation_tready (),  // output wire s_axis_operation_tready
							.s_axis_operation_tdata ({6'b0,op}),    // input wire [7 : 0] s_axis_operation_tdata
							.m_axis_result_tvalid(add_sub_result_valid),        // output wire m_axis_result_tvalid
							.m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
							.m_axis_result_tdata(add_sub_result_0)           // output wire [31 : 0] m_axis_result_tdata
						);

	//compare control
	always @(*)
	begin
		if(state == WAIT_SQRT_RESULT & sqrt_result_valid)
		begin
			compare_valid    = 1'b1;
			compare_data_a_0 = sqrt_result_data;
			compare_data_b_0 = min_0;
		end
		else
		begin
			compare_valid    = 1'b0;
			compare_data_a_0 = 32'b0;
			compare_data_b_0 = 32'b0;
		end
	end


	floating_point_compare compare_0 (
							.aclk(clk),
							.aresetn (rst_n),
							// input wire aclk
							.s_axis_a_tdata(compare_data_a_0),                    // input wire [31 : 0] s_axis_a_tdata
							.s_axis_a_tvalid (compare_valid),                  // input wire s_axis_a_tvalid
							.s_axis_a_tready(compare_data_a_0_tready),                  // output wire s_axis_a_tready

							.s_axis_b_tdata(compare_data_b_0),                    // input wire [31 : 0] s_axis_b_tdata
							.s_axis_b_tvalid (compare_valid),                  // input wire s_axis_b_tvalid
							.s_axis_b_tready(compare_data_b_0_tready),                  // output wire s_axis_b_tready
							// .s_axis_operation_tvalid(s_axis_operation_tvalid),  // input wire s_axis_operation_tvalid
							// .s_axis_operation_tready(s_axis_operation_tready),  // output wire s_axis_operation_tready
							// .s_axis_operation_tdata(6'b001100),    // input wire [7 : 0] s_axis_operation_tdata
							.m_axis_result_tvalid(compare_result_valid),        // output wire m_axis_result_tvalid
							.m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
							.m_axis_result_tdata(compare_result)           // output wire [31 : 0] m_axis_result_tdata
						);

	//mul_contrl
	always @(*)
	begin
		if (state == WAIT_CALCULATE_SUB & add_sub_result_valid)
		begin
			mul_valid    = 1'b1;
			mul_data_a_0 = add_sub_result_0;
			mul_data_b_0 = add_sub_result_0;
		end
		else
		begin
			mul_valid    = 1'b0;
			mul_data_a_0 = 32'b0;
			mul_data_b_0 = 32'b0;
		end
	end


	floating_point_mul floating_point_mul_0(
						.aclk(clk),                                        // input wire aclk
						.aresetn (rst_n),

						.s_axis_a_tvalid(mul_valid),                  // input wire s_axis_a_tvalid
						.s_axis_a_tready(mul_data_a_0_tready),                  // output wire s_axis_a_tready
						.s_axis_a_tdata(mul_data_a_0),                    // input wire [31 : 0] s_axis_a_tdata
						.s_axis_b_tvalid(mul_valid),                  // input wire s_axis_b_tvalid
						.s_axis_b_tready(mul_data_b_0_tready),                  // output wire s_axis_b_tready
						.s_axis_b_tdata(mul_data_b_0),                    // input wire [31 : 0] s_axis_b_tdata
						.m_axis_result_tvalid(mul_result_valid),        // output wire m_axis_result_tvalid
						.m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
						.m_axis_result_tdata(mul_result_0)           // output wire [31 : 0] m_axis_result_tdata
					);

	//acc_control
	always @(*)
	begin
		if (state == WAIT_CALCULATE_MUL & mul_result_valid)
		begin
			acc_valid = 1'b1;
			acc_data  = mul_result_0;

			if (cnt_dimension == dimension)
				acc_last = 1'b1;
			else
				acc_last = 1'b0;
		end
		else
		begin
			acc_last  = 1'b0;
			acc_valid = 1'b0;
			acc_data  = 32'b0;
		end
	end


	floating_point_acc acc_0(
						. aclk (clk),
						.aresetn (rst_n),

						. s_axis_a_tvalid (acc_valid),
						. s_axis_a_tdata (acc_data),
						. s_axis_a_tready (acc_tready),
						. s_axis_a_tlast (acc_last),
						. m_axis_result_tready (1'b1),
						. m_axis_result_tvalid (acc_result_valid),
						. m_axis_result_tdata (acc_result_data)
					);

	//sqrt_control
	always @(*)
	begin
		if (state == WAIT_CALCULATE_ACC & acc_result_valid & cnt_dimension== dimension)
		begin
			sqrt_data_valid = 1'b1;
			sqrt_data  = acc_result_data;

		end
		else
		begin
			sqrt_data_valid = 1'b0;
			sqrt_data  = 32'b0;
		end
	end

	floating_point_sqrt sqrt_0(
							. aclk (clk),
							.aresetn (rst_n),

							. s_axis_a_tvalid (sqrt_data_valid),
							. s_axis_a_tdata (sqrt_data),
							. s_axis_a_tready (sqrt_tready),
							. m_axis_result_tready (1'b1),
							. m_axis_result_tvalid (sqrt_result_valid),
							. m_axis_result_tdata (sqrt_result_data)
						);
	//divide_contrl
	always @(*)
	begin
		if (state == UPDATE_CENTER)
		begin
			divide_valid    = 1'b1;
			divide_data_a_0 = center_sum_reg_choose_32b;
			divide_data_b_0 = center_num_float;
		end
		else
		begin
			divide_valid    = 1'b0;
			divide_data_a_0 = 32'b0;
			divide_data_b_0 = 32'b0;
		end
	end


	floating_point_divide floating_point_divide_0(
							.aclk(clk),                                        // input wire aclk
							.aresetn (rst_n),

							.s_axis_a_tvalid(divide_valid),                  // input wire s_axis_a_tvalid
							.s_axis_a_tready(divide_data_a_0_tready),                  // output wire s_axis_a_tready
							.s_axis_a_tdata(divide_data_a_0),                    // input wire [31 : 0] s_axis_a_tdata
							.s_axis_b_tvalid(divide_valid),                  // input wire s_axis_b_tvalid
							.s_axis_b_tready(divide_data_b_0_tready),                  // output wire s_axis_b_tready
							.s_axis_b_tdata(divide_data_b_0),                    // input wire [31 : 0] s_axis_b_tdata
							.m_axis_result_tvalid(divide_result_valid),        // output wire m_axis_result_tvalid
							.m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
							.m_axis_result_tdata(divide_result_0)           // output wire [31 : 0] m_axis_result_tdata
						);

	//uint_to_float_control
	always @(*)
	begin
		if (state == COVERT_NUM_TO_FLOAT)
		begin
			uint_to_float_data_valid = 1'b1;
			uint_to_float_data_0  = {22'b0,center_num_reg};

		end
		else
		begin
			uint_to_float_data_valid = 1'b0;
			uint_to_float_data_0  = 32'b0;
		end
	end

	floating_point_uint_to_float uint_to_float_0(
									. aclk (clk),
									.aresetn (rst_n),

									. s_axis_a_tvalid (uint_to_float_data_valid),
									. s_axis_a_tdata (uint_to_float_data_0),
									. s_axis_a_tready (uint_to_float_data_0_tready),
									. m_axis_result_tready (1'b1),
									. m_axis_result_tvalid (uint_to_float_result_valid),
									. m_axis_result_tdata (uint_to_float_result_data_0)
								);

	assign traing_num_test = traing_num;
	assign dimension_test = dimension;
	assign k_num_test = k_num;
	assign iteration_times_test = iteration_times;
	assign belong_start_addr_test = belong_start_addr;
	assign data_start_addr_test = data_start_addr;
	assign center_start_addr_test = center_start_addr;
	assign data_step_test = data_step;
	assign cur_belong_addr_test = cur_belong_addr;
	assign cur_center_mix_mux_addr_test = cur_center_mix_mux_addr;
	assign cur_data_addr_test = cur_data_addr;
	assign cur_center_addr_test = cur_center_addr;
	assign cur_center_sum_addr_test = cur_center_sum_addr;
	assign cur_times_test = cur_times;
	assign max_drift_test = max_drift;
	assign opreand_data_0_test = opreand_data_0;
	assign opreand_data_1_test = opreand_data_1;
	assign opreand_data_2_test = opreand_data_2;
	assign opreand_data_1_choose_32b_test = opreand_data_1_choose_32b;
	assign opreand_data_2_choose_32b_test = opreand_data_2_choose_32b;
	assign cnt_iteration_test = cnt_iteration;
	assign cnt_training_test = cnt_training;
	assign cnt_k_test = cnt_k;
	assign cnt_dimension_test = cnt_dimension;
	assign cnt_is_new_belong_test = cnt_is_new_belong;
	assign min_0_test = min_0;
	assign min_pos_test = min_pos;
	assign drift_addr_test = drift_addr;
	assign drift_test = drift;
	assign drift_valid_test = drift_valid;
	assign drift_cmd_test = drift_cmd;
	assign drift_cmd_en_test = drift_cmd_en;
	assign center_num_addr_test = center_num_addr;
	assign center_num_test = center_num;
	assign center_num_reg_test = center_num_reg;
	assign center_num_rd_data_valid_test = center_num_rd_data_valid;
	assign center_num_rd_data_test = center_num_rd_data;
	assign center_num_wr_data_test = center_num_wr_data;
	assign center_num_float_test = center_num_float;
	assign center_num_cmd_test = center_num_cmd;
	assign center_num_cmd_en_test = center_num_cmd_en;
	assign center_sum_cmd_test = center_sum_cmd;
	assign center_sum_cmd_en_test = center_sum_cmd_en;
	assign center_sum_addr_test = center_sum_addr;
	assign center_sum_rd_data_test = center_sum_rd_data;
	assign center_sum_reg_test = center_sum_reg;
	assign center_sum_reg_choose_32b_test = center_sum_reg_choose_32b;
	assign center_sum_rd_data_valid_test = center_sum_rd_data_valid;
	assign center_sum_wr_data_test = center_sum_wr_data;
	assign add_sub_data_a_0_test = add_sub_data_a_0;
	assign add_sub_data_b_0_test = add_sub_data_b_0;
	assign op_test = op;
	assign add_sub_data_valid_test = add_sub_data_valid;
	assign add_sub_result_valid_test = add_sub_result_valid;
	assign add_sub_result_0_test = add_sub_result_0;
	assign add_sub_result_0_reg_test = add_sub_result_0_reg;
	assign compare_valid_test = compare_valid;
	assign compare_data_a_0_test = compare_data_a_0;
	assign compare_data_b_0_test = compare_data_b_0;
	assign compare_result_test = compare_result;
	assign compare_result_valid_test = compare_result_valid;
	assign mul_valid_test = mul_valid;
	assign mul_data_a_0_test = mul_data_a_0;
	assign mul_data_b_0_test = mul_data_b_0;
	assign mul_result_0_test = mul_result_0;
	assign mul_result_valid_test = mul_result_valid;
	assign acc_valid_test = acc_valid;
	assign acc_data_test = acc_data;
	assign acc_last_test = acc_last;
	assign acc_result_valid_test = acc_result_valid;
	assign acc_result_data_test = acc_result_data;
	assign sqrt_data_valid_test = sqrt_data_valid;
	assign sqrt_data_test = sqrt_data;
	assign sqrt_result_valid_test = sqrt_result_valid;
	assign sqrt_result_data_test = sqrt_result_data;
	assign sqrt_result_reg_test = sqrt_result_reg;
	assign uint_to_float_data_valid_test = uint_to_float_data_valid;
	assign uint_to_float_data_0_test = uint_to_float_data_0;
	assign uint_to_float_result_valid_test = uint_to_float_result_valid;
	assign uint_to_float_result_data_0_test = uint_to_float_result_data_0;
	assign divide_valid_test = divide_valid;
	assign divide_data_a_0_test = divide_data_a_0;
	assign divide_data_b_0_test = divide_data_b_0;
	assign divide_result_0_test = divide_result_0;
	assign divide_result_valid_test = divide_result_valid;
	assign state_test = state;

endmodule