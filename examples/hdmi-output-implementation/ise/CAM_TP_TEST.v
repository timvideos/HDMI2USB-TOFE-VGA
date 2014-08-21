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
// CAM_TP_TEST
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	9-29-2007 JAD: created, tested quite thoroughly.
//-------------------------------------
// This module tests a test pattern from a MT9V022 
// camera to see if it is correct.
//-------------------------------------
// 
//-------------------------------------
module CAM_TP_TEST(
	REF_CLK, ERROR_LIM, ERROR_PORTION,
	IN_CLK, IN_FRAME, IN_LINE, IN_D,
	CLK_FAILED, D_FAILED
	);

// reference clock
input			REF_CLK;

// Error controls
input	[7:0]	ERROR_LIM; // error allowed in input before counting as error (out of 256)
wire	[7:0]	error_range = ERROR_LIM;
input	[7:0]	ERROR_PORTION; // x1024 total samples that can be error befor failing (out of ~300,000)
wire	[18:0]	err_cnt_lim = {1'b0, ERROR_PORTION[7:0], 10'd0};

// video input
input			IN_CLK;
input			IN_FRAME, IN_LINE; // active High
input	[7:0]	IN_D;

// Results
output			CLK_FAILED, D_FAILED;

//Test clock for propper frequency (and running)
wire			clk_ok;
wire			CLK_FAILED = ~clk_ok;
FREQ_COMPARE #(.PERCENT_TOLERANCE(4)) // DS92V1212A requires freq within 5% of reference
	clktst(.TEST_CLK(IN_CLK), .REF_CLK(REF_CLK), .MATCH(clk_ok));

// input flip flops
reg 			line_inff = 0, frame_inff;
reg 	[7:0]	d_inff;
always @(posedge IN_CLK)
	begin
	line_inff <=#1 IN_LINE;
	frame_inff <=#1 IN_FRAME;
	d_inff <=#1 IN_D;
	end

// generate test pattern
reg 	[9:0]	col_cnt;
always @(posedge IN_CLK) col_cnt <=#1 !line_inff ? 0 : col_cnt + 1;
// Note: Test pattern is not documented in datasheet, 
// I captured it with the logic analyzer, and this is it:
wire	[7:0]	tp = (col_cnt == 0) ? 8'hC2 : (col_cnt[9:4] == 0) ? 8'h04 : col_cnt[9:2];

// Compare test pattern against input
wire	[8:0]	dif = !(line_inff && frame_inff) ? 0 : d_inff - tp;
reg 	[7:0]	mag;
always @(posedge IN_CLK) mag <=#1 dif[8] ? ~dif[7:0] + 1 : dif[7:0];
reg 			error;
always @(posedge IN_CLK) error <=#1 mag > error_range;

// Now count errors and pixels and cycles
reg 			frame_prev;
always @(posedge IN_CLK) frame_prev <=#1 frame_inff;
wire			new_frame = frame_inff && ~frame_prev;
reg 	[18:0]	err_cnt, pix_cnt, cyc_cnt;
always @(posedge IN_CLK) 
	begin
	cyc_cnt <=#1 new_frame ? 0 : (cyc_cnt[18:15] == 4'b1111) ? cyc_cnt : cyc_cnt + 1;
	pix_cnt <=#1 new_frame ? 0 : (line_inff && frame_inff) ? pix_cnt + 1 : pix_cnt;
	err_cnt <=#1 new_frame ? 0 : error ? err_cnt + 1 : err_cnt;
	end

// Generate Failed Flag
wire			err_exceed_max = (err_cnt > err_cnt_lim); // Exceeds max?
wire			wrong_num_pix = (pix_cnt != 19'd360960);
wire			low_frame_rate = (cyc_cnt[18:15] == 4'b1111);
reg				D_FAILED;
always @(posedge IN_CLK or posedge CLK_FAILED) 
	if (CLK_FAILED)
		D_FAILED <=#1 1;
	else if (low_frame_rate)
		D_FAILED <=#1 1;
	else if (new_frame)
		D_FAILED <=#1 wrong_num_pix || err_exceed_max;

endmodule
