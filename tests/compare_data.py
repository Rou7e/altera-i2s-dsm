# -*- coding: utf-8 -*-
"""
Created on Thu Dec 16 00:35:38 2021

@author: AUDIY
"""

import numpy as np
import scipy.signal as signal
import matplotlib.pyplot as plt
import math
# 1st-order Pulse Density Modulation
def PDM(x, nbits):
    qe = 0 # Quantization Error
    y = np.zeros(np.shape(x)[0]) # Return Array
    
    # Modulation
    for i in range(np.shape(x)[0]):
        if x[i] >= qe:
            y[i] = 1
        else:
            y[i] = 0
         
        # Maximize the Modulated Signal to PCM max Amplitude
        yi_Analog = np.floor((((y[i]*2 - 1) + 1)/2) * (2**nbits - 1) + 0.5) \
            - (2 ** (nbits-1))
        
        # Calcurate the Quantization Error
        qe = qe + (yi_Analog - x[i])
        
    return y.astype(int), qe


# float to Linear PCM Conversion
def LPCM(x, nbits):
    #xmax = np.max(x) # Maximum float Amplitude
    xmax = 1
    #xmin = np.min(x) # Minimum float Amplitude
    xmin = -1
    
    # Quantization
    x_LPCM = np.floor(((x - xmin)/(xmax - xmin)) * (2 ** nbits - 1) + 0.5) \
        - (2 ** (nbits-1))
    
    return x_LPCM.astype(int)


# Zero-order Hold Linear PCM Upsampling
def ZeroOrderHold(xPCM, OSR):
    y = signal.upfirdn(np.ones(OSR), xPCM, OSR)
    
    return y

# Int to bit converter

get_bin = lambda x, n: format(x, 'b').zfill(n)

# Main Entry Point

# PCM parameters
fs_PCM = 44100 # Sampling frequency
nbits = 16 # Quantization Bits

# DSD Parameters
OSR = 64 # DSD vs PCM sampling frequency ratio
fs_DSD = fs_PCM * OSR # DSD Sampling frequency

# Time Plots
t_length = 1 # Time length (sec)
t = np.arange(0, 1, 1/fs_PCM)

# Reference Analog Signal (Amplitude Range = [-1, 1])
f = 1000 # Frequency
x = np.sin(2 * np.pi * 1000 * t) # float Sine wave
#x = np.zeros(fs_PCM) # Mute Data

# Analog to Linear PCM conversion
x_LPCM = LPCM(x, nbits)

# Zero Order Hold to Convert DSD
x_LPCM_Hold = ZeroOrderHold(x_LPCM, OSR)

# Convert PCM to DSD
y_DSD, qe = PDM(x_LPCM_Hold, nbits)

# No need to keep PCM in float
x_LPCM_Hold = [int(item) for item in x_LPCM_Hold]




# Plot the filtered DSD Signal, Normalized PCM and DSD Signal
y_filtered = signal.upfirdn(np.ones(10), y_DSD) #Moving Average Filter
y_filtered = y_filtered/np.max(y_filtered) # Normalize

# Тест 1 - интересует правый и левый DSD
T1_DSDLEFT = []
T1_DSDRIGHT = []
T1_DSDCLK = []

with open("rtl_waveforms/test1_DSD_LEFT.txt" , "r") as f:
    lines = f.readlines()
    buff = 0;
    for line in range(len(lines)):
        # downsample to compare with PCM
        buff += int(lines[line])
        if (line % 64 == 0):
            # cut off startup latency
            if (line < (1400*64)):
                buff = 0
                continue
            buff = round(buff / 64)
            # upscale for lr channels
            T1_DSDLEFT.append(buff * 2 -1)
            #T1_DSDLEFT.append(buff * 2 -1)
            buff = 0

        
#with open("rtl_waveforms/test1_DSD_RIGHT.txt" , "r") as f:
#    lines = f.readlines()
#    for line in lines:
#        T1_DSDRIGHT.append(int(line) * 2 -1)

#with open("rtl_waveforms/test1_DSD_CLOCK.txt" , "r") as f:
#    lines = f.readlines()
#    for line in lines:
#        T1_DSDCLK.append(int(line) * 2 -1)
        
# Тест 4 на сквозной пропуск данных по поднятому флагу от конвертера: DSD512 в DSD512
with open("generated_data/test4_I2S.txt" , "w") as f:
    for i in range(2822):
        f.write(str(y_DSD[i]) + "\n")



plt.figure()

ax1 = plt.subplot(2, 2, 1)
ax1.set_title("Test 1")
plotlen = 1244
startdsd = plotlen//2
plt.plot(np.arange(0, 1, 1/fs_DSD)[0:plotlen], y_DSD[0:plotlen] * 2 - 1, label="GOLDEN DSD", alpha=0.7) # DSD

plt.plot(np.arange(0, 1, 1/fs_DSD)[0:plotlen], T1_DSDLEFT[0:plotlen], label="DSDLEFT", alpha=0.7) 
#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], T1_DSDRIGHT[0:2822], label="DSDRIGHT") 
#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], T1_DSDCLK[0:2822], label="DSDCLK") 

plt.plot(np.arange(0, 1, 1/fs_DSD)[0:plotlen], x_LPCM_Hold[0:plotlen]/np.max(x_LPCM_Hold), label="PCM") # PCM
plt.legend(loc="upper right")
plt.xlabel("Time [s]")
plt.ylabel("Normalized Amplitude")

ax2 = plt.subplot(2, 2, 2)
ax2.set_title("Test 2")
#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], y_DSD[0:2822] * 2 - 1, label="DSD") # DSD
#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], y_filtered[0:2822] * 2 - 1, label="Filtered DSD") # Filtered Data
#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], x_LPCM_Hold[0:2822]/np.max(x_LPCM_Hold), label="PCM") # PCM
plt.legend(loc="upper right")
plt.xlabel("Time [s]")
plt.ylabel("Normalized Amplitude")

ax3 = plt.subplot(2, 2, 3)
ax3.set_title("Test 3")
#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], y_DSD[0:2822] * 2 - 1, label="DSD") # DSD
#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], y_filtered[0:2822] * 2 - 1, label="Filtered DSD") # Filtered Data
#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], x_LPCM_Hold[0:2822]/np.max(x_LPCM_Hold), label="PCM") # PCM
plt.legend(loc="upper right")
plt.xlabel("Time [s]")
plt.ylabel("Normalized Amplitude")

ax4 = plt.subplot(2, 2, 4)
ax4.set_title("Test 4")

#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], y_DSD[0:2822] * 2 - 1, label="DSD") # DSD
#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], y_filtered[0:2822] * 2 - 1, label="Filtered DSD") # Filtered Data
#plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], x_LPCM_Hold[0:2822]/np.max(x_LPCM_Hold), label="PCM") # PCM
plt.legend(loc="upper right")
plt.xlabel("Time [s]")
plt.ylabel("Normalized Amplitude")

plt.show()
