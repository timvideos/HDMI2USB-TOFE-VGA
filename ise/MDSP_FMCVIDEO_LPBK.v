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
// MDSP_FMCVIDEO_LPBK.v
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	9-11-2007 JAD: created, based loosely on MDSP_FMCVIDEO_PASS.v
// 12-13-2007 JAD: Added short reset pulse on DVI_RESET_B at startup.
// 12-31-2007 JAD: Fixed minor bug in picoblaze code (CH7301 reset)
//-------------------------------------
// This is the top level for MDSP_FMCVIDEO_LPBK:
// XC3SD3400A-4FG676C on MDSP carrier board.
// This design allows loopback testing of various video interfaces.
//-------------------------------------
//-------------------------------------
module MDSP_FMCVIDEO_LPBK (
	FPGA_CLK_27M,  FPGA_CLK_33M, 
	IIC_SCLK, IIC_SDAT, 
	FPGA_DIP_SW, GPIO_LED, 
	DVI_XCLK_P, DVI_XCLK_N, DVI_DE, DVI_H, DVI_V, DVI_D, DVI_RESET_B, 
	MEM_EN_B, 
	CTRL_SCL, CTRL_SDA, 
	INCLK_P, INCLK_N, 
	DVIIN_DE, DVIIN_HS, DVIIN_VS, DVIIN_R, DVIIN_G, DVIIN_B,
	VIDIN_HS, VIDIN_FLD_VS, VIDIN_D, 
	CAM2_CLK, CAM2_LINE, CAM2_FRAME, CAM2_D,
	VIDOUT_CLK, VIDOUT_HS, VIDOUT_FLD_VS, VIDOUT_D
	);

// Clock inputs
input			FPGA_CLK_27M; 
input			FPGA_CLK_33M;

// Local I2C bus
output			IIC_SCLK;
inout			IIC_SDAT;

// Local User interface
input	[7:0]	FPGA_DIP_SW;
output	[7:0]	GPIO_LED;

// Interface to CH7301
output			DVI_XCLK_P, DVI_XCLK_N;
output			DVI_DE, DVI_H, DVI_V;
output	[11:0]	DVI_D;
output			DVI_RESET_B;

// Disable memory interface:
output			MEM_EN_B;
wire			MEM_EN_B = 1;

// FMCVIDEO interface
// I2C control interface (not the FMC identification I2C bus)
output			CTRL_SCL;
inout			CTRL_SDA;

// Master clock input (muxed from many sources)
input			INCLK_P, INCLK_N;

// DVI analog/digital input
input			DVIIN_DE, DVIIN_HS, DVIIN_VS;
input	[9:0]	DVIIN_R, DVIIN_G, DVIIN_B;

// SDTV and cam1 shared input
input			VIDIN_HS, VIDIN_FLD_VS;
input	[7:0]	VIDIN_D;

// Camera 2 input
input			CAM2_CLK, CAM2_LINE, CAM2_FRAME;
input	[7:0]	CAM2_D;

// SDTV output
output			VIDOUT_CLK;
output			VIDOUT_HS, VIDOUT_FLD_VS;
output	[7:0]	VIDOUT_D;

//------- Clocks -------
wire			clk33 = FPGA_CLK_33M;
wire			clk27 = FPGA_CLK_27M;

wire			inclk_buf;
IBUFGDS #(.DIFF_TERM("TRUE")) clk_ibufgds (.I(INCLK_P), .IB(INCLK_N), .O(inclk_buf) );
wire			vidclk;
BUFG vclk_bufg(.I(inclk_buf), .O(vidclk));
   
//------- Controller -------
// DVI input controls
wire			dviin_use_de, dviin_crop_en;
wire	[15:0]	crop_start_x, crop_width_x, crop_start_y, crop_height_y;
// Input select
wire	[2:0]	input_sel; // 0 = DVI-D, 1 = DVI-A, 2 = SDTV, 3 = CAM1, 4 = CAM2
wire			dviout_en; // enable data transmission to output
wire			vidout_en; // enable SDTV data transmission to output

// interface to tests:
wire	[7:0]	error_lim, error_portion;
wire			dvivga_clk_failed, dvivga_R_failed, dvivga_G_failed, dvivga_B_failed;
wire			cam1_clk_failed, cam1_d_failed;
wire			cam2_clk_failed, cam2_d_failed;
wire			sdtv_clk_failed, sdtv_d_failed;
wire	[3:0]	selected_errors = 
	(input_sel == 3'd0) || (input_sel == 3'd1) ? {dvivga_clk_failed, dvivga_R_failed, dvivga_G_failed, dvivga_B_failed} : 
	(input_sel == 3'd2)                        ? {sdtv_clk_failed, sdtv_d_failed, 2'b00} : 
	(input_sel == 3'd3)                        ? {cam1_clk_failed, cam1_d_failed, 2'b00} : 
	(input_sel == 3'd4)                        ? {cam2_clk_failed, cam2_d_failed, 2'b00} : 
	4'b1111;
wire	[7:0]	gpio_led_ctrl;
wire	[7:0]	GPIO_LED = {selected_errors[3:0], gpio_led_ctrl[3:0]};

FMCVIDEO_LPBK_CTRL ctrl (
    .CLK(clk33), 
	.FPGA_DIP_SW(~FPGA_DIP_SW), .GPIO_LED(gpio_led_ctrl), 
	.MAIN_SCL(IIC_SCLK), .MAIN_SDA(IIC_SDAT),
	.CTRL_SCL(CTRL_SCL), .CTRL_SDA(CTRL_SDA), 
	.DVIIN_USE_DE(dviin_use_de), .DVIIN_CROP_EN(dviin_crop_en), 
	.CROP_START_X(crop_start_x), .CROP_WIDTH_X(crop_width_x), .CROP_START_Y(crop_start_y), .CROP_HEIGHT_Y(crop_height_y), 
	.DVIOUT_EN(dviout_en), .VIDOUT_EN(vidout_en), .INPUT_SEL(input_sel), .ERROR_LIM(error_lim), .ERROR_PORTION(error_portion)
	);

// ------- Generate the DVI test pattern -------
wire 			dvi_out_de, dvi_out_hs, dvi_out_vs;
wire 	[7:0]	dvi_out_r, dvi_out_g, dvi_out_b;
VGA_TP_GEN dvitp (
	.PIX_CLK(clk27), 
	.DE(dvi_out_de), .HS(dvi_out_hs), .VS(dvi_out_vs), 
	.R(dvi_out_r), .G(dvi_out_g), .B(dvi_out_b)
	);

CH7301_OUT dviout (
	.CLK(clk27), .CLK180(!clk27), 
	.ENABLE(dviout_en), 
	.DE(dvi_out_de), .HS(dvi_out_hs), .VS(dvi_out_vs), .R(dvi_out_r), .G(dvi_out_g), .B(dvi_out_b), 
	.DVI_XCLK_P(DVI_XCLK_P), .DVI_XCLK_N(DVI_XCLK_N), 
	.DVI_DE(DVI_DE), .DVI_HS(DVI_H), .DVI_VS(DVI_V), .DVI_D(DVI_D)
	);
reg 	[11:0]	dvi_rst_count = 0;
wire			DVI_RESET_B = dvi_rst_count[11];
always @(posedge clk33) if (!DVI_RESET_B) dvi_rst_count <=#1 dvi_rst_count + 1;

//------- The DVI analog/digital input -------
wire			dvi_in_de, dvi_in_hs, dvi_in_vs;
wire	[9:0]	dvi_in_r, dvi_in_g, dvi_in_b;
DVI_IN dviin (
	.DVI_CLK(vidclk), 
	.DVIIN_DE(DVIIN_DE), .DVIIN_HS(DVIIN_HS), .DVIIN_VS(DVIIN_VS), .DVIIN_R(DVIIN_R), .DVIIN_G(DVIIN_G), .DVIIN_B(DVIIN_B), 
	.USE_DE(dviin_use_de), .CROP_EN(dviin_crop_en), 
	.CROP_START_X(crop_start_x), .CROP_WIDTH_X(crop_width_x), .CROP_START_Y(crop_start_y), .CROP_HEIGHT_Y(crop_height_y), 
	.DE(dvi_in_de), .HS(dvi_in_hs), .VS(dvi_in_vs), .R(dvi_in_r), .G(dvi_in_g), .B(dvi_in_b), 
	.DET_VS_POL(), .DET_HS_POL()
	);
	
// ------- Test the received Video -------
VGA_TP_TEST dvivgatest (
	.REF_CLK(clk27), 
	.ERROR_LIM(error_lim), .ERROR_PORTION(error_portion),
	.IN_CLK(vidclk), .IN_VS(dvi_in_vs), .IN_HS(dvi_in_hs), .IN_DE(dvi_in_de), 
	.IN_R(dvi_in_r[9:2]), .IN_G(dvi_in_g[9:2]), .IN_B(dvi_in_b[9:2]), 
	.CLK_FAILED(dvivga_clk_failed), .R_FAILED(dvivga_R_failed), .G_FAILED(dvivga_G_failed), .B_FAILED(dvivga_B_failed)
	);


//------- SDTV/CAM1 shared input bus -------
reg 			vidin_hs_inff, vidin_fld_vs_inff;
reg 	[7:0]	vidin_d_inff;
always @(posedge vidclk)
	begin
	vidin_hs_inff <=#1 VIDIN_HS;
	vidin_fld_vs_inff <=#1 VIDIN_FLD_VS;
	vidin_d_inff <=#1 VIDIN_D;
	end
wire			cam1_line = vidin_hs_inff;
wire			cam1_frame = vidin_fld_vs_inff;
wire	[7:0]	cam1_d = vidin_d_inff;

// ---------- The SDTV Test Pattern output ---------
YCrCb422_TP_GEN sdtvtp (
    .VID_CLK(clk27), .ENABLE(vidout_en), 
	.VIDOUT_CLK(VIDOUT_CLK), .VIDOUT_HS(VIDOUT_HS), .VIDOUT_FIELD(VIDOUT_FLD_VS), .VIDOUT_BLANK_L(), .VIDOUT_D(VIDOUT_D)
    );

// ---------- Test the SDTV input ---------
YCrCb422_TP_TEST sdtvtst (
	.REF_CLK(clk27), 
	.ERROR_LIM(error_lim), .ERROR_PORTION(error_portion),
	.IN_CLK(vidclk), .IN_HS(vidin_hs_inff), .IN_FIELD(vidin_fld_vs_inff), .IN_D(vidin_d_inff), 
	.CLK_FAILED(sdtv_clk_failed), .D_FAILED(sdtv_d_failed)
	);
 
// ---------- Test Camera 1 input ---------
CAM_TP_TEST cam1tst (
	.REF_CLK(clk27), 
	.ERROR_LIM(error_lim), .ERROR_PORTION(error_portion),
	.IN_CLK(vidclk), .IN_FRAME(cam1_frame), .IN_LINE(cam1_line), .IN_D(cam1_d), 
	.CLK_FAILED(cam1_clk_failed), .D_FAILED(cam1_d_failed)
	);

// ---------- Test Camera 2 input ---------
CAM_TP_TEST cam2tst (
	.REF_CLK(clk27), 
	.ERROR_LIM(error_lim), .ERROR_PORTION(error_portion),
	.IN_CLK(CAM2_CLK), .IN_FRAME(CAM2_FRAME), .IN_LINE(CAM2_LINE), .IN_D(CAM2_D), 
	.CLK_FAILED(cam2_clk_failed), .D_FAILED(cam2_d_failed)
	);



endmodule
