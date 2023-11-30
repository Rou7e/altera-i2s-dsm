

iverilog -o build/tb3^
 "../../FPGA_PCM2DSD/Verilog/DSM_DELTA.v"^
 "../../FPGA_PCM2DSD/Verilog/DSM_MAXIMIZER.v"^
 "../../FPGA_PCM2DSD/Verilog/DSM_QUANT_1BIT.v"^
 "../../FPGA_PCM2DSD/Verilog/DSM_SIGMA.v"^
 "../../FPGA_PCM2DSD/Verilog/I2S_PCM_Converter.v"^
 "../../FPGA_PCM2DSD/Verilog/Design/01_1st_order/DSM_1bit.v"^
 "../../src/flowSwitch.v"^
 "../../src/topLevel.v"^
 "tb3.v"
vvp build/tb3
gtkwave tb3out.vcd
