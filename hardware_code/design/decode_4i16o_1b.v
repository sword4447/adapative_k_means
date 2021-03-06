`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2021 10:16:34 AM
// Design Name: 
// Module Name: decode_4i16o_1b
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


module decode_4i16o_1b(
    input [3:0]a_i,
    output [15:0]a_o
    );
    LUT4 #(
        .INIT(16'b0000_0000_0000_0001)
    ) _lut_0(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[0])
    );
    LUT4 #(
        .INIT(16'b0000_0000_0000_0010)
    ) _lut_1(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[1])
    );
    LUT4 #(
        .INIT(16'b0000_0000_0000_0100)
    ) _lut_2(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[2])
    );
    LUT4 #(
        .INIT(16'b0000_0000_0000_1000)
    ) _lut_3(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[3])
    );
    LUT4 #(
        .INIT(16'b0000_0000_0001_0000)
    ) _lut_4(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[4])
    );
    LUT4 #(
        .INIT(16'b0000_0000_0010_0000)
    ) _lut_5(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[5])
    );
    LUT4 #(
        .INIT(16'b0000_0000_0100_0000)
    ) _lut_6(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[6])
    );
    LUT4 #(
        .INIT(16'b0000_0000_1000_0000)
    ) _lut_7(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[7])
    );
    LUT4 #(
        .INIT(16'b0000_0001_0000_0000)
    ) _lut_8(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[8])
    );
    LUT4 #(
        .INIT(16'b0000_0010_0000_0000)
    ) _lut_9(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[9])
    );
    LUT4 #(
        .INIT(16'b0000_0100_0000_0000)
    ) _lut_10(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[10])
    );
    LUT4 #(
        .INIT(16'b0000_1000_0000_0000)
    ) _lut_11(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[11])
    );
    LUT4 #(
        .INIT(16'b0001_0000_0000_0000)
    ) _lut_12(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[12])
    );
    LUT4 #(
        .INIT(16'b0010_0000_0000_0000)
    ) _lut_13(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[13])
    );
    LUT4 #(
        .INIT(16'b0100_0000_0000_0000)
    ) _lut_14(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[14])
    );
    LUT4 #(
        .INIT(16'b1000_0000_0000_0000)
    ) _lut_15(
        .I0(a_i[0]),
        .I1(a_i[1]),
        .I2(a_i[2]),
        .I3(a_i[3]),

        .O(a_o[15])
    );
endmodule
