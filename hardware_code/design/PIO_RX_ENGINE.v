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
// File       : PIO_RX_ENGINE.v
// Version    : 3.2
//--
//-- Description: Local-Link Receive Unit.
//--
//--------------------------------------------------------------------------------

`timescale 1ps/1ps


(* DowngradeIPIdentifiedWarnings = "yes" *)
module PIO_RX_ENGINE  #(
           parameter TCQ = 1,
           parameter C_DATA_WIDTH = 64,            // RX/TX interface data width

           // Do not override parameters below this line
           parameter KEEP_WIDTH = C_DATA_WIDTH / 8               // TSTRB width
       ) (
           input                         clk,
           input                         rst_n,
           input ddr_fifo_full,

           //input fifo_full,
           // AXI-S
           input  [C_DATA_WIDTH-1:0]     m_axis_rx_tdata,
           input  [KEEP_WIDTH-1:0]       m_axis_rx_tkeep,
           input                         m_axis_rx_tlast,
           input                         m_axis_rx_tvalid,
           output reg                    m_axis_rx_tready,
           input    [21:0]               m_axis_rx_tuser,


           //  Memory Read data handshake with Completion
           //  transmit unit. Transmit unit reponds to
           //  req_compl assertion and responds with compl_done
           //  assertion when a Completion w/ data is transmitted.


           output reg         req_compl,
           output reg         req_compl_wd,
           input              compl_done,

           output reg [2:0]   req_tc,                        // Memory Read TC
           output reg         req_td,                        // Memory Read TD
           output reg         req_ep,                        // Memory Read EP
           output reg [1:0]   req_attr,                      // Memory Read Attribute
           output reg [9:0]   req_len,                       // Memory Read Length (1DW)
           output reg [15:0]  req_rid,                       // Memory Read Requestor ID
           output reg [7:0]   req_tag,                       // Memory Read Tag
           output reg [7:0]   req_be,                        // Memory Read Byte Enables
           output reg [31:0]  req_addr,                      // Memory Read Address

           //output reg req_be_en,
           //output reg req_addr_en,

           // Memory interface used to save 1 DW data received
           // on Memory Write 32 TLP. Data extracted from
           // inbound TLP is presented to the Endpoint memory
           // unit. Endpoint memory unit reacts to wr_en
           // assertion and asserts wr_busy when it is
           // processing written information.


           output reg [29:0]  wr_addr,                       // Memory Write Address
           output reg [7:0]   wr_be,                         // Memory Write Byte Enable
           //output reg         wr_be_en,                         // Memory Write Enable

           output reg [31:0]  wr_data,                       // Memory Write Data
           //output reg         wr_data_and_addr_en,                         // Memory Write Enable
           output reg pcie_to_ddr_fifo_wr_wren,
           output reg pcie_to_ddr_fifo_rd_wren
       );

  localparam PIO_RX_MEM_RD32_FMT_TYPE = 7'b00_00000;
  localparam PIO_RX_MEM_WR32_FMT_TYPE = 7'b10_00000;

  localparam PIO_RX_RST_STATE            = 8'b00000000;
  localparam PIO_RX_MEM_RD32_DW1DW2      = 8'b00000001;

  //localparam PIO_RX_MEM_WR32_WAIT_FIFO      = 8'b00000010;

  localparam PIO_RX_MEM_WR32_DW1DW2      = 8'b00000010;
  localparam PIO_WAIT_RD_FIFO_NOT_FULL = 8'b00000011;
  localparam PIO_WAIT_WR_FIFO_NOT_FULL = 8'b00000100;

  //localparam PIO_RX_MEM_WR32_DW1DW2      = 8'b00000010;

  localparam PIO_RX_WAIT_STATE           = 8'b00100000;
  localparam PIO_RX_IO_MEM_WR_WAIT_STATE = 8'b10000000;


  // Local Registers

  reg [7:0]          state;
  reg [7:0]          tlp_type;

  reg [1:0]          region_select;


  wire               sop;                   // Start of packet
  reg                in_packet_q;

  // Generate a signal that indicates if we are currently receiving a packet.
  // This value is one clock cycle delayed from what is actually on the AXIS
  // data bus.
  always@(posedge clk)
  begin
      if(!rst_n)
          in_packet_q <= #   TCQ 1'b0;
      else if (m_axis_rx_tvalid && m_axis_rx_tready && m_axis_rx_tlast)
          in_packet_q <= #   TCQ 1'b0;
      else if (sop && m_axis_rx_tready)
          in_packet_q <= #   TCQ 1'b1;

  end

  assign sop = !in_packet_q && m_axis_rx_tvalid;

  always @ ( posedge clk )
  begin //只用复位使能信号就行，解析信号不用复位，因为不使能解析了也没用

      if (!rst_n )
      begin
          //准备信号线，复位应该是已经准备好了
          m_axis_rx_tready <= #TCQ 1'b1;
          //所有要解析的内容
          req_compl    <= #TCQ 1'b0;
          req_compl_wd <= #TCQ 1'b0;

          req_tc       <= #TCQ 3'b0;
          req_td       <= #TCQ 1'b0;
          req_ep       <= #TCQ 1'b0;
          req_attr     <= #TCQ 2'b0;
          req_len      <= #TCQ 10'b0;
          req_rid      <= #TCQ 16'b0;
          req_tag      <= #TCQ 8'b0;
          req_be       <= #TCQ 8'b0;
          req_addr     <= #TCQ 32'b0;

          wr_be        <= #TCQ 8'b0;
          // wr_be_en <= 1'b0;
          pcie_to_ddr_fifo_wr_wren <= 1'b0;
          pcie_to_ddr_fifo_rd_wren <= 1'b0;

          wr_addr      <= #TCQ 30'b0;
          wr_data      <= #TCQ 32'b0;
          //wr_data_and_addr_en        <= #TCQ 1'b0;

          //req_addr_en        <= #TCQ 1'b0;
          //req_be_en        <= #TCQ 1'b0;

          state        <= #TCQ PIO_RX_RST_STATE;
          tlp_type     <= #TCQ 8'b0;

      end
      else
      begin

          //wr_data_and_addr_en        <= #TCQ 1'b0;
          //req_addr_en        <= #TCQ 1'b0;
          //req_be_en       <= #TCQ 1'b0;
          // pcie_to_ddr_fifo_wr_wren <= 1'b0;
          // pcie_to_ddr_fifo_rd_wren <= 1'b0;
          // req_compl    <= #TCQ 1'b0;

          case (state)

              PIO_RX_RST_STATE :
              begin

                  //m_axis_rx_tready <= #TCQ 1'b1;
                  pcie_to_ddr_fifo_wr_wren <= 1'b0;
                  //req_compl_wd     <= #TCQ 1'b1;


                  if (sop)
                  begin

                      case (m_axis_rx_tdata[30:24])//这一段只是在复位状态下不断检测包的类型

                          PIO_RX_MEM_RD32_FMT_TYPE :
                          begin

                              tlp_type     <= #TCQ m_axis_rx_tdata[31:24];
                              req_len      <= #TCQ m_axis_rx_tdata[9:0];
                              m_axis_rx_tready <= #TCQ 1'b0;


                              if (m_axis_rx_tdata[9:0] == 10'b1)
                              begin

                                  req_tc     <= #TCQ m_axis_rx_tdata[22:20];
                                  req_td     <= #TCQ m_axis_rx_tdata[15];
                                  req_ep     <= #TCQ m_axis_rx_tdata[14];
                                  req_attr   <= #TCQ m_axis_rx_tdata[13:12];
                                  req_len    <= #TCQ m_axis_rx_tdata[9:0];
                                  req_rid    <= #TCQ m_axis_rx_tdata[63:48];
                                  req_tag    <= #TCQ m_axis_rx_tdata[47:40];
                                  req_be     <= #TCQ m_axis_rx_tdata[39:32];

                                  // req_be_en   <= #TCQ 1'b1;

                                  state      <= #TCQ PIO_RX_MEM_RD32_DW1DW2;

                              end // if (m_axis_rx_tdata[9:0] == 10'b1)
                              else
                              begin

                                  state        <= #TCQ PIO_RX_RST_STATE;

                              end // if !(m_axis_rx_tdata[9:0] == 10'b1)

                          end // PIO_RX_MEM_RD32_FMT_TYPE

                          PIO_RX_MEM_WR32_FMT_TYPE :
                          begin

                              tlp_type     <= #TCQ m_axis_rx_tdata[31:24];
                              req_len      <= #TCQ m_axis_rx_tdata[9:0];
                              m_axis_rx_tready <= #TCQ 1'b0;

                              if (m_axis_rx_tdata[9:0] == 10'b1)
                              begin

                                  wr_be      <= #TCQ m_axis_rx_tdata[39:32];

                                  //wr_be_en <= 1'b1;

                                  state      <= #TCQ PIO_RX_MEM_WR32_DW1DW2;

                              end // if (m_axis_rx_tdata[9:0] == 10'b1)
                              else
                              begin

                                  state      <= #TCQ PIO_RX_RST_STATE;

                              end // if !(m_axis_rx_tdata[9:0] == 10'b1)

                              /*PIO_WAIT_WR_BE_FIFO_NOT_FULL:
                                if(!wr_data_or_addr_fifo_full) begin
                                  wr_data_and_addr_en        <= #TCQ 1'b0;
                                  state        <= #TCQ  PIO_RX_WAIT_STATE;
                                end
                                else 
                                  state        <= #TCQ PIO_WAIT_WR_BE_FIFO_NOT_FULL;*/

                          end // PIO_RX_MEM_WR32_FMT_TYPE

                          default :
                          begin // other TLPs

                              state        <= #TCQ PIO_RX_RST_STATE;

                          end // default

                      endcase

                  end // if (sop)
                  else
                      state <= #TCQ PIO_RX_RST_STATE;

              end // PIO_RX_RST_STATE

              PIO_RX_MEM_RD32_DW1DW2 :
              begin

                  //req_be_en       <= #TCQ 1'b0;
                  if (m_axis_rx_tvalid)
                  begin

                      req_addr     <= #TCQ {m_axis_rx_tdata[31:2], 2'b00};
                      state        <= #TCQ PIO_WAIT_RD_FIFO_NOT_FULL;

                  end // if (m_axis_rx_tvalid)
                  else
                      state        <= #TCQ PIO_RX_MEM_RD32_DW1DW2;

              end // PIO_RX_MEM_RD32_DW1DW2

              PIO_WAIT_RD_FIFO_NOT_FULL:     //读不光要等FIFO可以把地址和数据写进去还得等读出来
                  if(!ddr_fifo_full)
                  begin
                      pcie_to_ddr_fifo_rd_wren <= 1'b1;


                      req_compl    <= #TCQ 1'b1;
                      req_compl_wd <= #TCQ 1'b1;
                      state        <= #TCQ  PIO_RX_WAIT_STATE;
                  end
                  else
                      state        <= #TCQ PIO_WAIT_RD_FIFO_NOT_FULL;

              PIO_RX_MEM_WR32_DW1DW2 :
              begin
                  if (m_axis_rx_tvalid)
                  begin

                      wr_data      <= #TCQ m_axis_rx_tdata[63:32];
                      wr_addr      <= #TCQ {m_axis_rx_tdata[31:2]};
                      state        <= #TCQ  PIO_WAIT_WR_FIFO_NOT_FULL;

                  end // if (m_axis_rx_tvalid)
                  else
                      state        <= #TCQ PIO_RX_MEM_WR32_DW1DW2;

              end // PIO_RX_MEM_WR32_DW1DW2

              PIO_WAIT_WR_FIFO_NOT_FULL:     //满了就等着吧
                  if(!ddr_fifo_full)
                  begin
                      pcie_to_ddr_fifo_wr_wren        <= #TCQ 1'b1;

                      m_axis_rx_tready <= #TCQ 1'b1;//当把这个数据丢进去了之后就意味着当前任务完成

                      state        <= #TCQ  PIO_RX_RST_STATE;
                  end
                  else
                      state        <= #TCQ PIO_WAIT_WR_FIFO_NOT_FULL;


              PIO_RX_WAIT_STATE :
              begin //这个状态应该是等FIFO有数据

                  req_compl  <= #TCQ 1'b0;
                  pcie_to_ddr_fifo_rd_wren <= 1'b0;
                  req_compl    <= #TCQ 1'b0;
                  req_compl_wd <= #TCQ 1'b0;
                  if (compl_done)
                  begin

                      m_axis_rx_tready <= #TCQ 1'b1;
                      state        <= #TCQ PIO_RX_RST_STATE;

                  end // if ((tlp_type == PIO_RX_MEM_RD32_FMT_TYPE) && (compl_done))
                  else
                      state        <= #TCQ PIO_RX_WAIT_STATE;

              end // PIO_RX_WAIT_STATE

              default :
              begin
                  // default case stmt
                  state        <= #TCQ PIO_RX_RST_STATE;
              end // default

          endcase

      end

  end
endmodule // PIO_RX_ENGINE

