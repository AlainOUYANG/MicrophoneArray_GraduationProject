% Hypothesis
% far field
% narrow band signal
clear all;
close all;
c=340; % sound speed (m/s)

%% signal configuration
nbs=65536; %sample number
Fs=40000; %sample frequency (Hz)
t=(0:nbs-1)/Fs; %time (s)
F0=3000; %signal frequency (Hz)
theta=60; %source direction

%% array configuration
M=8; %number of mic
d=0.05; %distance between 2 adjoining mics (m) d<lamda/2
g=ones(M,1); %propagation factor (amplitute)

delay=(0:M-1).'*d*cos(2*pi*theta/360)/c; %TDOA (s)
snr=20; %signal to noise ratio (dB)
phase=rand*2*pi; %sinusoidal wave phase (rad)
m=zeros(M,nbs);
for k=1:M
    m(k,:)=g(k)*sin(2*pi*F0*(t-delay(k))+phase)+sqrt(0.5*10.^(-snr/10))*randn(1,nbs); %signal received by each mic
end

%% plot signal
k=2; % mic number
figure
subplot(211)
plot(t,m(k,:))
xlabel('time (s)')
ylabel('amplitude (linear)')
title(['antenna N=' num2str(k) ' SNR=' num2str(snr) 'dB'])
subplot(212)
psd(m(2,:),1024,Fs) %% power spectrum magnitude of the 2nd mic signal (dB)

%% phasing approach (narrowband assumption)
y=zeros(M,nbs); % frequency shift and filtering output
N=100; % lenth of the filter
for k=1:M
    y(k,:)=m(k,:).*exp(1i*2*pi*F0*t);
    y(k,:)=filter(ones(1,N)/N,1,y(k,:)); % IIR filter
end
figure
psd(y(1,:),1024,Fs/2);

%
%na=1024; % number of angles to test
%angle=linspace(0,180,na);
%z=zeros(M,nbs);
%beam=zeros(na,1);
%%
%for l=1:na % loop on angles
%    for k=1:M % loop on mics
%        ta=(k-1)*d*(cos(2*pi*angle(l)/360))/c+(k-1)*0.000001;
 %       z(k,:)=y(k,:).*exp(-1i*2*pi*F0*ta); % weight and sum
 %   end
 %   beam(l)=cov(sum(z,1)); % mean power of all mic at each instant
%end
%figure
%plot(angle,beam)
%xlabel('angle (degree)')
%ylabel('power')
%[beam_max, angle_max_num] = max(beam);
%angle_max = (angle_max_num-1)/na*180;
%resolution = abs(angle_max-theta)