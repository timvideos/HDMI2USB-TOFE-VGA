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
// VGA_TP_TEST
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	11-29-2005 JAD: created
//-------------------------------------
// This module tests a recevied video stream. 
//  It expects it to match a specific test pattern.
//-------------------------------------
// 
//-------------------------------------
module VGA_TP_TEST(
	REF_CLK, ERROR_LIM, ERROR_PORTION,
	IN_CLK, IN_VS, IN_HS, IN_DE, IN_R, IN_G, IN_B,
	CLK_FAILED, R_FAILED, G_FAILED, B_FAILED,
	TEST_DATA_A, TEST_DATA_B, TEST_DATA_C
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
input			IN_VS, IN_HS; // active High
input			IN_DE;
input	[7:0]	IN_R, IN_G, IN_B;

// Results
output			CLK_FAILED, R_FAILED, G_FAILED, B_FAILED;

// test outputs
output	[7:0]	TEST_DATA_A, TEST_DATA_B, TEST_DATA_C;

//------- Test clock for propper frequency (and running) --------
wire			clk_ok;
wire			CLK_FAILED = ~clk_ok;
FREQ_COMPARE clktst(.TEST_CLK(IN_CLK), .REF_CLK(REF_CLK), .MATCH(clk_ok));

//------- Generate test pattern to compare against --------

// generate test pattern - count active pixels
reg 	[17:0]	tp_cnt;
always @(posedge IN_CLK) tp_cnt <=#1 IN_VS ? 0 : IN_DE ? tp_cnt + 1 : tp_cnt;

// test patterns
wire	[7:0]	tp_r = (tp_cnt[17:16] == 2'b00)||(tp_cnt[17:16] == 2'b11) ? tp_cnt[7:0] : 0;
wire	[7:0]	tp_g = (tp_cnt[17:16] == 2'b01)||(tp_cnt[17:16] == 2'b11) ? tp_cnt[7:0] : 0;
wire	[7:0]	tp_b = (tp_cnt[17:16] == 2'b10)||(tp_cnt[17:16] == 2'b11) ? tp_cnt[7:0] : 0;

//------- Compare test pattern against input --------

// first raw difference
wire	[8:0]	r_dif = !IN_DE ? 0 : IN_R - tp_r;
wire	[8:0]	g_dif = !IN_DE ? 0 : IN_G - tp_g;
wire	[8:0]	b_dif = !IN_DE ? 0 : IN_B - tp_b;

// next is absolute difference and sign
reg 	[7:0]	r_mag, g_mag, b_mag;
always @(posedge IN_CLK)
	begin
	r_mag <=#1 r_dif[8] ? ~r_dif[7:0] + 1 : r_dif[7:0];
	g_mag <=#1 g_dif[8] ? ~g_dif[7:0] + 1 : g_dif[7:0];
	b_mag <=#1 b_dif[8] ? ~b_dif[7:0] + 1 : b_dif[7:0];
	end

//------- Flag error outside of bounds --------
reg 			r_error, g_error, b_error;
always @(posedge IN_CLK)
	begin
	r_error <=#1 r_mag > error_range;
	g_error <=#1 g_mag > error_range;
	b_error <=#1 b_mag > error_range;
	end

// Now count errors and pixels and cycles
reg 			vs_prev;
always @(posedge IN_CLK) vs_prev <=#1 IN_VS;
wire			new_frame = IN_VS && !vs_prev;
reg 	[18:0]	pix_cnt, cyc_cnt, r_err_cnt, g_err_cnt, b_err_cnt;
always @(posedge IN_CLK)
	begin
	cyc_cnt   <=#1 new_frame ? 0 : (cyc_cnt[18:15] == 4'b1111) ? cyc_cnt : cyc_cnt + 1;
	pix_cnt   <=#1 new_frame ? 0 : IN_DE ? pix_cnt + 1 : pix_cnt;
	r_err_cnt <=#1 new_frame ? 0 : r_error ? r_err_cnt + 1 : r_err_cnt;
	g_err_cnt <=#1 new_frame ? 0 : g_error ? g_err_cnt + 1 : g_err_cnt;
	b_err_cnt <=#1 new_frame ? 0 : b_error ? b_err_cnt + 1 : b_err_cnt;
	end

// Generate Failed Flags
wire			r_err_exceed_max = (r_err_cnt > err_cnt_lim); // Exceeds max?
wire			g_err_exceed_max = (g_err_cnt > err_cnt_lim); 
wire			b_err_exceed_max = (b_err_cnt > err_cnt_lim); 
wire			wrong_num_pix = (pix_cnt != 19'd307200); //640x480
wire			low_frame_rate = (cyc_cnt[18:15] == 4'b1111);
reg				R_FAILED, G_FAILED, B_FAILED;
always @(posedge IN_CLK or posedge CLK_FAILED) 
	if (CLK_FAILED)
		begin
		R_FAILED <=#1 1;
		G_FAILED <=#1 1;
		B_FAILED <=#1 1;
		end
	else if (low_frame_rate)
		begin
		R_FAILED <=#1 1;
		G_FAILED <=#1 1;
		B_FAILED <=#1 1;
		end
	else if (new_frame)
		begin
		R_FAILED <=#1 wrong_num_pix || r_err_exceed_max;
		G_FAILED <=#1 wrong_num_pix || g_err_exceed_max;
		B_FAILED <=#1 wrong_num_pix || b_err_exceed_max;
		end

// test output
wire	[7:0]	TEST_DATA_A = b_mag;
wire	[7:0]	TEST_DATA_B = b_error ? 8'hFF : 8'h00;
wire	[7:0]	TEST_DATA_C = b_err_cnt >= err_cnt_lim ? 8'hFF : 8'h00;


endmodule
