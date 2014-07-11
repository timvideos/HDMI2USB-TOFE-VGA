// Copyright (c) 2008 by Xilinx, Inc. All rights reserved.
// This text/file contains proprietary, confidential
// information of Xilinx, Inc., is distributed under license
// from Xilinx, Inc., and may be used, copied and/or
// disclosed only pursuant to the terms of a valid license
// agreement with Xilinx, Inc. Xilinx hereby grants you a
// license to use this text/file solely for design, simulation,
// implementation and creation of design files limited
// to Xilinx devices or technologies. Use with non-Xilinx
// devices or technologies is expressly prohibited and
// immediately terminates your license unless covered by
// a separate agreement.
//
// Xilinx is providing this design, code, or information
// "as-is" solely for use in developing programs and
// solutions for Xilinx devices, with no obligation on the
// part of Xilinx to provide support. By providing this design,
// code, or information as one possible implementation of
// this feature, application or standard, Xilinx is making no
// representation that this implementation is free from any
// claims of infringement. You are responsible for
// obtaining any rights you may require for your implementation.
// Xilinx expressly disclaims any warranty whatsoever with
// respect to the adequacy of the implementation, including
// but not limited to any warranties or representations that this
// implementation is free from claims of infringement, implied
// warranties of merchantability or fitness for a particular
// purpose.
//
// Xilinx products are not intended for use in life support
// appliances, devices, or systems. Use in such applications is
// expressly prohibited.
//
// Any modifications that are made to the Source Code are
// done at the user's sole risk and will be unsupported.
//
// This copyright and support notice must be retained as part
// of this text at all times. (c) Copyright 2008 Xilinx, Inc.
// All rights reserved.
`timescale 	1ns / 1ns
//-------------------------------------
// YCrCb422_TP_GEN.v
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	9-12-2007 JAD: created
//-------------------------------------
// This module generates an 8-bit ITU-R BT.656 YCrCb 4:2:2 video stream
// The HS/Field combination corresponds to slave mode 1 on teh ADV7179.
//-------------------------------------
// Notes:
//  HS output is active low.
//-------------------------------------
// 
//-------------------------------------
module YCrCb422_TP_GEN(
	VID_CLK, ENABLE, 
	VIDOUT_CLK, VIDOUT_HS, VIDOUT_BLANK_L, VIDOUT_FIELD, VIDOUT_D
	);

// Pixel Clock (data comes in and out on this clock)
input			VID_CLK;

input			ENABLE;

// Output Video Stream 
output			VIDOUT_CLK;
output			VIDOUT_HS, VIDOUT_FIELD, VIDOUT_BLANK_L;
output	[7:0]	VIDOUT_D;

// Generate X,Y timers
reg 	[10:0]	X = 0;
always @(posedge VID_CLK) X <=#1 (X == 1715) ? 0 : X + 1; 
reg 	[9:0]	Y = 0;
always @(posedge VID_CLK) Y <=#1 (X == 1715) ? ((Y == 524) ? 0 : Y + 1) : Y; 

// generate timings
reg 			hs_l, field, blank_l;
reg 			field_prev, blank_l_prev;
always @(posedge VID_CLK) 
	begin
	hs_l <=#1 !(X == 1715);
	field <=#1 (X == 1715) && (Y == 2) ? 0 : (X == 1715) && (Y == 264) ? 1 : field;
	blank_l <=#1 ( ((Y > 19) && (Y < 263)) || (Y > 283) ) && // in Y active
		((X >= 243) && (X < 1683)); // in X active
	field_prev <=#1 field;
	blank_l_prev <=#1 blank_l;
	end

// Generate Test pattern
reg 	[9:0]	h_count, v_count;
always @(posedge VID_CLK)
	begin
	h_count <=#1 !blank_l ? 0 : h_count + 1;
	v_count <=#1 (field != field_prev) ? 0 : (blank_l_prev && !blank_l) ? v_count + 1 : v_count;
	end
wire	[7:0]	tp_Y = {v_count[6:0], v_count[0]};
wire	[7:0]	tp_Cr = !h_count[9] ? h_count[8:1] : 8'h00;
wire	[7:0]	tp_Cb =  h_count[9] ? h_count[8:1] : 8'h00;
wire	[7:0]	tp_d = !blank_l ? 0 : h_count[0] ? tp_Y : h_count[1] ? tp_Cr : tp_Cb;

// generate clock:
ODDR2 xclk_p_oddr (.C0(VID_CLK), .C1(!VID_CLK), .D0(1'b0), .D1(ENABLE), .CE(1'b1), .R(1'b0), .S(1'b0), .Q(VIDOUT_CLK) );
// output flip flops
reg 			VIDOUT_HS, VIDOUT_FIELD, VIDOUT_BLANK_L;
reg 	[7:0]	VIDOUT_D;
always @(posedge VID_CLK)
	begin
	VIDOUT_HS      <=#1 !ENABLE ? 0 : hs_l;
	VIDOUT_FIELD   <=#1 !ENABLE ? 0 : field;
	VIDOUT_BLANK_L <=#1 !ENABLE ? 0 : blank_l;
	VIDOUT_D       <=#1 !ENABLE ? 0 : tp_d;
	end


endmodule
