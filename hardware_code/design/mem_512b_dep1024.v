`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2021 06:49:46 PM
// Design Name: 
// Module Name: mem_512b_dep1024
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


module mem_512b_dep1024 (
    input  clk,
    input rst,
    
    input [9:0]  addr,

    input cmd_en,

    input cmd, //0read,1write
    input[511:0] wr_data,
    output [511:0] rd_data,

    output reg rd_data_valid
);
    reg cmd_en_r;
    always @(posedge clk)
        cmd_en_r <= cmd_en;
    reg rd_valid_first;
    always @(posedge clk)
        rd_valid_first <= (!cmd & cmd_en); //采集读信号有效
    always @(posedge clk) begin
        rd_data_valid <= rd_valid_first;        
    end

    blk_mem_512b_dep1024 blk_mem_512b_dep1024_0(
        .clka(clk),
        .rsta(rst),

        .ena (cmd_en | cmd_en_r), //因为读有延迟所以至少要延迟两拍
        .wea(cmd),   //write enable
        .dina(wr_data),  //i_511:0

        .addra(addr), //i_9:0
        .douta(rd_data) //o_511:0
    );
endmodule
