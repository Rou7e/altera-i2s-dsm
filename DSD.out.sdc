## Generated SDC file "DSD.out.sdc"

## Copyright (C) 2022  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 22.1std.0 Build 915 10/25/2022 SC Standard Edition"

## DATE    "Tue Nov 28 04:42:59 2023"

##
## DEVICE  "EP4CGX150DF31I7AD"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {I2S_BCKorDSDCLK} -period 40.722 -waveform { 0.000 20.361 } [get_ports {I2S_BCKorDSDCLK}]
create_clock -name {DSM_1bit:DSM|I2S_PCM_Converter:b2v_inst|WCLK_O} -period 40.700 -waveform { 0.000 20.350 } 


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {I2S_BCKorDSDCLK}] -rise_to [get_clocks {I2S_BCKorDSDCLK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {I2S_BCKorDSDCLK}] -fall_to [get_clocks {I2S_BCKorDSDCLK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {I2S_BCKorDSDCLK}] -rise_to [get_clocks {I2S_BCKorDSDCLK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {I2S_BCKorDSDCLK}] -fall_to [get_clocks {I2S_BCKorDSDCLK}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {I2S_BCKorDSDCLK}]  5.000 [get_ports {I2S_DATAorDSD1}]
set_input_delay -add_delay -min -clock [get_clocks {I2S_BCKorDSDCLK}]  -5.000 [get_ports {I2S_DATAorDSD1}]
set_input_delay -add_delay -max -clock [get_clocks {I2S_BCKorDSDCLK}]  5.000 [get_ports {I2S_LRCKorDSD2}]
set_input_delay -add_delay -min -clock [get_clocks {I2S_BCKorDSDCLK}]  -5.000 [get_ports {I2S_LRCKorDSD2}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {I2S_BCKorDSDCLK}]  5.000 [get_ports {DSDCLK}]
set_output_delay -add_delay -min -clock [get_clocks {I2S_BCKorDSDCLK}]  -5.000 [get_ports {DSDCLK}]
set_output_delay -add_delay -max -clock [get_clocks {I2S_BCKorDSDCLK}]  5.000 [get_ports {DSDLEFT}]
set_output_delay -add_delay -min -clock [get_clocks {I2S_BCKorDSDCLK}]  -5.000 [get_ports {DSDLEFT}]
set_output_delay -add_delay -max -clock [get_clocks {I2S_BCKorDSDCLK}]  5.000 [get_ports {DSDRIGHT}]
set_output_delay -add_delay -min -clock [get_clocks {I2S_BCKorDSDCLK}]  -5.000 [get_ports {DSDRIGHT}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

