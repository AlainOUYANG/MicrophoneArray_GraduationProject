import numpy as np
import scipy.signal as signal 
import math
import random
import matplotlib.pyplot as plt
from numpy import *

# Hypothesis
# far field
# narrow band signal
c = 340 # sound speed (m/s)
pi = math.pi # pi

## Signal configuration
nbs = 65535 # sample number
Fs = 40000 # %sample frequency (Hz)
t = np.linspace(0, nbs/Fs, nbs) # time (s)
# t = list(map((lambda x : x / Fs),range(nbs))) # time (s)
F0 = 3000 # signal frequency (Hz)
theta = 45 # source direction

## array configuration
M = 8 # number of microphone
d = 0.05 # distance between 2 adjoining microphones (m) d < lambda / 2
g = 1 # propagation factor (amptitute)

delay = np.array(range(M)) * d * math.cos(2*pi*F0*theta/360) / c # TDOA(s)

snr = 20 # signal to ratio (dB)
phase = random.random() * 2 * pi # sinusoidal wave phase (rad)
m = [] # np.zeros((M,nbs))

for k in range(M):
    s = g * np.sin(2*pi*F0*(t-delay[k])+phase) # signal received by microphone without noise
    sq = math.sqrt(0.5*(10**(-snr/10))) # factor for fixing the snr of the signal
    wgn = np.random.randn(1, nbs) # Gauss white noise
    x = s +wgn*sq
    y = x.tolist()
    m.append(y[0])

m = mat(m) # signal received by each microphone

## plot signal
k = 2 # mic number
plt.subplot(2,1,1)
plt.plot(t,m[k].tolist()[0])
plt.xlabel('time (s)')
plt.ylabel('amplitude (linear)')
plt.title('antenna N = %d SNR = %ddB' %(k,snr))
plt.subplot(2,1,2)
plt.psd(m[2].tolist()[0],1024,Fs)
plt.show()

## phasing approach (narrow band assumption)
y = [] # fequency shift and filtering output
N = 100 # len of filter
for k in range(1,M+1):
    y.append(m[k]*np.exp(1j*2*pi*F0*t))	
    y = signal.lfilter(np.ones((1,N))/N,1,y)