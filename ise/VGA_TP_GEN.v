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
`timescale 	100ps / 100ps
//-------------------------------------
// VGA_TP_GEN.v
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	9-11-2007 JAD: created, based on VIODC_DVI_VGA_TP_GEN
//-------------------------------------
//-------------------------------------
//-------------------------------------
module VGA_TP_GEN (
	PIX_CLK, 
	DE, HS, VS, R, G, B
	);

// video input
input			PIX_CLK;

// DVI output signals
output			DE, HS, VS; 
output	[7:0]	R, G, B;


// counters to make video timings:
// (crude, but works)
parameter [9:0]	h_sync   = 10'd96;
parameter [9:0]	h_bporch = 10'd48;
parameter [9:0]	h_active = 10'd640;
parameter [9:0]	h_fporch = 10'd16;
parameter [9:0]	h_total = h_sync + h_bporch + h_active + h_fporch;
reg 	[9:0]	h_count;
always @(posedge PIX_CLK) h_count <=#1 (h_count == h_total-1) ? 0 : h_count + 1;

parameter [9:0]	v_sync   = 10'd2;
parameter [9:0]	v_bporch = 10'd33;
parameter [9:0]	v_active = 10'd480;
parameter [9:0]	v_fporch = 10'd10;
parameter [9:0]	v_total = v_sync + v_bporch + v_active + v_fporch;
reg 	[9:0]	v_count;
always @(posedge PIX_CLK) v_count <=#1 (h_count == h_total-1) ? ((v_count == v_total-1) ? 0 : v_count + 1) : v_count;

// Make the video timings:
reg 			de_gen, hs_gen, vs_gen;
always @(posedge PIX_CLK)
	begin
	hs_gen <=#1 h_count < h_sync;
	vs_gen <=#1 v_count < v_sync;
	de_gen <=#1 (h_count >= (h_sync + h_bporch)) && (h_count < (h_sync + h_bporch + h_active)) &&
	            (v_count >= (v_sync + v_bporch)) && (v_count < (v_sync + v_bporch + v_active));
	end

// generate test pattern - count active pixels
reg 	[17:0]	tp_cnt;
always @(posedge PIX_CLK) tp_cnt <=#1 vs_gen ? 0 : de_gen ? tp_cnt + 1 : tp_cnt;

// Output
reg 			DE, HS, VS;
reg 	[7:0]	R, G, B;
always @(posedge PIX_CLK)
	begin
	DE <=#1 de_gen;
	HS <=#1 hs_gen;
	VS <=#1 vs_gen;
	R <=#1 (tp_cnt[17:16] == 2'b00)||(tp_cnt[17:16] == 2'b11) ? tp_cnt[7:0] : 0;
	G <=#1 (tp_cnt[17:16] == 2'b01)||(tp_cnt[17:16] == 2'b11) ? tp_cnt[7:0] : 0;
	B <=#1 (tp_cnt[17:16] == 2'b10)||(tp_cnt[17:16] == 2'b11) ? tp_cnt[7:0] : 0;
	end

endmodule
