`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2021 11:54:08 PM
// Design Name: 
// Module Name: Mux_16I1O_1b
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


module Mux_16I1O_1b(
    clk_i,
	rst_i,
	ce_i,

	in_0_i,
	in_1_i,
	in_2_i,
	in_3_i,	
	in_4_i,
	in_5_i,
	in_6_i,
	in_7_i,	 
	in_8_i,
	in_9_i,
	in_10_i,
	in_11_i,	
	in_12_i,
	in_13_i,
	in_14_i,
	in_15_i,	 	 

    sel_i,
	 
    out_o
    );

    input  clk_i;
	input  rst_i;
	input  ce_i;

	input  in_0_i;
	input  in_1_i;
	input  in_2_i;
	input  in_3_i;	
	input  in_4_i;
	input  in_5_i;
	input  in_6_i;
	input  in_7_i;	 
	input  in_8_i;
	input  in_9_i;
	input  in_10_i;
	input  in_11_i;	
	input  in_12_i;
	input  in_13_i;
	input  in_14_i;
	input  in_15_i;	 	 

    input  [3:0]  sel_i;
	 
    output out_o;

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
      .I0(in_0_i), // 1-bit LUT input
      .I1(in_1_i), // 1-bit LUT input
      .I2(in_2_i), // 1-bit LUT input
      .I3(in_3_i), // 1-bit LUT input
      .I4(sel_i[0]), // 1-bit LUT input
      .I5(sel_i[1])  // 1-bit LUT input (fast MUX select only available to O6 output)
   );
   LUT6_2 #(
      .INIT(64'hff00f0f0ccccaaaa) // Specify LUT Contents
   ) LUT6_1_inst (
      .O6(lut6_out_1), // 1-bit LUT6 output
      .O5(), // 1-bit lower LUT5 output
      .I0(in_4_i), // 1-bit LUT input
      .I1(in_5_i), // 1-bit LUT input
      .I2(in_6_i), // 1-bit LUT input
      .I3(in_7_i), // 1-bit LUT input
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
      .I0(in_8_i), // 1-bit LUT input
      .I1(in_9_i), // 1-bit LUT input
      .I2(in_10_i), // 1-bit LUT input
      .I3(in_11_i), // 1-bit LUT input
      .I4(sel_i[0]), // 1-bit LUT input
      .I5(sel_i[1])  // 1-bit LUT input (fast MUX select only available to O6 output)
   );
   LUT6_2 #(
      .INIT(64'hff00f0f0ccccaaaa) // Specify LUT Contents
   ) LUT6_3_inst (
      .O6(lut6_out_3), // 1-bit LUT6 output
      .O5(), // 1-bit lower LUT5 output
      .I0(in_12_i), // 1-bit LUT input
      .I1(in_13_i), // 1-bit LUT input
      .I2(in_14_i), // 1-bit LUT input
      .I3(in_15_i), // 1-bit LUT input
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
      .O(mux_out),    // Output of MUX to general routing
      .I0(mux_out_0),  // Input (tie to MUXF7 LO out)
      .I1(mux_out_1),  // Input (tie to MUXF7 LO out)
      .S(sel_i[3])     // Input select to MUX
   );	
	
   FDCE #(
      .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
   ) FDCE_inst (
      .Q(out_o),      // 1-bit Data output
      .C(clk_i),      // 1-bit Clock input
      .CE(ce_i),    // 1-bit Clock enable input
      .CLR(rst_i),  // 1-bit Asynchronous clear input
      .D(mux_out)       // 1-bit Data input
   );
	
endmodule
