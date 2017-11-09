nbs=8192; % number of sampling
% x=5;y=10; % source position m
f0=1000; % source frequency Hz
Ts=1/10000; % sampling period s
Fs=1/Ts; % sampling frequency Hz
c=340; % sound speed m/s
d=0.25;% distance between 2 microphones m
k=0:Ts:(nbs-1)*Ts;% time s
s=sin(2*pi*f0*k); % sound signal
%subplot(211);plot(k,s);xlabel('k');ylabel('s(k)');
%t=sqrt(x*x+y*y)/c;
%t=d*x/(c*sqrt(x*x+y*y));
theta=-90:180/nbs:90-180/nbs;
t=d*cos(theta)/c; % TDOA between the first microphone and the second one
n0=randn(1,nbs); % Gauss white noise
a=0.5; % propagrate factor
b=0.1; % Gauss white noise factor
m1=a*sin(2*pi*f0*k)+b*n0; % signal received by the 1st microphone
m2=a*sin(2*pi*f0*(k+t))+b*n0; % signal received by the 2nd microphone
m3=a*sin(2*pi*f0*(k+2*t))+b*n0; % signal received by the 3rd microphone
y1=3*m1;
psum=0;
for i=1:nbs
    psum=psum+y1(i)*y1(i);
end
py=psum/(nbs-1);
plot(theta,py);xlabel('theta');ylabel('Power of y1');
