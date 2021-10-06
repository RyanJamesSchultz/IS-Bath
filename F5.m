% This script creates Figure 5 from Schultz et al., [2021].
clear;

dT=1e-3;

tc=0:dT:8;
y=chirp(tc,0.1,8,1.5,'linear')+tc*0.5/max(8);
%y=ones(size(y));

T=0:dT:10;
S=zeros(size(T)); S(1:length(y))=(y+1.5)/2.5;
%S=padarray((y+1.5)/2.5,[0,length(T)-length(y)],'post');

S1=fftShift(S, 1/dT, 1);
%S2=smooth(fftShift(S, 1/dT, 4),15);

% Injection/earthquake rate information.
dt=0.05;
DT=2;
n=1000;
p=-3.5;
c=1;
Te=5;
t=-0.5:dt:20*Te;
V=zeros(size(t)); V((t>=0)&(t<=Te))=1;
N=n*V; N=abs(fftShift(N,1,DT/dt));
N(t>Te+DT)=n*(c+(t(t>Te+DT)-Te-DT)).^p;
N=N+abs(normrnd(0.0,0.5*sqrt(N))); N=1.05*(N-min(N))/n;

figure(1); clf;

subplot(121);
area(t,V); hold on;
bar(t,N);
xlabel('Time'); ylabel('Injection Rate / Earthquake Rate');
xlim([min(t) max(t)]); ylim([0 1.2]);

subplot(122);
plot(T,S1); hold on;
%plot(T,S2);
xlabel('Time (s)'); ylabel('Amplitude');
ylim([0.0 1.25]);


%PURP=[133,57,227]/256;
%subplot(122);
%plot(Tx, X, 'Color', PURP); hold on;
%plot(Tx, Cx(:,1),'-','Color','k');
%plot(Tx, Cx(:,2),'-','Color','k');
%plot(Tx, Cx(:,3),'-','Color','k');
%xlabel('Lag Time (s)'); ylabel('CC Amplitude');
%xlim([-24 24]);






