module tb1;

  // Declare the signals for the testbench
  reg clk;
  reg data;
  reg lrclk;
  reg zero1, zero2;

  // Instantiate the module to be tested
  topLevel dut (
    .I2S_BCKorDSDCLK(clk),
    .I2S_LRCKorDSD2(data),
    .I2S_DATAorDSD1(lrclk),
    .I2S_RST(zero1),
    .DSD_ON(zero2),
	 .DSDCLK(DSDCLK_sig) ,	// output  DSDCLK_sig
	 .DSDLEFT(DSDLEFT_sig) ,	// output  DSDLEFT_sig
	 .DSDRIGHT(DSDRIGHT_sig) 	// output  DSDRIGHT_sig
  );

  // Clock generation
  always #20 clk = ~clk;

  // Data generation
  initial begin
    clk = 0;
    lrclk = 0;
    zero1 = 0;
    zero2 = 0;

    // Read data from external TXT file
    $readmemh("../generated_data/test1_2_I2S.txt", data);

    // Apply inputs based on the requirements
    repeat(2822) begin
      #10 lrclk = ~lrclk; // lrclk every 32 data beats
      #10 zero1 = 0;   // Always zero
      #10 zero2 = 0;   // Always zero
    end

    $finish; // End simulation after applying inputs
  end

endmodule