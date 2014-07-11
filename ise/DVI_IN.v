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
// DVI_IN
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	8-31-2007 JAD: created
//-------------------------------------
// This module receives digitial DVI video data
//-------------------------------------
// If USE_DE, DVIIN_DE is used to frame active pixels. If not, all pixels 
//   are "active" and should be cropped.
// If CROP_EN, the CROP_x coordinates are used to define a bounding box 
//   within the video data
// VS and HS outputs are always active high, with DET_VS_POL and 
//   DET_HS_POL indicating the detected input polarity.
//-------------------------------------
module DVI_IN(
	DVI_CLK, 
	DVIIN_DE, DVIIN_HS, DVIIN_VS, DVIIN_R, DVIIN_G, DVIIN_B,
	USE_DE, CROP_EN, CROP_START_X, CROP_WIDTH_X, CROP_START_Y, CROP_HEIGHT_Y,
	DE, HS, VS, R, G, B,
	DET_VS_POL, DET_HS_POL
	);

// Pixel Clock (data comes in and out on this clock)
input			DVI_CLK;

// Raw Video input
input			DVIIN_DE, DVIIN_HS, DVIIN_VS;
input	[9:0]	DVIIN_R, DVIIN_G, DVIIN_B;

// Controls parameters
input			USE_DE; // Set to use input DE
input			CROP_EN; // set to enable cropping
input	[15:0]	CROP_START_X, CROP_WIDTH_X, CROP_START_Y, CROP_HEIGHT_Y;

// video output
output			DE, HS, VS; // active High
output	[9:0]	R, G, B;

// Status output
output			DET_VS_POL, DET_HS_POL; // detected polarity.


// input flip flops
reg 			vs_inff = 0, hs_inff = 0, de_inff = 0;
reg 	[29:0]	pixel_inff;
always @(posedge DVI_CLK)
	begin
	vs_inff <=#1 DVIIN_VS;
	hs_inff <=#1 DVIIN_HS;
	de_inff <=#1 DVIIN_DE;
	pixel_inff <=#1 {DVIIN_R[9:0], DVIIN_G[9:0], DVIIN_B[9:0]};
	end

// detect sync polarities - using only hs, vs (DE not always available)
reg 			vs_prev, hs_prev;
reg 	[5:0]	vs_det_count; // more than the maximum blanking time
reg 			DET_VS_POL=1; // 1 means active high
reg 	[11:0]	hs_det_count; // needs to be larger than max resolution coming in
reg 			DET_HS_POL=1; // 1 means active high
always @(posedge DVI_CLK)
	begin
	vs_prev <=#1  vs_inff; // save previous vsync
	vs_det_count <=#1 (vs_inff != vs_prev)? 6'd0 : (hs_inff && ~hs_prev)?  vs_det_count + 1 : vs_det_count;
	DET_VS_POL <=#1 (vs_det_count == 6'd63)? ~vs_prev : DET_VS_POL; // assume vsync is < 63 lines
	hs_prev <=#1  hs_inff; // save previous hsync
	hs_det_count <=#1 (hs_inff && ~hs_prev)? 1 : hs_prev ? hs_det_count+1 : hs_det_count-1;
	DET_HS_POL <=#1 (hs_inff && ~hs_prev)? hs_det_count[11] : DET_HS_POL; 
	end
// syncs with positive polarity	
wire			vs_pos = (vs_inff == DET_VS_POL);
wire			hs_pos = (hs_inff == DET_HS_POL);

// Crop (regenerate DE for analog modes)
wire	[29:0]	crop_dout;
wire	[9:0]	R = crop_dout[29:20], G  = crop_dout[19:10], B  = crop_dout[9:0];
IMAGE_CROP crop (
	.CLK(DVI_CLK), 
	.DATA_IN(pixel_inff), .DE_IN(USE_DE ? de_inff : 1'b1), .VSYNC_POS_IN(vs_pos), .HSYNC_POS_IN(hs_pos), 
	.CROP_EN(CROP_EN), .CROP_START_X(CROP_START_X), .CROP_START_Y(CROP_START_Y), .CROP_WIDTH(CROP_WIDTH_X), .CROP_HEIGHT(CROP_HEIGHT_Y), 
	.DATA_OUT(crop_dout), .DE_OUT(DE), .VSYNC_OUT(VS), .HSYNC_OUT(HS)
	);

endmodule
