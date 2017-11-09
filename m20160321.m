nbs=8192; % number of sampling
f0=1000; % source frequncy Hz
Ts=1/10000; % sample period s
Fs=1/Ts; % sample frequncy Hz
c=340; % sound speed m/s
L=12; % lenth of the array m
d=0.12; % distance between 2 adjoining microphones m
N=L/d+1; % number of microphones
k=(0:nbs-1)*Ts; % time s
%s=sin(2*pi*f0*k+rand*2*pi); % source signal
n0=randn(1,nbs); % Gauss white noise
a=0.5; % propagation factor
b=0.1; % Gauss noise factor
y=0;
theta=pi/2; % source direction rad
t=d*cos(theta)/c; % TDOA between 2 adjoining microphones
for i=1:N
    m=a*sin(2*pi*f0*(k+(i-1)*t))+b*n0; % signal received by the Nth microphone
    y=y+m; % signal non-beamformed
end
yb=N*m; %signal beamformed
pysum=0;
for j=1:N
    pysum=pysum+abs(y(j))^2;
end
py=pysum/N % power for the signal non-beamformed
pybsum=0;
for j=1:N
    pybsum=pybsum+abs(yb(j))^2;
end
pyb=pybsum/N % power of the signal beamformed