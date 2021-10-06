% Scripts to test the fit of fraction data (0-100%) to a beta distribution.
% This script creates Figures 2,S4,S5 from Schultz et al., [2021].
clear;

% Define some variables.
wc=0;
Nr=1e4;
Nmc=1e3;
f=0.90;
file='TableS1.csv';
clean_flag='count';

% Get the data/weights and compute fraction.
[Nsti,Naft,Msti,Maft,b,ID,type,grade]=load_Data(file,clean_flag); N=Nsti+Naft;
[W,wc]=get_W(N,grade,wc);
Rs=Nsti./N;

% Filter on type?
%I=strcmpi(type,'HF');
%Nsti=Nsti(I); Naft=Naft(I); N=N(I); Msti=Msti(I); Maft=Maft(I); b=b(I); ID=ID(I); type=type(I); grade=grade(I); Rs=Rs(I); W=W(I);

% Random distribution.
v1=rand([Nr 1]);
v2=rand([Nr 1]);
Rrand=(v1./(v1+v2));

% Compute some stats.
[Mav,M50,Beta1]=get_Rstats(Rs,W,wc);
[  ~,  ~,Beta2]=get_Rstats(Rs,ones(size(Rs)),0);

% Bootstrap loop.
Mav_mc=zeros([Nmc 1]);
M50_mc=Mav_mc;
P=Mav_mc;
Beta_mc=zeros([Nmc 2]);
for i=1:Nmc
    I=bootstrap_Decimate(W,f);
    [mav,m50,beta]=get_Rstats(Rs(I),W(I),wc);
    Mav_mc(i)=mav;
    M50_mc(i)=m50;
    Beta_mc(i,:)=beta;
    
    [~,p]=kstest2(Rs(I),Rrand);
    P(i)=p;
end
Beta3=median(Beta_mc);

% Get histogram bin edges.
[~,bins]=histcounts([0;1;Rs],round(2*sqrt(length(Rs))));

% Compute the beta distribution PDF.
xf=0.00:0.01:1.00; xf(1)=[]; xf(end)=[];
B1=betapdf(xf,Beta1(1),Beta1(2));
B2=betapdf(xf,Beta2(1),Beta2(2));
B3=betapdf(xf,Beta3(1),Beta3(2));



% Plot results.
figure(1); clf;

% plot R histogram.
subplot(221);
histogram(Rs*100,bins*100,'DisplayName','Histogram - All','Normalization','pdf'); hold on;
histogram(Rs(W>=wc)*100,bins*100,'DisplayName','Histogram - Robust','Normalization','pdf');
histogram(Rrand*100,bins*100,'DisplayName','Histogram - Random','Normalization','pdf');
plot(xf*100,B2/100,'DisplayName','Beta Fit - All');
%plot(xf*100,B1*dx,'DisplayName','Beta Fit - Robust');
plot(xf*100,B3/100,'DisplayName','Beta Fit - Bootstrap');
xlabel('Fraction of Earthquakes that Occur During Stimulation, R_S (%)'); ylabel('Probability Density');
xlim([0 100]); ylim([0 0.10]);
plot(median(Mav_mc)*[1 1]*100,ylim(),':k','DisplayName','Mean');
plot(median(M50_mc)*[1 1]*100,ylim(),'--k','DisplayName','Median');
legend('Location','Northwest');

% Plot the beta distribution fitted parameters scatterplot.
subplot(222);
plot(Beta_mc(:,1),Beta_mc(:,2),'o'); hold on;
xlim([0 1.1*max(Beta_mc(:,1))]); ylim([0 1.1*max(Beta_mc(:,2))]);
plot(Beta3(1),Beta3(2),'o','MarkerEdgeColor','k','MarkerFaceColor','r');
plot(Beta3(1)*[1 1],ylim,'--k');
plot(xlim,Beta3(2)*[1 1],'--k');
xlabel('Bootstrapped Parameter \alpha'); ylabel('Beta Distribution Parameter \beta');

% Plot the alpha histogram.
subplot(223);
histogram(Beta_mc(:,1)); hold on;
xlabel('Bootstrapped Parameter \alpha'); ylabel('Count');
xlim([0 1.1*max(Beta_mc(:,1))]);
plot(Beta3(1)*[1 1],ylim,'--k');

% Plot the beta histogram.
subplot(224);
h=histogram(Beta_mc(:,2)); hold on;
xlabel('Bootstrapped Parameter \beta'); ylabel('Count');
xlim([0 1.1*max(Beta_mc(:,2))]);
plot(Beta3(2)*[1 1],ylim,'--k');
%rotate(h,90,0);

% Plot the Rs mean/median bootstrap stats.
figure(2); clf;
subplot(121);
histogram(Mav_mc,round(0.5*sqrt(length(Mav_mc)))); hold on;
plot(median(Mav_mc)*[1 1],ylim,'--k');
xlabel('Mean Rs'); ylabel('Count');
subplot(122);
histogram(M50_mc,round(0.5*sqrt(length(M50_mc)))); hold on;
xlabel('Median Rs'); ylabel('Count');
plot(median(M50_mc)*[1 1],ylim,'--k');

% Plot the KS-test p-value histogram.
figure(3); clf;
histogram(log10(P),round(0.5*sqrt(length(P)))); hold on;
xlim([min(log10(P)) log10(1)]);
plot(log10(0.05)*[1 1],ylim,'--k');
xlabel('KS-test log_{10}(p-value)'); ylabel('Count');

% Print out some stuff.
[~,I]=sort(Rs);
ID(I)
median(Mav_mc)
median(M50_mc)
mean(Beta_mc)
median(Beta_mc)
cov(Beta_mc)
