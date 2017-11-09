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
theta=45; %source direction

%% array configuration
M=20; %number of mic
d=0.1; %distance between 2 adjoining mics (m)
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
psd(m(1,:),1024,Fs) % power spectrum magnitude of the 2nd mic signal (dB)

%% correlation approach (no narrowband assumption)
k1=1;
k2=2;
nt=round(Fs/F0); % 一个周期内的采样点数
cor=zeros(1,nt);
for tau=0:nt-1 % tau相当于p，cor是tau的函数
    cor(tau+1)=(m(k1,1:nbs-tau)*m(k2,tau+1:nbs)')/(nbs-tau); % use the feature of matrix multipllication to accomplish addition
end
cor=cor/sqrt(cov(m(k1,:)))/sqrt(cov(m(k2,:))); % normalisation 不懂
figure
plot((0:nt-1)/Fs,cor)
xlabel('delay (s)')
ylabel('correlation')

%% phasing approach (narrowband assumption)
y=zeros(M,nbs); % frequncy shift and filtering output
N=100; % lenth of the filter
for k=1:M
    y(k,:)=m(k,:).*-exp(1i*2*pi*F0*t);
    y(k,:)=filter(ones(1,N)/N,1,y(k,:));
end
figure
psd(y(1,:),1024,Fs)

na=1024; % number of angles to test
angle=linspace(0,180,na);
z=zeros(M,nbs);
beam=zeros(na,1);
for l=1:na % loop on angles
    for k=1:M % loop on mics
        ta=(k-1)*d*cos(2*pi*angle(l)/360)/c;
        z(k,:)=y(k,:).*exp(-1i*2*pi*F0*ta);
    end
    beam(l)=cov(sum(z,1)); % mean power of all mic at each instant
end

figure
plot(angle,beam)