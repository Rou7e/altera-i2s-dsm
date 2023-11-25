
# Define input clock period
create_clock -period 163.2 [get_ports {I2S_BCKorDSDCLK}]

# set the negedge clk constr (doesn't work in quartus)
#create_clock -name {DSM_1bit:DSM|I2S_PCM_Converter:b2v_inst|WCLK_O} -period 400.8


# Define input delay constraints
set_input_delay -clock [get_clocks I2S_BCKorDSDCLK] -min -20 [get_ports {I2S_DATAorDSD1 I2S_LRCKorDSD2}]
set_input_delay -clock [get_clocks I2S_BCKorDSDCLK] -max 20 [get_ports {I2S_DATAorDSD1 I2S_LRCKorDSD2}]


# Define output clock period
#create_clock -period 40.8 [get_ports {DSDCLK}]

# Define output delay constraints
set_output_delay -clock [get_clocks I2S_BCKorDSDCLK] -min -20 [get_ports {DSDLEFT DSDRIGHT DSDCLK}]
set_output_delay -clock [get_clocks I2S_BCKorDSDCLK] -max 20 [get_ports {DSDLEFT DSDRIGHT DSDCLK}]