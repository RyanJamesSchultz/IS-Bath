function [Rs,Ras,dT,Ts,f,tau]=get_Rsyn(Theta,Nr)
  % Simple function to compute the synthetic Rs statistics.
  %
  % Written by Ryan Schultz.
  
  % Take values out of the input array.
  dTm=Theta(1);
  dTs=Theta(2);
  Ts=Theta(3);
  fm=Theta(4);
  fs=Theta(5);
  taum=Theta(6);
  taus=Theta(7);
  
  % Some parameters.
  dT=lognrnd(log(dTm),dTs,[1 Nr]);
  Ts=Ts*ones(size(dT));
  f=abs(normrnd(fm,fs,[1 Nr]));
  tau=lognrnd(log(taum),taus,[1 Nr]);
  
  % Aftershock/stimulation count ratio.
  %Ras=(dT+f*c/(p-1))/Ts; % Modified-Omori.
  Ras=(dT+f.*tau)./Ts; % Exponential.
  
  % Stimulation/total count ratio.
  Rs=1./(1+Ras);
  
return