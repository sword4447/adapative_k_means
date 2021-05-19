`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 05:50:57 AM
// Design Name: 
// Module Name: mux_2i1o_28b
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


module mux_2i1o_28b(
    input sel_i,
    input  [27:0] in_0_i,
    input  [27:0] in_1_i,

    output [27:0] out
    );

    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_27(.O(out[27]),     // LUT general output
                .I0(in_0_i[27]), // LUT input
                .I1(in_1_i[27]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_26(.O(out[26]),     // LUT general output
                .I0(in_0_i[26]), // LUT input
                .I1(in_1_i[26]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_25(.O(out[25]),     // LUT general output
                .I0(in_0_i[25]), // LUT input
                .I1(in_1_i[25]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_24(.O(out[24]),     // LUT general output
                .I0(in_0_i[24]), // LUT input
                .I1(in_1_i[24]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_23(.O(out[23]),     // LUT general output
                .I0(in_0_i[23]), // LUT input
                .I1(in_1_i[23]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_22(.O(out[22]),     // LUT general output
                .I0(in_0_i[22]), // LUT input
                .I1(in_1_i[22]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_21(.O(out[21]),     // LUT general output
                .I0(in_0_i[21]), // LUT input
                .I1(in_1_i[21]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_20(.O(out[20]),     // LUT general output
                .I0(in_0_i[20]), // LUT input
                .I1(in_1_i[20]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_19(.O(out[19]),     // LUT general output
                .I0(in_0_i[19]), // LUT input
                .I1(in_1_i[19]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_18(.O(out[18]),     // LUT general output
                .I0(in_0_i[18]), // LUT input
                .I1(in_1_i[18]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_17(.O(out[17]),     // LUT general output
                .I0(in_0_i[17]), // LUT input
                .I1(in_1_i[17]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_16(.O(out[16]),     // LUT general output
                .I0(in_0_i[16]), // LUT input
                .I1(in_1_i[16]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_15(.O(out[15]),     // LUT general output
                .I0(in_0_i[15]), // LUT input
                .I1(in_1_i[15]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_14(.O(out[14]),     // LUT general output
                .I0(in_0_i[14]), // LUT input
                .I1(in_1_i[14]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_13(.O(out[13]),     // LUT general output
                .I0(in_0_i[13]), // LUT input
                .I1(in_1_i[13]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_12(.O(out[12]),     // LUT general output
                .I0(in_0_i[12]), // LUT input
                .I1(in_1_i[12]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_11(.O(out[11]),     // LUT general output
                .I0(in_0_i[11]), // LUT input
                .I1(in_1_i[11]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_10(.O(out[10]),     // LUT general output
                .I0(in_0_i[10]), // LUT input
                .I1(in_1_i[10]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_9(.O(out[9]),     // LUT general output
                .I0(in_0_i[9]), // LUT input
                .I1(in_1_i[9]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_8(.O(out[8]),     // LUT general output
                .I0(in_0_i[8]), // LUT input
                .I1(in_1_i[8]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_7(.O(out[7]),     // LUT general output
                .I0(in_0_i[7]), // LUT input
                .I1(in_1_i[7]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_6(.O(out[6]),     // LUT general output
                .I0(in_0_i[6]), // LUT input
                .I1(in_1_i[6]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_5(.O(out[5]),     // LUT general output
                .I0(in_0_i[5]), // LUT input
                .I1(in_1_i[5]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_4(.O(out[4]),     // LUT general output
                .I0(in_0_i[4]), // LUT input
                .I1(in_1_i[4]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_3(.O(out[3]),     // LUT general output
                .I0(in_0_i[3]), // LUT input
                .I1(in_1_i[3]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_2(.O(out[2]),     // LUT general output
                .I0(in_0_i[2]), // LUT input
                .I1(in_1_i[2]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_1(.O(out[1]),     // LUT general output
                .I0(in_0_i[1]), // LUT input
                .I1(in_1_i[1]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_0(.O(out[0]),     // LUT general output
                .I0(in_0_i[0]), // LUT input
                .I1(in_1_i[0]), // LUT input
                .I2(sel_i)     // LUT input
          );

endmodule
