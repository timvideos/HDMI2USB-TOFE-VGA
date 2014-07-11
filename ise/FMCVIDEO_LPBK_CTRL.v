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
// FMCVIDEO_LPBK_CTRL.v
// Jason Daughenbaugh
//-------------------------------------
// History of Changes:
//	9-12-2007 JAD: created
//-------------------------------------
// This module is a wrapper for a Picoblaze processor to control misc stuff (I2C, etc)
//-------------------------------------

module FMCVIDEO_LPBK_CTRL(
	CLK, 
	FPGA_DIP_SW, GPIO_LED, 
	MAIN_SCL, MAIN_SDA,
	CTRL_SCL, CTRL_SDA, 
	DVIIN_USE_DE, DVIIN_CROP_EN, 
	CROP_START_X, CROP_WIDTH_X, CROP_START_Y, CROP_HEIGHT_Y,
	DVIOUT_EN, VIDOUT_EN, INPUT_SEL, ERROR_LIM, ERROR_PORTION
	);

// Master Clock input
input			CLK;

// Control/status interface
input	[7:0]	FPGA_DIP_SW;
output	[7:0]	GPIO_LED;

// Main Carrier card I2C bus
output			MAIN_SCL;
inout			MAIN_SDA;

// FMCVIDEO control I2C Bus
output			CTRL_SCL;
inout			CTRL_SDA;

// DVI input controls
output			DVIIN_USE_DE, DVIIN_CROP_EN;
output	[15:0]	CROP_START_X, CROP_WIDTH_X, CROP_START_Y, CROP_HEIGHT_Y;

// Control Signals
output			DVIOUT_EN, VIDOUT_EN;
output	[2:0]	INPUT_SEL; // 0 = DVI-D, 1 = DVI-A, 2 = SDTV, 3 = CAM1, 4 = CAM2
output	[7:0]	ERROR_LIM, ERROR_PORTION;

//------- Picoblaze data bus -------
wire	[7:0]	adr, wr_dat, rd_dat;
wire			rd_strobe, wr_strobe;

//------- PicoBlaze data bus stuff ----------
parameter [7:0]	csr_adr           = 8'h00;
parameter [7:0]	i2c_reg_adr       = 8'h01;
parameter [7:0]	ctrl_adr          = 8'h02;
parameter [7:0]	error_lim_adr     = 8'h03;
parameter [7:0]	error_portion_adr = 8'h04;

parameter [7:0]	startx_Hadr  = 8'h08;
parameter [7:0]	startx_Ladr  = 8'h09;
parameter [7:0]	widthx_Hadr  = 8'h0A;
parameter [7:0]	widthx_Ladr  = 8'h0B;
parameter [7:0]	starty_Hadr  = 8'h0C;
parameter [7:0]	starty_Ladr  = 8'h0D;
parameter [7:0]	heighty_Hadr = 8'h0E;
parameter [7:0]	heighty_Ladr = 8'h0F;

// Control and status register
reg 	[7:0]	GPIO_LED;
always @(posedge CLK) GPIO_LED <=#1 (adr == csr_adr) && wr_strobe ? wr_dat[7:0] : GPIO_LED;
wire 	[7:0]	csr_rd = FPGA_DIP_SW[7:0];

// I2C register
reg 			i2c_bus_sel = 0; // 0 = MAIN, 1 = FMCVIDEO CTRL
reg 			scl_out, sda_out; // pre-mux
wire			MAIN_SCL = !i2c_bus_sel ? scl_out : 1'b1;
wire			CTRL_SCL =  i2c_bus_sel ? scl_out : 1'b1;
tri 			MAIN_SDA = !i2c_bus_sel && !sda_out ? 1'b0 : 1'bz;
tri 			CTRL_SDA =  i2c_bus_sel && !sda_out ? 1'b0 : 1'bz;
always @(posedge CLK) 
	begin
	i2c_bus_sel <=#1 (adr == i2c_reg_adr) && wr_dat[7] && wr_strobe ? wr_dat[6] : i2c_bus_sel;
	scl_out     <=#1 (adr == i2c_reg_adr) && wr_dat[3] && wr_strobe ? wr_dat[2] : scl_out;
	sda_out     <=#1 (adr == i2c_reg_adr) && wr_dat[1] && wr_strobe ? wr_dat[0] : sda_out;
	end
wire	[7:0]	i2c_reg_rd = {7'b0000_000, !i2c_bus_sel ? MAIN_SDA : CTRL_SDA};


// control register
reg 	[2:0]	INPUT_SEL = 0;
always @(posedge CLK) INPUT_SEL <=#1 (adr == ctrl_adr) && wr_strobe ? wr_dat[2:0] : INPUT_SEL;
// 0 = DVI-D, 1 = DVI-A, 2 = SDTV, 3 = CAM1, 4 = CAM2
wire			DVIOUT_EN = (INPUT_SEL == 3'd0) || (INPUT_SEL == 3'd1); // enable DVI out when testing input
wire			VIDOUT_EN = (INPUT_SEL == 3'd2); // enable video output when testing input
wire			DVIIN_USE_DE  = (INPUT_SEL == 3'd0); // DE when DVI-Digital
wire			DVIIN_CROP_EN = (INPUT_SEL == 3'd1); // crop when analog

// Test controls
reg 	[7:0]	ERROR_LIM = 0, ERROR_PORTION = 0;
always @(posedge CLK) ERROR_LIM <=#1 (adr == error_lim_adr) && wr_strobe ? wr_dat[7:0] : ERROR_LIM;
always @(posedge CLK) ERROR_PORTION <=#1 (adr == error_portion_adr) && wr_strobe ? wr_dat[7:0] : ERROR_PORTION;


// image cropping/positioning parameters
reg 	[15:0]	CROP_START_X, CROP_WIDTH_X, CROP_START_Y, CROP_HEIGHT_Y;
always @(posedge CLK) CROP_START_X[15:8] <=#1 (adr == startx_Hadr) && wr_strobe ? wr_dat : CROP_START_X[15:8];
always @(posedge CLK) CROP_START_X[7:0]  <=#1 (adr == startx_Ladr) && wr_strobe ? wr_dat : CROP_START_X[7:0];
always @(posedge CLK) CROP_WIDTH_X[15:8] <=#1 (adr == widthx_Hadr) && wr_strobe ? wr_dat : CROP_WIDTH_X[15:8];
always @(posedge CLK) CROP_WIDTH_X[7:0]  <=#1 (adr == widthx_Ladr) && wr_strobe ? wr_dat : CROP_WIDTH_X[7:0];
always @(posedge CLK) CROP_START_Y[15:8] <=#1 (adr == starty_Hadr) && wr_strobe ? wr_dat : CROP_START_Y[15:8];
always @(posedge CLK) CROP_START_Y[7:0]  <=#1 (adr == starty_Ladr) && wr_strobe ? wr_dat : CROP_START_Y[7:0];
always @(posedge CLK) CROP_HEIGHT_Y[15:8]<=#1 (adr == heighty_Hadr)&& wr_strobe ? wr_dat : CROP_HEIGHT_Y[15:8];
always @(posedge CLK) CROP_HEIGHT_Y[7:0] <=#1 (adr == heighty_Ladr)&& wr_strobe ? wr_dat : CROP_HEIGHT_Y[7:0];
 
// generate read data
assign rd_dat =
	(adr == csr_adr)     ? csr_rd : 
	(adr == i2c_reg_adr) ? i2c_reg_rd : 
	8'h00; 

//------- Picoblaze Program -------
wire	[9:0]	instruction_address;
wire	[17:0]	instruction;
PB_FMCVIDEO_LPBK prog (
    .CLK(CLK), .ADDRESS(instruction_address), .INSTRUCTION(instruction),
	.LOAD_CLK(1'b0), .LOAD_ADDRESS(), .LOAD_INSTRUCTION(), .LOAD_WE(1'b0)
	);

// ------- Picoblaze Processor -------
reg  		interrupt = 0;
wire		interrupt_ack;
kcpsm3 cpu (
    .clk(CLK), 
    .interrupt(interrupt), .interrupt_ack(interrupt_ack),
    .address(instruction_address), .instruction(instruction), 
    .port_id(adr), .in_port(rd_dat), .out_port(wr_dat), 
    .read_strobe(rd_strobe), .write_strobe(wr_strobe), 
    .reset(1'b0)
    );

endmodule
