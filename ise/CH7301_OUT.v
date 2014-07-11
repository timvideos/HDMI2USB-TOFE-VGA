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
//-------------------------------------
// CH7301_OUT.v
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	8-30-2007 JAD: created
//-------------------------------------
// Very simple module - only real operation is to DDR the data bits.
//-------------------------------------

module CH7301_OUT(
	ENABLE,
	CLK, CLK180, DE, HS, VS, R, G, B, 
	DVI_XCLK_P, DVI_XCLK_N, DVI_DE, DVI_HS, DVI_VS, DVI_D	
	);

// Control inputs
input			ENABLE; // enables the transmission of data 

// Video input stream
input			CLK, CLK180;
input			DE, HS, VS;
input	[7:0]	R, G, B; // video data

// Video interface to CH7301
output			DVI_XCLK_P, DVI_XCLK_N;
output			DVI_DE, DVI_HS, DVI_VS;
output	[11:0]	DVI_D;

ODDR2 xclk_p_oddr (.C0(CLK), .C1(CLK180), .D0(1'b1), .D1(!ENABLE), .CE(1'b1), .R(1'b0), .S(1'b0), .Q(DVI_XCLK_P) );
ODDR2 xclk_n_oddr (.C0(CLK), .C1(CLK180), .D0(1'b0), .D1( ENABLE), .CE(1'b1), .R(1'b0), .S(1'b0), .Q(DVI_XCLK_N) );

FDRSE de_outff (.C(CLK180), .D(DE), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_DE));
FDRSE hs_outff (.C(CLK180), .D(HS), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_HS));
FDRSE vs_outff (.C(CLK180), .D(VS), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_VS));

ODDR2  d00_oddr (.C0(CLK), .C1(CLK180), .D0(G[4]), .D1(B[0]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[00]) );
ODDR2  d01_oddr (.C0(CLK), .C1(CLK180), .D0(G[5]), .D1(B[1]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[01]) );
ODDR2  d02_oddr (.C0(CLK), .C1(CLK180), .D0(G[6]), .D1(B[2]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[02]) );
ODDR2  d03_oddr (.C0(CLK), .C1(CLK180), .D0(G[7]), .D1(B[3]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[03]) );
ODDR2  d04_oddr (.C0(CLK), .C1(CLK180), .D0(R[0]), .D1(B[4]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[04]) );
ODDR2  d05_oddr (.C0(CLK), .C1(CLK180), .D0(R[1]), .D1(B[5]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[05]) );
ODDR2  d06_oddr (.C0(CLK), .C1(CLK180), .D0(R[2]), .D1(B[6]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[06]) );
ODDR2  d07_oddr (.C0(CLK), .C1(CLK180), .D0(R[3]), .D1(B[7]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[07]) );
ODDR2  d08_oddr (.C0(CLK), .C1(CLK180), .D0(R[4]), .D1(G[0]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[08]) );
ODDR2  d09_oddr (.C0(CLK), .C1(CLK180), .D0(R[5]), .D1(G[1]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[09]) );
ODDR2  d10_oddr (.C0(CLK), .C1(CLK180), .D0(R[6]), .D1(G[2]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[10]) );
ODDR2  d11_oddr (.C0(CLK), .C1(CLK180), .D0(R[7]), .D1(G[3]), .CE(1'b1), .R(!ENABLE), .S(1'b0), .Q(DVI_D[11]) );

endmodule
