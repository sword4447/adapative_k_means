`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2021 09:11:07 PM
// Design Name: 
// Module Name: blcok_mem_ddr_tb
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


module blcok_mem_ddr_tb();

    localparam period = 10;

    reg  clk;
    wire  app_wdf_rdy;
    wire  app_rdy;
    reg [27:0] app_addr;
    reg [2:0] app_cmd;
    reg  app_en;
    reg [511:0] app_wdf_data;
    reg [63:0] app_wdf_mask;
    reg  app_wdf_wren;
    reg  app_wdf_end;
    wire [511:0] app_rd_data;
    wire  app_rd_data_end;
    wire  app_rd_data_valid;

    blcok_mem_ddr blcok_mem_ddr_1(
        . clk(clk),
        . app_wdf_rdy(app_wdf_rdy),
        . app_rdy(app_rdy),
        . app_addr(app_addr),
        . app_cmd(app_cmd),
        . app_en(app_en),
        . app_wdf_data(app_wdf_data),
        . app_wdf_mask(app_wdf_mask),
        . app_wdf_wren(app_wdf_wren),
        . app_wdf_end(app_wdf_end),
        . app_rd_data(app_rd_data),
        . app_rd_data_end(app_rd_data_end),
        . app_rd_data_valid(app_rd_data_valid)
    );

    initial begin
        clk = 1'b0;
        app_cmd = 3'd0;
        app_en = 1'b0;
        app_wdf_data = 512'd0;
        app_wdf_mask = 64'd0;
        app_wdf_wren = 1'b0;
        app_wdf_end = 1'b0;


        #(period * 10)
            app_wdf_data = 512'd1234;
            app_addr = 28'b1000;
            app_wdf_wren = 1'b1;
            app_cmd = 3'd1;
            app_en = 1'b1;

        #(period)
            app_wdf_data = 512'd9999;
            app_addr = 28'b100000;
            app_wdf_wren = 1'b1;
            app_cmd = 3'd1;
            app_en = 1'b1;
        #(period)
            app_wdf_data = 512'd7854;
            app_addr = 28'b10000;
            app_wdf_wren = 1'b1;
            app_cmd = 3'd1;
            app_en = 1'b1;

        #(period)
            app_wdf_wren = 1'b0;
            app_en =1'b0;
        
        #(period *10)
             app_en = 1'b1;
            app_cmd = 3'd0;
            app_addr = 28'b1000;
            app_en = 1'b1;
        #(period)
            app_en = 1'b0;

        #(period *5)
            app_en = 1'b1;
            app_cmd = 3'd0;
            app_addr = 28'b10000;
            app_en = 1'b1;
       #(period)
            app_en = 1'b0;
    end

    always #(period / 2) clk = ~clk;

endmodule
