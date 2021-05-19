`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:10:16 09/11/2014 
// Design Name: 
// Module Name:    mux_16i1o_1b 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Mux_16I1O_1b_no_dly(
	din_0_i,
	din_1_i,
	din_2_i,
	din_3_i,	
	din_4_i,
	din_5_i,
	din_6_i,
	din_7_i,	 
	din_8_i,
	din_9_i,
	din_10_i,
	din_11_i,	
	din_12_i,
	din_13_i,
	din_14_i,
	din_15_i,	 	 

    sel_i,
	 
    dout_o
    );

	input  din_0_i;
	input  din_1_i;
	input  din_2_i;
	input  din_3_i;	
	input  din_4_i;
	input  din_5_i;
	input  din_6_i;
	input  din_7_i;	 
	input  din_8_i;
	input  din_9_i;
	input  din_10_i;
	input  din_11_i;	
	input  din_12_i;
	input  din_13_i;
	input  din_14_i;
	input  din_15_i;	 	 

    input  [3:0]  sel_i;
	 
    output dout_o;

    wire   lut6_out_0;
    wire   lut6_out_1;
    wire   lut6_out_2;
    wire   lut6_out_3;
	 
	wire   mux_out_0;
	wire   mux_out_1;
	wire   mux_out;
	 
   LUT6_2 #(
      .INIT(64'hff00f0f0ccccaaaa) // Specify LUT Contents
   ) LUT6_0_inst (
      .O6(lut6_out_0), // 1-bit LUT6 output
      .O5(), // 1-bit lower LUT5 output
      .I0(din_0_i), // 1-bit LUT input
      .I1(din_1_i), // 1-bit LUT input
      .I2(din_2_i), // 1-bit LUT input
      .I3(din_3_i), // 1-bit LUT input
      .I4(sel_i[0]), // 1-bit LUT input
      .I5(sel_i[1])  // 1-bit LUT input (fast MUX select only available to O6 output)
   );
   LUT6_2 #(
      .INIT(64'hff00f0f0ccccaaaa) // Specify LUT Contents
   ) LUT6_1_inst (
      .O6(lut6_out_1), // 1-bit LUT6 output
      .O5(), // 1-bit lower LUT5 output
      .I0(din_4_i), // 1-bit LUT input
      .I1(din_5_i), // 1-bit LUT input
      .I2(din_6_i), // 1-bit LUT input
      .I3(din_7_i), // 1-bit LUT input
      .I4(sel_i[0]), // 1-bit LUT input
      .I5(sel_i[1])  // 1-bit LUT input (fast MUX select only available to O6 output)
   );
   MUXF7_L MUXF7_0_inst (
      .LO(mux_out_0),  // Output of MUX to local routing
      .I0(lut6_out_0),  // Input (tie to LUT6 O6 pin)
      .I1(lut6_out_1),  // Input (tie to LUT6 O6 pin)
      .S(sel_i[2])     // Input select to MUX
   );	
   LUT6_2 #(
      .INIT(64'hff00f0f0ccccaaaa) // Specify LUT Contents
   ) LUT6_2_inst (
      .O6(lut6_out_2), // 1-bit LUT6 output
      .O5(), // 1-bit lower LUT5 output
      .I0(din_8_i), // 1-bit LUT input
      .I1(din_9_i), // 1-bit LUT input
      .I2(din_10_i), // 1-bit LUT input
      .I3(din_11_i), // 1-bit LUT input
      .I4(sel_i[0]), // 1-bit LUT input
      .I5(sel_i[1])  // 1-bit LUT input (fast MUX select only available to O6 output)
   );
   LUT6_2 #(
      .INIT(64'hff00f0f0ccccaaaa) // Specify LUT Contents
   ) LUT6_3_inst (
      .O6(lut6_out_3), // 1-bit LUT6 output
      .O5(), // 1-bit lower LUT5 output
      .I0(din_12_i), // 1-bit LUT input
      .I1(din_13_i), // 1-bit LUT input
      .I2(din_14_i), // 1-bit LUT input
      .I3(din_15_i), // 1-bit LUT input
      .I4(sel_i[0]), // 1-bit LUT input
      .I5(sel_i[1])  // 1-bit LUT input (fast MUX select only available to O6 output)
   );	
   MUXF7_L MUXF7_1_inst (
      .LO(mux_out_1),  // Output of MUX to local routing
      .I0(lut6_out_2),  // Input (tie to LUT6 O6 pin)
      .I1(lut6_out_3),  // Input (tie to LUT6 O6 pin)
      .S(sel_i[2])     // Input select to MUX
   );
   MUXF8 MUXF8_inst (
      .O(dout_o),    // Output of MUX to general routing
      .I0(mux_out_0),  // Input (tie to MUXF7 LO out)
      .I1(mux_out_1),  // Input (tie to MUXF7 LO out)
      .S(sel_i[3])     // Input select to MUX
   );	
	
endmodule
