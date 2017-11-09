% Hypothesis
% far field
% narrow band signal
clear all;
close all;
c=340; % sound speed (m/s)

%% signal configuration
nbs=65536 %sample number
Fs=40000; %sample frequency (Hz)
t=(0:nbs-1)/Fs; %time (s)
F0=3000; %signal frequency (Hz)
theta=30; %source direction

%% array configuration
M=10; %number of mic
d=0.05; %distance between 2 adjoining mics (m) d<lamda/2
g=ones(M,1); %propagation factor (amplitute)

delay=(0:M-1).'*d*cos(2*pi*theta/360)/c; %TDOA (s)
snr=20; %signal to noise ratio (dB)
phase=rand*2*pi; %sinusoidal wave phase (rad)
m=zeros(M,nbs);
for k=1:M
    m(k,:)=g(k)*sin(2*pi*F0*(t-delay(k))+phase)+sqrt(10.^(-snr/10))*randn(1,nbs); %signal received by each mic
end

%% plot signal
k=2; % mic number
figure
subplot(211)
plot(t,m(k,:))
xlabel('time (s)')
ylabel('amplitude (linear)')
title(['antenna N=' num2str(k) 'SNR=' num2str(snr) 'dB'])
subplot(212)
psd(m(1,:),4096,Fs) %% power spectrum magnitude of the 2nd mic signal (dB)

%% correlation approach (no narrowband assumption)
k1=1;
k2=2;
nt=round(Fs/F0); % round取整，nt不懂
cor=zeros(1,nt);
for tau=0:nt-1 % tau相当于p，cor是tau的函数
    cor(tau+1)=(m(k1,1:nbs-tau)*m(k2,tau+1:nbs)')/(nbs); % use the feature of matrix multipllication to accomplish addition
end
cor=cor/sqrt(cov(m(k1,:)))/sqrt(cov(m(k2,:))); % normalisation 不懂
figure
plot((0:nt-1)/Fs,cor)
xlabel('delay (s)')
ylabel('correlation')
