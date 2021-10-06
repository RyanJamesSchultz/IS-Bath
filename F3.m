% Scripts to test the fit of fraction data (0-100%) to a beta distribution.
% This script creates Figures 3,S6 from Schultz et al., [2021].
clear;

% Define some variables.
wc=0;
Nr=1e6;
Nmc=1e2;
f=0.90;
file='/Users/rjs10/Desktop/IS-bath/data/BnA.csv';
clean_flag='all';

% Get the data/weights and compute fraction.
[Nsti,Naft,Msti,Maft,b,ID,type,grade]=load_Data(file,clean_flag); N=Nsti+Naft;
[W,wc]=get_W(N,grade,wc);
Ras=Naft./Nsti;

% Compute the Bayesian correction factor.
cM=Naive_correction(N,b);
%cMa=Naive_correction(Naft,b);
%cMs=Naive_correction(Nsti,b);

% Linear regresssion.
xd=log10(Ras)./b;
yd=(Maft-Msti);
l=wLSQ(xd,yd,W);
xf=-3:0.1:5;
yf=polyval(l,xf);

% Compute the observed and expected trailing magnitude residual samples.
RESo=(Maft-Msti).*b-cM.*b-log10(Ras);
RESe=-log10(-log(rand([Nr 1])))+log10(-log(rand([Nr 1])));

% Create some variables important for histogram plotting.
[~,bins]=histcounts(RESo,round(1.5*sqrt(length(RESo))));
[prob,PDFe]=histcounts(RESe,round(0.1*sqrt(length(RESe))), 'Normalization', 'pdf');
PDFe=PDFe(2:end)-diff(PDFe)/2;

% Statistical tests.
[ht,pt]=ttest2(RESo(W>=wc),RESe);
[hk,pk]=kstest2(RESo(W>=wc),RESe);

% Bootstrap loop.
P=zeros([Nmc 1]);
L=zeros([Nmc 2]);
for i=1:Nmc
    I=bootstrap_Decimate(W,f);
    [~,p]=kstest2(RESo(I),RESe);
    P(i)=p;
    L(i,:)=wLSQ(xd(I),yd(I),W(I));
end



% Plot results.
figure(1); clf;

% Plot the linear regression.
x95=1.28;
subplot(121);

plot(xd,yd,'o','DisplayName','Data - All'); hold on;
I=strcmpi(type,'HF'); plot(xd(I),yd(I),'o','DisplayName','Data - HF');
I=strcmpi(type,'EGS'); plot(xd(I),yd(I),'o','DisplayName','Data - EGS');
I=strcmpi(type,'Hydrothermal'); plot(xd(I),yd(I),'o','DisplayName','Data - Hydrothermal');
I=strcmpi(type,'Disp'); plot(xd(I),yd(I),'o','DisplayName','Data - Disp');
%plot(xd(W>=wc),yd(W>=wc),'o','DisplayName','Data - Robust');
plot(xf,xf,'-k','DisplayName','1:1 Line');
plot(xf,xf+log10(exp(1)),'-k','DisplayName','Expected Relationship');
plot(xf,xf+log10(exp(1))+x95,':k','DisplayName','Expected 5/95 Percentiles');
plot(xf,xf+log10(exp(1))-x95,':k','DisplayName','Expected 5/95 Percentiles');
plot(xf,yf,'--k','DisplayName','Fitted Relationship');
xlabel('b-Scaled log_{10} Population Ratio, log_{10}(R_{AS})/b'); ylabel('Magnitude Difference, M_{after}-M_{stim}');
xlim([min(xf) max(xf)]); ylim([min(xf) max(xf)]);
legend('Location','Northwest');

% Plot the PDF comparison.
subplot(122);
histogram(RESo,bins,'DisplayName','Empirical Distribution - All','Normalization','pdf'); hold on;
histogram(RESo(W>=wc),bins,'DisplayName','Empirical Distribution - Robust','Normalization','pdf');
plot(PDFe,prob,'-k','DisplayName','Expected Distribution');
xlabel('b-Scaled Magnitude Difference Residual'); ylabel('Probability Density');
xlim([-3 +3]);
legend('Location','Northeast');

% Plot the CDF comparison.
figure(2); clf;
[Ca,Ia]=sort(RESo,'ascend');
[Cr,Ir]=sort(RESo(W>=wc),'ascend');
plot(Ca,(1:length(Ca))/length(Ca),'-o','DisplayName','Empirical Distribution - All'); hold on;
plot(Cr,cumsum(W(Ir))/sum(W(Ir)),'-o','DisplayName','Empirical Distribution - Robust');
plot(sort(RESe,'ascend'),(1:length(RESe))/length(RESe),'-k','DisplayName','Expected Distribution');
xlabel('b-Scaled Magnitude Difference Residual (M_{after}-M_{stim})'); ylabel('Cumulative Density');
xlim([-3 +3]);
legend('Location','Northwest');

% Plot the linear regression bootstrap histogram.
figure(3); clf;
subplot(121);
histogram(L(:,1)); hold on;
plot(median(L(:,1))*[1 1],ylim,'--k');
xlabel('Slope'); ylabel('Count');
subplot(122);
histogram(L(:,2)); hold on;
xlabel('y-intercept'); ylabel('Count');
plot(median(L(:,2))*[1 1],ylim,'--k');

% Plot the KS-test p-value bootstrap histogram.
figure(4); clf;
histogram(log10(P),round(0.5*sqrt(length(P)))); hold on;
xlim([min(log10(P)) log10(1)]);
plot(log10(0.05)*[1 1],ylim,'--k');
xlabel('KS-test log_{10}(p-value)'); ylabel('Count');

% Print out some stuff.
l
sqrt(cov(L))
pk
length(P(P>0.05))/length(P)


