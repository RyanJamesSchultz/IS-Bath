function [Mav,M50,b_fit]=get_Rstats(Rs,W,wc)
  % Simple function to get the Rs statistics.
  %
  % Written by Ryan Schultz.
  
  % Normalize the weights.
  wn=sum(W);
  W=W/wn;
  wc=wc/wn;
  
  % Compute the stats
  Mav=mean(Rs(W>=wc));
  M50=median(Rs(W>=wc));
  b_fit=betafit(Rs(W>=wc));
  
return