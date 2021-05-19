`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 05:51:26 AM
// Design Name: 
// Module Name: mux_2i1o_1b
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


module mux_2i1o_1b(
    input sel_i,
    input  [0:0] in_0_i,
    input  [0:0] in_1_i,

    output [0:0] out
    );

    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_0(.O(out[0]),     // LUT general output
                .I0(in_0_i[0]), // LUT input
                .I1(in_1_i[0]), // LUT input
                .I2(sel_i)     // LUT input
          );

endmodule
