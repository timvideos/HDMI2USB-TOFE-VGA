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
// FREQ_COMPARE
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	12-1-2005 JAD: created
//  9-12-2007 JAD: Changed counter to 100 (from 128) to truly be 1% tolerance,
//    Added PERCENT_TOLERANCE parameter for greater flexibility in use.
//-------------------------------------
// This is frequency measuring module.
// Match says that the two frequencies are within 1% of the same frequency
//-------------------------------------
// A few signals exist between clock domains.  
//  These paths are setup internal to this module so that timing
//  does not matter.  There should be no problems.
//-------------------------------------
module FREQ_COMPARE (TEST_CLK, REF_CLK, MATCH);
input			TEST_CLK;
input			REF_CLK;
output			MATCH;

parameter PERCENT_TOLERANCE = 1;

// run counter1 with TEST_CLK
reg 	[6:0]	count;
reg  			toggle = 0; // toggles every 100 TEST_CLK cycles
always @(posedge TEST_CLK) 
	begin
	count  <=#1 (count[6:0] == 7'd99) ? 0 : count +1;
	toggle <=#1 (count[6:0] == 7'd99) ? ~toggle : toggle;
	end

// move the gate over to REF_CLK
reg 	[4:0]	toggle_move; // to move toggle from TEST_CLK to REF_CLK (metastability)
always @(posedge REF_CLK) toggle_move[4:0] <=#1 {toggle_move[3:0], toggle};
wire			test_toggle      = toggle_move[3];  // lags test_toggle by 9-10 REF_CLK cycles.
wire			test_toggle_prev = toggle_move[4]; // lags test_toggle by one more cycle.
wire			changing_test_toggle = test_toggle ^ test_toggle_prev;

// count the length of test_toggle with REF_CLK
reg 	[7:0]	test_count; // reset when not test_toggle, count up to 0xC0 (192) max
always @(posedge REF_CLK) test_count <=#1 changing_test_toggle ? 0 : (test_count[7:6] != 2'b11) ? test_count + 1 : test_count;

// test the result whenever test_toggle toggles.
reg 			MATCH; // Pulse of length 100 of TEST_CLK was 99-101 of REF_CLK.
always @(posedge REF_CLK) 
	if (changing_test_toggle) // check pulse length
		MATCH <=#1 (test_count >= 8'd99 - PERCENT_TOLERANCE) && (test_count <= 8'd99 + PERCENT_TOLERANCE);
	else if (test_count[7:6] == 2'b11) // counter maxed out (for stopped clocks)
		MATCH <=#1 0;
	else
		MATCH <=#1 MATCH;

endmodule
