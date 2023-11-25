module flowSwitch(
    DSDCLK,
    DSDL,
    DSDR,
	 DBCK_O,
	 DSDL_O,
	 DSDR_O,
	 I2S_BCK,
	 I2S_LRCLK,
	 I2S_DATA,
	 DSD_ON
);

input wire I2S_BCK;
input wire I2S_LRCLK;
input wire I2S_DATA;

input wire DSD_ON;

output reg DSDCLK;
output reg DSDL;
output reg DSDR;

input wire DBCK_O;
input wire DSDL_O;
input wire DSDR_O;

always @(*) begin
    if (DSD_ON) begin
		  DSDCLK <= I2S_BCK;
		  DSDL <= I2S_DATA;
		  DSDR <= I2S_LRCLK;
	 end
    else begin
		  DSDCLK <= DBCK_O;
		  DSDL <= DSDL_O;
		  DSDR <= DSDR_O;
	  end
end


endmodule