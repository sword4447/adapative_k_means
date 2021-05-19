`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 05:51:58 AM
// Design Name: 
// Module Name: mux_2i1o_64b
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


module mux_2i1o_64b(
    input sel_i,
    input  [63:0] in_0_i,
    input  [63:0] in_1_i,

    output [63:0] out
    );

    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_63(.O(out[63]),     // LUT general output
                .I0(in_0_i[63]), // LUT input
                .I1(in_1_i[63]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_62(.O(out[62]),     // LUT general output
                .I0(in_0_i[62]), // LUT input
                .I1(in_1_i[62]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_61(.O(out[61]),     // LUT general output
                .I0(in_0_i[61]), // LUT input
                .I1(in_1_i[61]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_60(.O(out[60]),     // LUT general output
                .I0(in_0_i[60]), // LUT input
                .I1(in_1_i[60]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_59(.O(out[59]),     // LUT general output
                .I0(in_0_i[59]), // LUT input
                .I1(in_1_i[59]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_58(.O(out[58]),     // LUT general output
                .I0(in_0_i[58]), // LUT input
                .I1(in_1_i[58]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_57(.O(out[57]),     // LUT general output
                .I0(in_0_i[57]), // LUT input
                .I1(in_1_i[57]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_56(.O(out[56]),     // LUT general output
                .I0(in_0_i[56]), // LUT input
                .I1(in_1_i[56]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_55(.O(out[55]),     // LUT general output
                .I0(in_0_i[55]), // LUT input
                .I1(in_1_i[55]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_54(.O(out[54]),     // LUT general output
                .I0(in_0_i[54]), // LUT input
                .I1(in_1_i[54]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_53(.O(out[53]),     // LUT general output
                .I0(in_0_i[53]), // LUT input
                .I1(in_1_i[53]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_52(.O(out[52]),     // LUT general output
                .I0(in_0_i[52]), // LUT input
                .I1(in_1_i[52]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_51(.O(out[51]),     // LUT general output
                .I0(in_0_i[51]), // LUT input
                .I1(in_1_i[51]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_50(.O(out[50]),     // LUT general output
                .I0(in_0_i[50]), // LUT input
                .I1(in_1_i[50]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_49(.O(out[49]),     // LUT general output
                .I0(in_0_i[49]), // LUT input
                .I1(in_1_i[49]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_48(.O(out[48]),     // LUT general output
                .I0(in_0_i[48]), // LUT input
                .I1(in_1_i[48]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_47(.O(out[47]),     // LUT general output
                .I0(in_0_i[47]), // LUT input
                .I1(in_1_i[47]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_46(.O(out[46]),     // LUT general output
                .I0(in_0_i[46]), // LUT input
                .I1(in_1_i[46]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_45(.O(out[45]),     // LUT general output
                .I0(in_0_i[45]), // LUT input
                .I1(in_1_i[45]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_44(.O(out[44]),     // LUT general output
                .I0(in_0_i[44]), // LUT input
                .I1(in_1_i[44]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_43(.O(out[43]),     // LUT general output
                .I0(in_0_i[43]), // LUT input
                .I1(in_1_i[43]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_42(.O(out[42]),     // LUT general output
                .I0(in_0_i[42]), // LUT input
                .I1(in_1_i[42]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_41(.O(out[41]),     // LUT general output
                .I0(in_0_i[41]), // LUT input
                .I1(in_1_i[41]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_40(.O(out[40]),     // LUT general output
                .I0(in_0_i[40]), // LUT input
                .I1(in_1_i[40]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_39(.O(out[39]),     // LUT general output
                .I0(in_0_i[39]), // LUT input
                .I1(in_1_i[39]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_38(.O(out[38]),     // LUT general output
                .I0(in_0_i[38]), // LUT input
                .I1(in_1_i[38]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_37(.O(out[37]),     // LUT general output
                .I0(in_0_i[37]), // LUT input
                .I1(in_1_i[37]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_36(.O(out[36]),     // LUT general output
                .I0(in_0_i[36]), // LUT input
                .I1(in_1_i[36]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_35(.O(out[35]),     // LUT general output
                .I0(in_0_i[35]), // LUT input
                .I1(in_1_i[35]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_34(.O(out[34]),     // LUT general output
                .I0(in_0_i[34]), // LUT input
                .I1(in_1_i[34]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_33(.O(out[33]),     // LUT general output
                .I0(in_0_i[33]), // LUT input
                .I1(in_1_i[33]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_32(.O(out[32]),     // LUT general output
                .I0(in_0_i[32]), // LUT input
                .I1(in_1_i[32]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_31(.O(out[31]),     // LUT general output
                .I0(in_0_i[31]), // LUT input
                .I1(in_1_i[31]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_30(.O(out[30]),     // LUT general output
                .I0(in_0_i[30]), // LUT input
                .I1(in_1_i[30]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_29(.O(out[29]),     // LUT general output
                .I0(in_0_i[29]), // LUT input
                .I1(in_1_i[29]), // LUT input
                .I2(sel_i)     // LUT input
          );
    LUT3 #(
                .INIT(8'hca)         // Specify LUT Contents
            )mux_28(.O(out[28]),     // LUT general output
                .I0(in_0_i[28]), // LUT input
                .I1(in_1_i[28]), // LUT input
                .I2(sel_i)     // LUT input
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
