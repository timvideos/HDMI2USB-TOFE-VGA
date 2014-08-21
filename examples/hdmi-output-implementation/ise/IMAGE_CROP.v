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
// IMAGE_CROP
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	06-06-2002 JAD: created
//	02-09-2005 CJL: re-wrote most of the code 
//	08-18-2005 JAD: re-wrote most of the code, again...
//  10-25-2005 JAD: general clean-up.  Added Enable.
//  11-1-2005 JAD: widened data path to 60 bits for different data forms.
//-------------------------------------
// crops a video input stream
//-------------------------------------
// Note: 
// 		1st pixel in line is considered pixel#1
//		1st line is considered line #1 (in simulation hsync followed Vsync so line 1 considered 1st good line)
//-------------------------------------
module IMAGE_CROP(
	CLK,
	DATA_IN, DE_IN, VSYNC_POS_IN, HSYNC_POS_IN,
	CROP_EN, CROP_START_X, CROP_START_Y, CROP_WIDTH, CROP_HEIGHT,
	DATA_OUT, DE_OUT, VSYNC_OUT, HSYNC_OUT
	);

// Master clock input
input			CLK;

// Video input port
input	[59:0]	DATA_IN;
input			DE_IN;
input			VSYNC_POS_IN; 
input			HSYNC_POS_IN; 

// cropping control
input			CROP_EN;
input	[15:0]	CROP_START_X;
input	[15:0]	CROP_START_Y; 
input	[15:0]	CROP_WIDTH; 
input	[15:0]	CROP_HEIGHT;

// video output
output	[59:0]	DATA_OUT;
output			DE_OUT;
output			VSYNC_OUT; 
output			HSYNC_OUT; 

// single cycle strobe on falling edge of HS and VS (end of sync)
reg				vs_pos_prev, hs_pos_prev;
reg 			vs_strobe, hs_strobe; 
always @(posedge CLK)
	begin
	vs_pos_prev <=#1 VSYNC_POS_IN;
	hs_pos_prev <=#1 HSYNC_POS_IN;
	vs_strobe <=#1 ~VSYNC_POS_IN && vs_pos_prev;
	hs_strobe <=#1 ~HSYNC_POS_IN && hs_pos_prev;
	end

// run counters and comparators for crop
reg				in_x,in_y;
reg				sp_match,ep_match,sl_match,el_match;
reg		[15:0]	line_cnt,pix_cnt;
reg		[15:0]	end_x,end_y;
always @(posedge CLK) 
	begin
	pix_cnt  <=#1  hs_strobe ? 0 : DE_IN     ? pix_cnt+1  : pix_cnt;
	line_cnt  <=#1 VSYNC_POS_IN ? 0 : hs_strobe ? line_cnt+1 : line_cnt;
	end_x <=#1 CROP_START_X+CROP_WIDTH; // calc end pixel (false path)
	end_y <=#1 CROP_START_Y+CROP_HEIGHT; // calc end line
	sp_match <=#1 pix_cnt==CROP_START_X; // high when current pixel = start pixel
	ep_match <=#1 pix_cnt==end_x; // high when current pixel = end pixel
	sl_match <=#1 line_cnt==CROP_START_Y; // high when current line = start line
	el_match <=#1 line_cnt==end_y; // high when current line = end line
	in_x <=#1 (hs_strobe||ep_match)? 1'b0 : (sp_match)? 1'b1 : in_x;
	in_y <=#1 (vs_strobe||el_match)? 1'b0 : (sl_match)? 1'b1 : in_y;		
	end	


// delay data and strobe to match comparators
parameter [3:0]	data_delay = 4'd1;
wire				delayed_vs_out, delayed_hs_out, delayed_de_out;
wire	[59:0]		delayed_dat_out;
SRL16E srlhs (.CLK(CLK), .D(VSYNC_POS_IN),    .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_vs_out)  );
SRL16E srlvs (.CLK(CLK), .D(HSYNC_POS_IN),    .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_hs_out)  );
SRL16E srlde (.CLK(CLK), .D(DE_IN),       .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_de_out)  );
SRL16E srl0  (.CLK(CLK), .D(DATA_IN[0]),  .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[0])  );
SRL16E srl1  (.CLK(CLK), .D(DATA_IN[1]),  .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[1])  );
SRL16E srl2  (.CLK(CLK), .D(DATA_IN[2]),  .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[2])  );
SRL16E srl3  (.CLK(CLK), .D(DATA_IN[3]),  .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[3])  );
SRL16E srl4  (.CLK(CLK), .D(DATA_IN[4]),  .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[4])  );
SRL16E srl5  (.CLK(CLK), .D(DATA_IN[5]),  .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[5])  );
SRL16E srl6  (.CLK(CLK), .D(DATA_IN[6]),  .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[6])  );
SRL16E srl7  (.CLK(CLK), .D(DATA_IN[7]),  .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[7])  );
SRL16E srl8  (.CLK(CLK), .D(DATA_IN[8]),  .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[8])  );
SRL16E srl9  (.CLK(CLK), .D(DATA_IN[9]),  .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[9])  );
SRL16E srl10 (.CLK(CLK), .D(DATA_IN[10]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[10]) );
SRL16E srl11 (.CLK(CLK), .D(DATA_IN[11]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[11]) );
SRL16E srl12 (.CLK(CLK), .D(DATA_IN[12]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[12]) );
SRL16E srl13 (.CLK(CLK), .D(DATA_IN[13]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[13]) );
SRL16E srl14 (.CLK(CLK), .D(DATA_IN[14]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[14]) );
SRL16E srl15 (.CLK(CLK), .D(DATA_IN[15]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[15]) );
SRL16E srl16 (.CLK(CLK), .D(DATA_IN[16]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[16]) );
SRL16E srl17 (.CLK(CLK), .D(DATA_IN[17]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[17]) );
SRL16E srl18 (.CLK(CLK), .D(DATA_IN[18]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[18]) );
SRL16E srl19 (.CLK(CLK), .D(DATA_IN[19]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[19]) );
SRL16E srl20 (.CLK(CLK), .D(DATA_IN[20]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[20]) );
SRL16E srl21 (.CLK(CLK), .D(DATA_IN[21]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[21]) );
SRL16E srl22 (.CLK(CLK), .D(DATA_IN[22]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[22]) );
SRL16E srl23 (.CLK(CLK), .D(DATA_IN[23]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[23]) );
SRL16E srl24 (.CLK(CLK), .D(DATA_IN[24]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[24]) );
SRL16E srl25 (.CLK(CLK), .D(DATA_IN[25]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[25]) );
SRL16E srl26 (.CLK(CLK), .D(DATA_IN[26]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[26]) );
SRL16E srl27 (.CLK(CLK), .D(DATA_IN[27]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[27]) );
SRL16E srl28 (.CLK(CLK), .D(DATA_IN[28]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[28]) );
SRL16E srl29 (.CLK(CLK), .D(DATA_IN[29]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[29]) );
SRL16E srl30 (.CLK(CLK), .D(DATA_IN[30]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[30]) );
SRL16E srl31 (.CLK(CLK), .D(DATA_IN[31]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[31]) );
SRL16E srl32 (.CLK(CLK), .D(DATA_IN[32]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[32]) );
SRL16E srl33 (.CLK(CLK), .D(DATA_IN[33]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[33]) );
SRL16E srl34 (.CLK(CLK), .D(DATA_IN[34]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[34]) );
SRL16E srl35 (.CLK(CLK), .D(DATA_IN[35]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[35]) );
SRL16E srl36 (.CLK(CLK), .D(DATA_IN[36]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[36]) );
SRL16E srl37 (.CLK(CLK), .D(DATA_IN[37]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[37]) );
SRL16E srl38 (.CLK(CLK), .D(DATA_IN[38]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[38]) );
SRL16E srl39 (.CLK(CLK), .D(DATA_IN[39]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[39]) );
SRL16E srl40 (.CLK(CLK), .D(DATA_IN[40]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[40]) );
SRL16E srl41 (.CLK(CLK), .D(DATA_IN[41]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[41]) );
SRL16E srl42 (.CLK(CLK), .D(DATA_IN[42]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[42]) );
SRL16E srl43 (.CLK(CLK), .D(DATA_IN[43]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[43]) );
SRL16E srl44 (.CLK(CLK), .D(DATA_IN[44]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[44]) );
SRL16E srl45 (.CLK(CLK), .D(DATA_IN[45]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[45]) );
SRL16E srl46 (.CLK(CLK), .D(DATA_IN[46]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[46]) );
SRL16E srl47 (.CLK(CLK), .D(DATA_IN[47]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[47]) );
SRL16E srl48 (.CLK(CLK), .D(DATA_IN[48]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[48]) );
SRL16E srl49 (.CLK(CLK), .D(DATA_IN[49]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[49]) );
SRL16E srl50 (.CLK(CLK), .D(DATA_IN[50]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[50]) );
SRL16E srl51 (.CLK(CLK), .D(DATA_IN[51]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[51]) );
SRL16E srl52 (.CLK(CLK), .D(DATA_IN[52]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[52]) );
SRL16E srl53 (.CLK(CLK), .D(DATA_IN[53]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[53]) );
SRL16E srl54 (.CLK(CLK), .D(DATA_IN[54]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[54]) );
SRL16E srl55 (.CLK(CLK), .D(DATA_IN[55]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[55]) );
SRL16E srl56 (.CLK(CLK), .D(DATA_IN[56]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[56]) );
SRL16E srl57 (.CLK(CLK), .D(DATA_IN[57]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[57]) );
SRL16E srl58 (.CLK(CLK), .D(DATA_IN[58]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[58]) );
SRL16E srl59 (.CLK(CLK), .D(DATA_IN[59]), .CE(1'b1), .A0(data_delay[0]), .A1(data_delay[1]), .A2(data_delay[2]), .A3(data_delay[3]), .Q(delayed_dat_out[59]) );

// register outputs
reg		[59:0]	DATA_OUT;
reg 			VSYNC_OUT, HSYNC_OUT, DE_OUT;
always @(posedge CLK)
	begin
	VSYNC_OUT <=#1 delayed_vs_out;
	HSYNC_OUT <=#1 delayed_hs_out;
	DE_OUT    <=#1 CROP_EN ? (in_x && in_y && delayed_de_out) : delayed_de_out;	// just pass DE if ~CROP EN
	DATA_OUT  <=#1 delayed_dat_out;
	end

endmodule
