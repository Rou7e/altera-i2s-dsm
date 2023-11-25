// Copyright (C) 2022  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 22.1std.0 Build 915 10/25/2022 SC Standard Edition"
// CREATED		"Wed Nov 22 12:51:29 2023"

module topLevel(
	I2S_RST,
	DSD_ON,
	I2S_BCKorDSDCLK,
	I2S_LRCKorDSD2,
	I2S_DATAorDSD1,
	DSDCLK,
	DSDLEFT,
	DSDRIGHT
);


input wire	I2S_RST;
input wire	DSD_ON;
input wire	I2S_BCKorDSDCLK;
input wire	I2S_LRCKorDSD2;
input wire	I2S_DATAorDSD1;
output wire	DSDCLK;
output wire	DSDLEFT;
output wire	DSDRIGHT;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;





DSM_1bit	b2v_DSM(
	.BCK_I(I2S_BCKorDSDCLK),
	.LRCK_I(I2S_LRCKorDSD2),
	.DATA_I(I2S_DATAorDSD1),
	.RST_I(I2S_RST),
	.DBCK_O(SYNTHESIZED_WIRE_0),
	.DSDL_O(SYNTHESIZED_WIRE_1),
	.DSDR_O(SYNTHESIZED_WIRE_2));


flowSwitch	b2v_flowSwitch(
	.DBCK_O(SYNTHESIZED_WIRE_0),
	.DSDL_O(SYNTHESIZED_WIRE_1),
	.DSDR_O(SYNTHESIZED_WIRE_2),
	.I2S_BCK(I2S_BCKorDSDCLK),
	.I2S_LRCLK(I2S_LRCKorDSD2),
	.I2S_DATA(I2S_DATAorDSD1),
	.DSD_ON(DSD_ON),
	.DSDCLK(DSDCLK),
	.DSDL(DSDLEFT),
	.DSDR(DSDRIGHT));


endmodule
