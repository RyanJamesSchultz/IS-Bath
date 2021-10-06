% This script creates Figure 1 from Schultz et al., [2021].
clear;

% Maximum magnitude information.
q=0:1e-3:1.0;
CDFm=-log10(-log(q));
PDFm=diff(q)./diff(CDFm);

% Bath's law information.
Nr=1e7;
RESb=-log10(-log(rand([Nr 1])))+log10(-log(rand([Nr 1])));
[prob,PDFb]=histcounts(RESb,round(0.1*sqrt(length(RESb))), 'Normalization', 'pdf');
PDFb=PDFb(2:end)-diff(PDFb)/2;
CDFb=sort(RESb);

% Injection/earthquake rate information.
dt=0.05;
DT=0.4;
n=1000;
p=-2.2;
c=1;
T=5;
t=-0.5:dt:2*T;
V=zeros(size(t)); V((t>=0)&(t<=T))=1;
N=n*V; N=abs(fftShift(N,1,DT/dt));
N(t>T+DT)=n*(c+(t(t>T+DT)-T-DT)).^p;
N=N+abs(normrnd(0.0,0.5*sqrt(N))); N=1.05*(N-min(N))/n;

% Plot.
figure(1); clf;

%Panel A.
subplot(2,4,[1 2]);
plot(CDFm(2:end)+3,PDFm); hold on;
plot(CDFm(2:end)+4,PDFm);
plot(CDFm(2:end)+5,PDFm);
plot(CDFm+3,q);
plot(CDFm+4,q);
plot(CDFm+5,q);
xlabel('Magnitude'); ylabel('Probability Density / Cumulative Density');
xlim([2 7]); ylim([0 1]);

%Panel B.
subplot(2,4,[5 6]);
plot(PDFb-1,prob); hold on;
plot(PDFb+0,prob);
plot(PDFb+1,prob);
plot(CDFb-1,(1:Nr)/Nr);
plot(CDFb+0,(1:Nr)/Nr);
plot(CDFb+1,(1:Nr)/Nr);
xlabel('Magnitude Difference, \DeltaM'); ylabel('Probability Density / Cumulative Density');
xlim([-3 +3]); ylim([0 1]);

% Panel C.
subplot(2,4,[3 4 7 8]);
area(t,V); hold on;
bar(t,N);
xlabel('Time'); ylabel('Injection Rate / Earthquake Rate');
xlim([min(t) max(t)]); ylim([0 1.2]);




