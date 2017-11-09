%hypothesis
% far field
% narrow band (time delay => phase delay)
clear all
close all
c= 340 ; % sound speed (m/s)

%% signal configuration
nbs=65536 % sample number
Fs=40000 ; %Sampling frequency (Hz)
t=(0:nbs-1)/Fs; % time (s)
fo=3000; % frequency (Hz)
theta=30; %source position (-90degree to 90degree)

%% array configuration
M=10;  %antenna number
d= 0.05;  % distance between antennas (m)
g=ones(M,1); %antenna gain (amplitude)

delay=(0:M-1).'*d*sin(2*pi*theta/360)/c; %delay (s) assuming far field hypothesis
snr=20 ; % signal to noise ratio (dB)
phase=rand*2*pi; %sine wave phase
x=zeros(M,nbs);
for k=1:M
    x(k,:)=g(k)*sin(2*pi*fo*(t-delay(k))+phase)+sqrt(10.^(-snr/10))*randn(1,nbs);
end

%% plot signal
k=2; %antenna number
figure
subplot(2,1,1)
plot(t,x(k,:))
ylabel('amplitude (linear)')
xlabel('time (s)')
title(['antenna n°' num2str(k) ' SNR=' num2str(snr) 'dB'])
subplot(2,1,2)
psd(x(1,:),1024,Fs)

%% correlation approach (no narrow band assomption)
k1=1; % first antenna number
k2=2; % second antenna number
nt=round(Fs/fo) ; %number of delay
cor=zeros(1,nt);
for tau=0:nt-1
    cor(tau+1)=(x(k1,1:nbs-tau)*x(k2,tau+1:nbs)')/(nbs-tau);
end
cor=cor/sqrt(cov(x(k1,:)))/sqrt(cov(x(k2,:))); %normalisation
figure
plot((0:nt-1)/Fs,cor)
xlabel('delay (s)')
ylabel('correlation)')

%% phasing approach (narrow band assomption)
y=zeros(M,nbs);% frequency shift and filtering output
N=100; % length of the filter
for k=1:M
    y(k,:)=x(k,:).*exp(-1i*2*pi*fo*t);
    y(k,:)=filter(ones(1,N)/N,1,y(k,:));
end
figure
psd(y(1,:),1024,Fs)

na=1024; %nb of angles to test
angle=linspace(-90,90,na);
z=zeros(M,nbs);
beam=zeros(na,1);
for l=1:na %loop on angles  
    for k=1:M % loop on antennas
        ta=(k-1)*d*sin(2*pi*angle(l)/360)/c;
        z(k,:)=y(k,:).*exp(1i*2*pi*fo*ta);
    end
    beam(l)=cov(sum(z,1)); %mean power of the sum of all antenna at each instant
end

figure
plot(angle,beam)