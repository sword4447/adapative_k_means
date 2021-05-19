`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/04/09 08:27:22
// Design Name:
// Module Name: PIO_EP_tb
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


module PIO_EP_tb(

       );
	localparam period = 4;
	localparam ddr_period = 2;
	
	localparam fmt_0 = 1'b0;
	
	localparam PIO_RX_MEM_RD32_FMT_TYPE = 7'b00_00000;
	localparam PIO_RX_MEM_WR32_FMT_TYPE = 7'b10_00000;
	
	localparam R = 1'b0;
	localparam TC = 3'd1;
	localparam R_1 = 1'b0;
	localparam Attr2 = 1'd0;
	localparam R_2 = 1'b0;
	localparam TH = 1'b0;
	localparam TD = 1'b0;
	localparam EP = 1'b0;
	localparam Attr = 2'd1;
	localparam AT = 2'd1;
	localparam PIO_length = 10'b1;
	
	localparam Requeest_ID = 16'd1;
	localparam Tag = 8'd1;
	localparam LastDWBE = 4'b1111;
	localparam FirstDWBE = 4'b1111;
	
	localparam addr1 = {18'b0,10'd234 };
	localparam addr2 = {18'b0,10'd345};
	localparam data_0 = 32'd3333;
	
	localparam PIO_RX_RST_STATE            = 8'b00000000;
	localparam PIO_RX_MEM_RD32_DW1DW2      = 8'b00000001;
	localparam PIO_RX_MEM_WR32_DW1DW2      = 8'b00000010;
	localparam PIO_RX_WAIT_STATE           = 8'b00100000;
	
	parameter C_DATA_WIDTH = 64;
	parameter KEEP_WIDTH = C_DATA_WIDTH/8;
	
	reg  app_wdf_rdy;
	wire [27:0] app_addr;
	wire [2:0] app_cmd;
	wire  app_en;
	reg  app_rdy;
	wire [511:0] app_wdf_data;
	wire [63:0] app_wdf_mask;
	wire  app_wdf_wren;
	wire  app_wdf_end;
	reg [511:0] app_rd_data;
	reg  app_rd_data_end;
	reg  app_rd_data_valid;
	
	reg  clk;
	reg  ddr_clk;
	reg  rst_n;
	reg  s_axis_tx_tready;
	wire [C_DATA_WIDTH-1:0] s_axis_tx_tdata;
	wire [KEEP_WIDTH-1:0] s_axis_tx_tkeep;
	wire  s_axis_tx_tlast;
	wire  s_axis_tx_tvalid;
	wire  tx_src_dsc;
	reg [C_DATA_WIDTH-1:0] m_axis_rx_tdata;
	reg [KEEP_WIDTH-1:0] m_axis_rx_tkeep;
	reg  m_axis_rx_tlast;
	reg  m_axis_rx_tvalid;
	wire  m_axis_rx_tready;
	reg [21:0] m_axis_rx_tuser;
	wire  req_compl;
	wire [31:0] ddr_wr_addr_test;
	wire [31:0] ddr_wr_data_test;
	wire [31:0] ddr_rd_data_test;
	wire [7:0] ddr_wr_be_test;
	reg [15:0] cfg_completer_id;
	wire [3:0] ddr_rd_be_test;
	wire  compl_done;
	
	PIO_EP  #(
            	.C_DATA_WIDTH (64),
            	.KEEP_WIDTH (8),
            	.TCQ (1)
        	)
        	PIO_EP_1(
            	. app_wdf_rdy(app_wdf_rdy),
            	. app_addr(app_addr),
            	. app_cmd(app_cmd),
            	. app_en(app_en),
            	. app_rdy(app_rdy),
            	. app_wdf_data(app_wdf_data),
            	. app_wdf_mask(app_wdf_mask),
            	. app_wdf_wren(app_wdf_wren),
            	. app_wdf_end(app_wdf_end),
            	. app_rd_data(app_rd_data),
            	. app_rd_data_end(app_rd_data_end),
            	. app_rd_data_valid(app_rd_data_valid),
	
            	. clk(clk),
            	. ddr_clk(ddr_clk),
            	. rst_n(rst_n),
            	. s_axis_tx_tready(s_axis_tx_tready),
            	. s_axis_tx_tdata(s_axis_tx_tdata),
            	. s_axis_tx_tkeep(s_axis_tx_tkeep),
            	. s_axis_tx_tlast(s_axis_tx_tlast),
            	. s_axis_tx_tvalid(s_axis_tx_tvalid),
            	. tx_src_dsc(tx_src_dsc),
            	. m_axis_rx_tdata(m_axis_rx_tdata),
            	. m_axis_rx_tkeep(m_axis_rx_tkeep),
            	. m_axis_rx_tlast(m_axis_rx_tlast),
            	. m_axis_rx_tvalid(m_axis_rx_tvalid),
            	. m_axis_rx_tready(m_axis_rx_tready),
            	. m_axis_rx_tuser(m_axis_rx_tuser),
            	. req_compl(req_compl),
            	. compl_done(compl_done),
            	. cfg_completer_id(cfg_completer_id)
        	);
	
	initial
	begin
    	app_wdf_rdy = 1'b1;
    	app_rdy = 1'b1;
    	m_axis_rx_tkeep = 8'b1111_1111;
    	cfg_completer_id = 16'd4447;
    	m_axis_rx_tuser = 22'b0;
    	s_axis_tx_tready=1;
    	clk = 0;
    	clk = 0;
    	ddr_clk = 0;
	
    	m_axis_rx_tdata = 0;
    	m_axis_rx_tvalid = 0;
    	m_axis_rx_tlast = 0;
	
    	rst_n=1;
    	#(period *1)
     	rst_n=0;
    	#(period *1)
     	rst_n=1;
	
    	#(period *50)
     	m_axis_rx_tdata = {Requeest_ID, Tag, LastDWBE, FirstDWBE,
                        	fmt_0, PIO_RX_MEM_WR32_FMT_TYPE, R, TC, R_1, Attr2, R_2, TH,TD, EP, Attr, AT, PIO_length};
    	m_axis_rx_tvalid = 1;
    	m_axis_rx_tlast = 1;
    	#(period *1)
     	m_axis_rx_tdata = {addr1,data_0};
    	m_axis_rx_tvalid = 1;
    	m_axis_rx_tlast = 1;
    	#(period *1)
     	m_axis_rx_tvalid = 0;
    	m_axis_rx_tlast = 0;
	
	
    	#(period *10)
     	m_axis_rx_tdata = {Requeest_ID, Tag, LastDWBE, FirstDWBE,
                        	fmt_0, PIO_RX_MEM_RD32_FMT_TYPE, R, TC, R_1, Attr2, R_2, TH,TD, EP, Attr, AT, PIO_length};
    	/* 0000000000000000000000000000000101001010000100000001_00_0000000001 */
    	m_axis_rx_tvalid = 1;
    	m_axis_rx_tlast = 0;
    	#(period *1)
     	m_axis_rx_tdata = {addr2,32'b0};
    	m_axis_rx_tvalid = 1;
    	m_axis_rx_tlast = 1;
    	#(period *1)
     	m_axis_rx_tvalid = 0;
    	m_axis_rx_tlast = 0;
	
	end
	
	always #(period / 2) clk = ~clk;
	always #(ddr_period / 2) ddr_clk = ~ddr_clk;
endmodule
