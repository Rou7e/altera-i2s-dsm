# -*- coding: utf-8 -*-
"""
Created on Thu Dec 16 00:35:38 2021

@author: AUDIY
"""

import numpy as np
import scipy.signal as signal
import matplotlib.pyplot as plt

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
plt.figure()
plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], y_DSD[0:2822] * 2 - 1, label="DSD") # DSD
plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], y_filtered[0:2822] * 2 - 1, label="Filtered DSD") # Filtered Data
plt.plot(np.arange(0, 1, 1/fs_DSD)[0:2822], x_LPCM_Hold[0:2822]/np.max(x_LPCM_Hold), label="PCM") # PCM
plt.legend(loc="upper right")
plt.xlabel("Time [s]")
plt.ylabel("Normalized Amplitude")
plt.show()

# Пишем каждое слово два раза, чтобы лить в оба канала одно и то же

# Тест 1 на максимальной частоте: PCM32 на входе DSD512 на выходе
# Тест 2 на пониженной частоте: PCM32 в DSD64 (то же самое, другой тестбенч)
with open("generated_data/test1_2_I2S.txt" , "w") as f:
    for i in range(2822):
        bitstring = get_bin(x_LPCM_Hold[i], 32)
        if ('-' in bitstring):
            bitstring = bitstring[2:]
            bitstring = '1' + bitstring
        #print(bitstring)
        for c in bitstring:
            f.write(c + "\n")
        for c in bitstring:
            f.write(c + "\n")

# Тест 3 на сниженной разрядности: PCM16 в DSD512
with open("generated_data/test3_I2S.txt" , "w") as f:
    for i in range(2822):
        bitstring = get_bin(x_LPCM_Hold[i], 16)
        if ('-' in bitstring):
            bitstring = bitstring[2:]
            bitstring = '1' + bitstring
        for c in bitstring:
            f.write(c + "\n")
        for c in bitstring:
            f.write(c + "\n")
            
# Тест 4 на сквозной пропуск данных по поднятому флагу от конвертера: DSD512 в DSD512
with open("generated_data/test4_I2S.txt" , "w") as f:
    for i in range(2822):
        f.write(str(y_DSD[i]) + "\n")
