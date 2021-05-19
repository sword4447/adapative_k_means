//-----------------------------------------------------------------------------
//
// (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
// Project    : Series-7 Integrated Block for PCI Express
// File       : PIO_EP.v
// Version    : 3.2
//
// Description: Endpoint Programmed I/O module.
//              Consists of Receive and Transmit modules and a Memory Aperture
//
//------------------------------------------------------------------------------

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module PIO_EP #(
           parameter C_DATA_WIDTH = 64,            // RX/TX interface data width

           // Do not override parameters below this line
           parameter KEEP_WIDTH = C_DATA_WIDTH / 8,              // TSTRB width
           parameter TCQ        = 1
       ) (

           input ddr_clk,
           input ddr_rst_n,

           input          app_wdf_rdy,
           input           app_rdy,

           output reg [27:0]  app_addr,
           output reg [2:0]   app_cmd,
           output reg      app_en,


           output reg [511:0] app_wdf_data,
           output reg [63:0]  app_wdf_mask,
           output reg         app_wdf_wren,
           output          app_wdf_end,

           input [511:0] app_rd_data,
           input app_rd_data_end,
           input app_rd_data_valid,
           input k_means_work,


           input                         clk,
           input                         rst_n,
           // AXIS TX
           input                         s_axis_tx_tready,
           output  [C_DATA_WIDTH-1:0]    s_axis_tx_tdata,
           output  [KEEP_WIDTH-1:0]      s_axis_tx_tkeep,
           output                        s_axis_tx_tlast,
           output                        s_axis_tx_tvalid,
           output                        tx_src_dsc,

           //AXIS RX
           input   [C_DATA_WIDTH-1:0]    m_axis_rx_tdata,
           input   [KEEP_WIDTH-1:0]      m_axis_rx_tkeep,
           input                         m_axis_rx_tlast,
           input                         m_axis_rx_tvalid,
           output                        m_axis_rx_tready,
           input   [21:0]                m_axis_rx_tuser,

           output                        req_compl,
           output                        compl_done,//给PIO_TO_CTRL的

           input   [15:0]                cfg_completer_id
       );
	wire pcie_to_ddr_fifo_wr_wren;
	wire pcie_to_ddr_fifo_rd_wren;

	// Local wires

	wire  [31:0]      rd_data;
	//reg  rd_data_en;;

	wire  [29:0]      wr_addr;

	wire              req_compl_int;
	wire              req_compl_wd;
	wire              compl_done_int;

	wire  [2:0]       req_tc;
	wire              req_td;
	wire              req_ep;
	wire  [1:0]       req_attr;
	wire  [9:0]       req_len;
	wire  [15:0]      req_rid;
	wire  [7:0]       req_tag;
	wire  [7:0]       req_be;

	wire req_be_en;

	wire  [31:0]      req_addr;
	//wire  [31:0] ddr_rd_data;

	//
	// ENDPOINT MEMORY : 8KB memory aperture implemented in FPGA BlockRAM(*)
	//

	wire  [7:0]       wr_be;

	wire [31:0] wr_data;

	/*pcie to ddr*/
	reg [72:0] pcie_data;
	wire pcie_to_ddr_fifo_full;
	wire pcie_to_ddr_fifo_empty;
	reg pcie_data_wren;
	wire [72:0] pcie_data_fifo;
	reg pcie_data_fifo_rd_en;
	wire pcie_data_fifo_valid;
	reg [511:0] app_rd_data_min_store;


	always @(posedge clk)
		if(pcie_to_ddr_fifo_wr_wren)
			pcie_data [7:0] <= wr_be;
		else
			pcie_data [7:0] <= {4'b0000,req_be};
	always @(posedge clk)
		if(!rst_n)
			pcie_data_wren <= 1'b0;
		else
			pcie_data_wren <= pcie_to_ddr_fifo_wr_wren || pcie_to_ddr_fifo_rd_wren;


	always @(posedge clk)
		if(!rst_n)
			pcie_data[72] <= 1'b0;
		else
			pcie_data[72] <= pcie_to_ddr_fifo_wr_wren; //TLP写包写的时候为高
	always @(posedge clk)
		if(pcie_to_ddr_fifo_wr_wren)
		begin//要特别注意这个是实践发现的，注意包里的是小端存储还是大端存储
			pcie_data[71:40] <= wr_data ;
		end
		else
			pcie_data [71:40] <= 32'd0;
	always @(posedge clk)
		if(pcie_to_ddr_fifo_wr_wren)
			pcie_data [39:8] <=  {2'b0,wr_addr}  ;
		else
			pcie_data [39:8] <= {2'b0,req_addr[31:2]};


	fifo_wr73_rd73_asy pcie_to_ddr_fifo //1+32+32+8 rd + data +ddr +be
					(
						.full (pcie_to_ddr_fifo_full),
						.empty(pcie_to_ddr_fifo_empty),

						.din (pcie_data),
						.wr_en (pcie_data_wren),

						.dout (pcie_data_fifo),
						.rd_en (pcie_data_fifo_rd_en),
						.valid (pcie_data_fifo_valid),

						.wr_clk (clk),
						.rd_clk (ddr_clk),

						.rst (~rst_n) //high
					);

	reg rd_data_rd_en;
	wire rd_data_valid;

	wire [31:0] ddr_rd_data_first;
	reg [31:0]  ddr_rd_data;
	reg  ddr_rd_data_wren;
	reg app_rd_data_valid_h;
	reg [15:0] rd_data_choose;

	fifo_wr32_rd32_asy ddr_to_pcie_fifo
					(
						.full (rd_data_fifo_full),
						.empty(rd_data_fifo_empty),
						/*ddr*/
						.din (ddr_rd_data),
						.wr_en (ddr_rd_data_wren),//写和读之间至少隔着一个TLP读请求处理包的时间，所以不用检测是否为full，不可能满的

						/*pcie*/
						.dout (rd_data),
						.rd_en (rd_data_rd_en),
						.valid (rd_data_valid),

						.wr_clk (ddr_clk),
						.rd_clk (clk),

						.rst (~rst_n) //high
					);
	always @(posedge clk)
	begin
		if(!rst_n)
			rd_data_rd_en <= 1'b0;
		else if(!rd_data_fifo_empty)
			rd_data_rd_en <= 1'b1;
		else
			rd_data_rd_en <= 1'b0;
	end



	PIO_RX_ENGINE #(
					.C_DATA_WIDTH( C_DATA_WIDTH ),
					.KEEP_WIDTH( KEEP_WIDTH ),
					.TCQ( TCQ )
				)
				EP_RX_inst (

					.clk(clk),                              // I
					.rst_n(rst_n),                          // I
					.ddr_fifo_full (pcie_to_ddr_fifo_full),

					// AXIS RX
					.m_axis_rx_tdata( m_axis_rx_tdata ),    // I
					.m_axis_rx_tkeep( m_axis_rx_tkeep ),    // I
					.m_axis_rx_tlast( m_axis_rx_tlast ),    // I
					.m_axis_rx_tvalid( m_axis_rx_tvalid ),  // I
					.m_axis_rx_tready( m_axis_rx_tready ),  // O
					.m_axis_rx_tuser ( m_axis_rx_tuser ),   // I

					// Handshake with Tx engine
					.req_compl(req_compl_int),              // O
					.req_compl_wd(req_compl_wd),            // O
					.compl_done(compl_done_int),            // I

					.req_tc(req_tc),                        // O [2:0]
					.req_td(req_td),                        // O
					.req_ep(req_ep),                        // O
					.req_attr(req_attr),                    // O [1:0]
					.req_len(req_len),                      // O [9:0]
					.req_rid(req_rid),                      // O [15:0]
					.req_tag(req_tag),                      // O [7:0]
					.req_be(req_be),                        // O [7:0]
					.req_addr (req_addr),                    // O [12:0]

					.wr_addr(wr_addr),                      // O [10:0]
					.wr_be(wr_be),                          // O [7:0]

					.wr_data(wr_data),                      // O [31:0]

					.pcie_to_ddr_fifo_wr_wren(pcie_to_ddr_fifo_wr_wren),
					.pcie_to_ddr_fifo_rd_wren(pcie_to_ddr_fifo_rd_wren)
					// Memory Write Port

				);

	//
	// Local-Link Transmit Controller
	//

	PIO_TX_ENGINE #(
					.C_DATA_WIDTH( C_DATA_WIDTH ),
					.KEEP_WIDTH( KEEP_WIDTH ),
					.TCQ( TCQ )
				)EP_TX_inst(

					.clk(clk),                                  // I
					.rst_n(rst_n),                              // I

					//AXIS Tx
					.s_axis_tx_tready( s_axis_tx_tready ),      // I
					.s_axis_tx_tdata( s_axis_tx_tdata ),        // O
					.s_axis_tx_tkeep( s_axis_tx_tkeep ),        // O
					.s_axis_tx_tlast( s_axis_tx_tlast ),        // O
					.s_axis_tx_tvalid( s_axis_tx_tvalid ),      // O
					.tx_src_dsc( tx_src_dsc ),                  // O

					//Handshake with Rx engine
					.req_compl(req_compl_int),                // I
					.req_compl_wd(req_compl_wd),              // I
					.compl_done(compl_done_int),                // 0

					.req_tc(req_tc),                          // I [2:0]
					.req_td(req_td),                          // I
					.req_ep(req_ep),                          // I
					.req_attr(req_attr),                      // I [1:0]
					.req_len(req_len),                        // I [9:0]
					.req_rid(req_rid),                        // I [15:0]
					.req_tag(req_tag),                        // I [7:0]
					.req_be(req_be),                          // I [7:0]
					.req_addr(req_addr),                      // I [12:0]

					//Read Port

					.rd_data(rd_data),                        // I [31:0]
					.rd_data_valid(rd_data_valid),                        // I [31:0]

					.completer_id(cfg_completer_id)           // I [15:0]

				);


	always@(*)
	begin
		if(ddr_state == DDR_WAIT_RD & app_rdy)
		begin
			app_cmd = 3'b001;//读信号
			app_en = 1'b1;
			app_wdf_wren = 1'b0;
		end
		else if(ddr_state == DDR_WAIT_WR & app_rdy & app_wdf_rdy)
		begin
			app_cmd = 3'b000;//写信号
			app_en = 1'b1;
			app_wdf_wren = 1'b1;
		end
		else
		begin
			app_wdf_wren = 1'b0;
			app_cmd = 3'b000;
			app_en = 1'b0;//无效
		end
	end

	localparam DDR_WAIT_K_MEANS = 7'b000_0001; //0
	localparam DDR_RST = 7'b000_0010; //1
	localparam DDR_ANALYSE = 7'b000_0100; //2
	localparam DDR_WAIT_RD = 7'b000_1000; //3
	localparam DDR_WAIT_WR = 7'b001_0000; //4
	localparam DDR_WAIT_READ_0 = 7'b010_0000; //5
	localparam DDR_WAIT_READ_1 = 7'b100_0000; //6
	reg[6:0] ddr_state;
	reg [511:0] app_rd_data_reg;
	always @(posedge ddr_clk)
	begin
		if(!ddr_rst_n)
		begin
			app_rd_data_reg <= 512'b0;

			ddr_rd_data <= 32'b0;
			ddr_rd_data_wren <= 1'b0;

			app_rd_data_valid_h <= 1'b0;

			pcie_data_fifo_rd_en <= 1'b0;

			// app_cmd <= 3'b0;
			// app_en <= 1'b0;

			app_addr <= 28'b0;

			app_wdf_data <= 512'b0;
			// app_wdf_wren <= 1'b0;
			app_wdf_mask <= 64'hffff_ffff_ffff_ffff ;

			ddr_state <=DDR_WAIT_K_MEANS;
		end
		else
		begin
			case(ddr_state)
				DDR_WAIT_K_MEANS:
				begin
					if(!k_means_work)
						ddr_state <= DDR_RST;
				end
				DDR_RST:
				begin

					//app_wdf_mask <= 64'hffff_ffff_ffff_ffff ;
					//app_rd_data_reg <= 512'b0;


					ddr_rd_data_wren <= 1'b0;
					// app_en <= 1'b0;
					// app_wdf_wren <= 1'b0;

					if(!pcie_to_ddr_fifo_empty)
					begin
						pcie_data_fifo_rd_en <= 1'b1;

						ddr_state <= DDR_ANALYSE;
					end
				end

				DDR_ANALYSE:
				begin
					pcie_data_fifo_rd_en <= 1'b0;

					if(pcie_data_fifo_valid)
					begin //39 到 8 38到14  //写ddr从小端变成大端，实际上只要改成wdf_mask就行
						app_addr[25:3] <= pcie_data_fifo[34:12];//每满16进8

						if(pcie_data_fifo[72])
						begin
							app_wdf_data[511:0] <= {pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],

													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],

													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],

													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64],
													pcie_data_fifo[47:40],pcie_data_fifo[55:48],pcie_data_fifo[63:56],pcie_data_fifo[71:64]};//copy sixteen 因为有掩码所以不用多路选择器
							//app_wdf_mask <= { 60'hffff_ffff_ffff_fff, !pcie_data_fifo[3], !pcie_data_fifo[2], !pcie_data_fifo[1], !pcie_data_fifo[0]};//屏蔽掉高480位


							if(pcie_data_fifo[11:8] == 4'b0000 )
								app_wdf_mask[3:0] <= 4'b0;
							else
								app_wdf_mask[3:0] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b0001 )
								app_wdf_mask[7:4] <= 4'b0;
							else
								app_wdf_mask[7:4] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b0010 )
								app_wdf_mask[11:8] <= 4'b0;
							else
								app_wdf_mask[11:8] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b0011 )
								app_wdf_mask[15:12] <= 4'b0;
							else
								app_wdf_mask[15:12] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b0100 )
								app_wdf_mask[19:16] <= 4'b0;
							else
								app_wdf_mask[19:16] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b0101 )
								app_wdf_mask[23:20] <= 4'b0;
							else
								app_wdf_mask[23:20] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b0110 )
								app_wdf_mask[27:24] <= 4'b0;
							else
								app_wdf_mask[27:24] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b0111 )
								app_wdf_mask[31:28] <= 4'b0;
							else
								app_wdf_mask[31:28] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b1000 )
								app_wdf_mask[35:32] <= 4'b0;
							else
								app_wdf_mask[35:32] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b1001 )
								app_wdf_mask[39:36] <= 4'b0;
							else
								app_wdf_mask[39:36] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b1010 )
								app_wdf_mask[43:40] <= 4'b0;
							else
								app_wdf_mask[43:40] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b1011 )
								app_wdf_mask[47:44] <= 4'b0;
							else
								app_wdf_mask[47:44] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b1100 )
								app_wdf_mask[51:48] <= 4'b0;
							else
								app_wdf_mask[51:48] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b1101 )
								app_wdf_mask[55:52] <= 4'b0;
							else
								app_wdf_mask[55:52] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b1110 )
								app_wdf_mask[59:56] <= 4'b0;
							else
								app_wdf_mask[59:56] <=  4'hf;
							if(pcie_data_fifo[11:8] == 4'b1111 )
								app_wdf_mask[63:60] <= 4'b0;
							else
								app_wdf_mask[63:60] <=  4'hf;
							//app_wdf_data[511:0] <= 512'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
							//app_wdf_mask <= { 64'hf0f0_f0f0_f0f0_f0f0};//屏蔽掉高480位

							ddr_state <=  DDR_WAIT_WR;
						end
						else
						begin
							ddr_state <=  DDR_WAIT_RD;
						end
					end
				end


				DDR_WAIT_RD:
				begin
					if(app_en)
					begin
						ddr_state <= DDR_WAIT_READ_0;
					end
				end

				DDR_WAIT_WR:
				begin
					if(app_en)
					begin
						ddr_state <= DDR_WAIT_K_MEANS;
					end
				end

				DDR_WAIT_READ_0:
				begin
					if(app_rd_data_valid)
					begin
						app_rd_data_reg <= app_rd_data;

						ddr_state <= DDR_WAIT_READ_1 ;
					end

				end
				DDR_WAIT_READ_1:
				begin
					ddr_rd_data_wren <= 1'b1;
					ddr_rd_data <= {ddr_rd_data_first[7:0],ddr_rd_data_first[15:8],ddr_rd_data_first[23:16],ddr_rd_data_first[31:24]};
					ddr_state <= DDR_WAIT_K_MEANS;
				end
			endcase
		end
	end

	mux_16i1o_32b_no_dly mux_16i1o_32b_no_dly_0(
							.din_0_i(app_rd_data_reg[31:0]),
							.din_1_i(app_rd_data_reg[63:32]),
							.din_2_i(app_rd_data_reg[95:64]),
							.din_3_i(app_rd_data_reg[127:96]),
							.din_4_i(app_rd_data_reg[159:128]),
							.din_5_i(app_rd_data_reg[191:160]),
							.din_6_i(app_rd_data_reg[223:192]),
							.din_7_i(app_rd_data_reg[255:224]),
							.din_8_i(app_rd_data_reg[287:256]),
							.din_9_i(app_rd_data_reg[319:288]),
							.din_10_i(app_rd_data_reg[351:320]),
							.din_11_i(app_rd_data_reg[383:352]),
							.din_12_i(app_rd_data_reg[415:384]),
							.din_13_i(app_rd_data_reg[447:416]),
							.din_14_i(app_rd_data_reg[479:448]),
							.din_15_i(app_rd_data_reg[511:480]),
							.sel_i(pcie_data_fifo[11:8]),
							.dout_o(ddr_rd_data_first)
						);

	assign app_wdf_end = app_wdf_wren;

	assign req_compl  = req_compl_int;
	assign compl_done = compl_done_int;
endmodule // PIO_EP
