% Scripts to test sensitivity of Rs parameters via MCMC.
% This script creates Figure 4 from Schultz et al., [2021].
clear;

% Predefine some values.
Nr=1e3;
Niter=1e5;
file='/Users/rjs10/Desktop/IS-bath/data/BnA.csv';
clean_flag='count';

% Simple metrics.
dT=1/24;
Ts=14;
f=1.0;
tau=3;
Ras=(dT+f*tau)/Ts;
Rs=1/(1+Ras)

% Decent starting point.
Mi=[0.01 3.8 14 1.0 0.10 0.01 2.0]';
dM=[0.01 0.2  0 0.1 0.01 0.01 0.2]';
Mb=[   0   0 13   0    0    0   0; 1 5 15 1.5 0.25 15 5]';

% Emprical count ratios.
[Nsti,Naft,~,~,~,~,~,~]=load_Data(file,clean_flag); Rs_d=Nsti./(Nsti+Naft);

% Monte Carlo Markov Chain solution for best parameter fits.
[soln,count]=RSmcmc(@get_Rsyn,Rs_d,Mi,dM,Mb,Niter,Nr);
M=[soln.m]';
w=10.^[soln.L]'; w=w.^2; w=w/sum(w);
Ms=sum(w.*M);
Ms

% Best synthetic count ratios.
[Rs_s,~,dT,Ts,f,tau]=get_Rsyn(Ms,Nr);

% Fit to a beta distribution.
[mav,m50,beta]=get_Rstats(Rs_s,ones(size(Rs_s)),0);
xf=0.00:0.01:1.00; xf(1)=[]; xf(end)=[];
Bf=betapdf(xf,beta(1),beta(2));
beta

% Kolomogorov-Smirnov test between empirical and synthetic data.
[~,p]=kstest2(Rs_s,Rs_d);
p

% Get histogram bin edges.
[~,bins]=histcounts([0;1;Rs_d],round(2*sqrt(length(Rs_d))));

% Plot.
figure(1); clf;

subplot(231);
histogram(dT,round(sqrt(length(dT))),'DisplayName','Histogram - Random','Normalization','pdf');
xlabel('Lag Time, \DeltaT (days)'); ylabel('Probability Density');
set(gca,'YScale','log');

subplot(232);
histogram(f,round(sqrt(length(f))),'DisplayName','Histogram - Random','Normalization','pdf');
xlabel('Rate Change Factor, f (-)'); ylabel('Probability Density');

subplot(233);
histogram(tau,round(sqrt(length(tau))),'DisplayName','Histogram - Random','Normalization','pdf');
xlabel('Mean Relaxation Time, \tau (days)'); ylabel('Probability Density');
set(gca,'YScale','log');

subplot(2,3,[4 5 6]);
histogram(Rs_d*100,bins*100,'DisplayName','Histogram - Empirical','Normalization','pdf'); hold on;
histogram(Rs_s*100,bins*100,'DisplayName','Histogram - Synthetic','Normalization','pdf');
plot(xf*100,Bf/100,'DisplayName','Beta Fit - Synthetic');
xlabel('Fraction of Earthquakes that Occur During Stimulation, R_S (%)'); ylabel('Probability Density');
legend('Location','Northwest');



