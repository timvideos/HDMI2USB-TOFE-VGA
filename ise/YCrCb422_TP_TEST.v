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
// YCrCb422_TP_TEST
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	9-13-2007 JAD: created
//-------------------------------------
// This module tests a recevied video stream. 
//  It expects it to match a specific test pattern.
//-------------------------------------
// Note: Timings are designed to match ADV7180 defaults
//-------------------------------------
module YCrCb422_TP_TEST(
	REF_CLK, ERROR_LIM, ERROR_PORTION,
	IN_CLK, IN_HS, IN_FIELD, IN_D, 
	CLK_FAILED, D_FAILED,
	TP_VS, TP_HS, TP_DE, TP_R, TP_G, TP_B
	);

// reference clock
input			REF_CLK;

// Error controls
input	[7:0]	ERROR_LIM; // x4 error allowed in input before counting as error (out of 1024)
input	[7:0]	ERROR_PORTION; // x4096 total samples that can be error befor failing (out of ~700,000)
wire	[19:0]	err_cnt_lim = {ERROR_PORTION[7:0], 12'd0};

// video input
input			IN_CLK;
input			IN_HS, IN_FIELD;
input	[7:0]	IN_D;

// Results
output			CLK_FAILED, D_FAILED;

// Test output
output			TP_VS, TP_HS, TP_DE;
output	[7:0]	TP_R, TP_G, TP_B;

//------- Test clock for propper frequency (and running) --------
wire			clk_ok;
wire			CLK_FAILED = ~clk_ok;
FREQ_COMPARE sdclktst(
	.TEST_CLK(IN_CLK), .REF_CLK(REF_CLK), .MATCH(clk_ok)
	);

// input flip flops
reg 			hs_inff = 0, field_inff;
reg 	[7:0]	d_inff;
reg 			hs_prev, field_prev;
always @(posedge IN_CLK)
	begin
	hs_inff <=#1 IN_HS;
	field_inff <=#1 IN_FIELD;
	d_inff <=#1 IN_D;
	hs_prev <=#1 hs_inff;
	field_prev <=#1 field_inff;
	end


//------- Generate test pattern to compare against --------
// Generate X,Y timers
reg 	[10:0]	X = 0;
always @(posedge IN_CLK) X <=#1 !hs_inff && hs_prev ? 1 : X + 1; 
reg 	[9:0]	Y = 0;
always @(posedge IN_CLK) Y <=#1 (field_prev && !field_inff) ? 3 : (!field_prev && field_inff) ? 265 : !hs_inff  && hs_prev ? Y+1 : Y;

// generate blanking signal
reg 			blank_l, blank_l_prev;
always @(posedge IN_CLK) 
	begin
	blank_l <=#1 ( ((Y > 19) && (Y < 262)) || ((Y > 283) && (Y <= 524)) ) && // in Y active
		((X >= 271) && (X < 1711)); // in X active
	blank_l_prev <=#1 blank_l;
	end

// Generate Test pattern
reg 	[9:0]	h_count, v_count;
always @(posedge IN_CLK)
	begin
	h_count <=#1 !blank_l ? 0 : h_count + 1;
	v_count <=#1 (field_inff != field_prev) ? 0 : (blank_l_prev && !blank_l) ? v_count + 1 : v_count;
	end
wire	[7:0]	tp_Y = {v_count[6:0], v_count[0]};
wire	[7:0]	tp_Cr = !h_count[9] ? h_count[8:1] : 8'h00;
wire	[7:0]	tp_Cb =  h_count[9] ? h_count[8:1] : 8'h00;
wire	[7:0]	tp_d = !blank_l ? 0 : h_count[0] ? tp_Y : h_count[1] ? tp_Cr : tp_Cb;

// Compare test pattern against input
wire	[8:0]	dif = !blank_l ? 0 : d_inff - tp_d;
reg 	[7:0]	mag;
always @(posedge IN_CLK) mag <=#1 dif[8] ? ~dif[7:0] + 1 : dif[7:0];
reg 			error;
always @(posedge IN_CLK) error <=#1 mag > ERROR_LIM;

// Now count errors and pixels and cycles
wire			new_frame = field_inff && !field_prev;
reg 	[19:0]	err_cnt, pix_cnt, cyc_cnt;
always @(posedge IN_CLK) 
	begin
	cyc_cnt <=#1 new_frame ? 0 : (cyc_cnt[19:15] == 5'b11111) ? cyc_cnt : cyc_cnt + 1;
	pix_cnt <=#1 new_frame ? 0 : blank_l ? pix_cnt + 1 : pix_cnt;
	err_cnt <=#1 new_frame ? 0 : error ? err_cnt + 1 : err_cnt;
	end

// Generate Failed Flag
wire			err_exceed_max = (err_cnt > err_cnt_lim); // Exceeds max?
wire			wrong_num_pix = (pix_cnt != 20'd695520); 
wire			low_frame_rate = (cyc_cnt[19:15] == 5'b11111);
reg				D_FAILED;
always @(posedge IN_CLK or posedge CLK_FAILED) 
	if (CLK_FAILED)
		D_FAILED <=#1 1;
	else if (low_frame_rate)
		D_FAILED <=#1 1;
	else if (new_frame)
		D_FAILED <=#1 wrong_num_pix || err_exceed_max;

// Test output
reg 			TP_VS, TP_HS, TP_DE;
reg 	[7:0]	TP_R, TP_G, TP_B;
always @(posedge IN_CLK)
	begin
	TP_HS <=#1 hs_inff;
	TP_VS <=#1 (field_inff != field_prev) ? 1'b1 : !hs_inff ? 0 : TP_VS;
//	TP_VS <=#1 (!field_inff && field_prev) ? 1'b1 : !hs_inff ? 0 : TP_VS;
	TP_DE <=#1 blank_l;
//	TP_DE <=#1 blank_l && !field_inff;
//	TP_R  <=#1 !blank_l ? 8'h00 : h_count[1:0] == 2'b10 ? d_inff : TP_R;
//	TP_G  <=#1 !blank_l ? 8'h00 : h_count[0]   ==  1'b1 ? d_inff : TP_G;
//	TP_B  <=#1 !blank_l ? 8'h00 : h_count[1:0] == 2'b00 ? d_inff : TP_B;
	TP_R  <=#1 !blank_l ? 8'h00 : error ? 8'hFF : 8'h00;
	TP_G  <=#1 !blank_l ? 8'h00 : d_inff;
	TP_B  <=#1 !blank_l ? 8'h00 : 0;
	end

endmodule
