module tb1;

  // Declare the signals for the testbench
  reg clk;
  reg data;
  reg lrclk;
  reg resetsig, zero2;

  //reg DSDCLK_sig, DSDLEFT_sig, DSDRIGHT_sig;
  integer file_descriptor;
  integer outfd1, outfd2, outfd3;
  integer count = 0;
  integer d1, d2;
  reg [80:1] str;
  
  // Instantiate the module to be tested
  topLevel dut (
    .I2S_BCKorDSDCLK(clk),
    .I2S_LRCKorDSD2(lrclk),
    .I2S_DATAorDSD1(data),
    .I2S_RST(resetsig),
    .DSD_ON(zero2),
	 .DSDCLK(DSDCLK_sig) ,	// output  DSDCLK_sig
	 .DSDLEFT(DSDLEFT_sig) ,	// output  DSDLEFT_sig
	 .DSDRIGHT(DSDRIGHT_sig) 	// output  DSDRIGHT_sig
  );

  // Clock generation
  //always #20 clk = ~clk;

  // Data generation
  initial begin
    clk = 0;
    lrclk = 0;
    resetsig = 0;
    zero2 = 1;
	 d1 = 1;
	 // Read data from external TXT file
	 file_descriptor = $fopen("../generated_data/test1_2_I2S.txt", "r");
	 outfd1 = $fopen("../rtl_waveforms/test1_DSD_LEFT.txt", "w");
	 outfd2 = $fopen("../rtl_waveforms/test1_DSD_RIGHT.txt", "w");
	 outfd3 = $fopen("../rtl_waveforms/test1_DSD_CLOCK.txt", "w");
    // Apply inputs based on the requirements
    while (d1) begin

		 d1 = $fgets(str, file_descriptor);
		 d2 = $sscanf(str, "%x", data);
       resetsig = 0;   // Always one, this is actually NRST // now fixed in source
       zero2 = 0;   // Always zero
		 $fstrobeb(outfd1, DSDLEFT_sig);
		 $fstrobeb(outfd2, DSDRIGHT_sig);
		 $fstrobeb(outfd3, DSDCLK_sig);
		 //clk = ~clk;
		 @(posedge clk);
		 //#40.6901041667; // ...nanoseconds
    end
	 $fclose(outfd1);
	 $fclose(outfd2);
	 $fclose(outfd3);
	 $fclose(file_descriptor);
    $finish; // End simulation after applying inputs
	 
  end
  
  always #5 clk = ~clk;
  always #160 lrclk = ~lrclk; // flips every 32 ticks
	// create VCD for gtkwave
	initial
	begin
		$dumpfile("tb1out.vcd");
		$dumpvars(0,tb1);
		
	end
	// track signals
//initial
//$monitor($stime,, clk,, data,,, lrclk,, resetsig,, zero2,, DSDCLK_sig,, DSDLEFT_sig,, DSDRIGHT_sig);


endmodule