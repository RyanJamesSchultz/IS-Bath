function [I]=bootstrap_Decimate(W,f)
  % Simple function to find which vector indicies to keep during a 
  % weighted bootstrap analysis.
  %
  % Written by Ryan Schultz.
  
  % Normalize the weights.
  W=W/sum(W);
  
  % Compute some variables of importance.
  n=round(f*length(W));
  N=1:length(W);
  W=cumsum(W);
  
  % Find the indcies that should be kept.
  Rk=rand([1 n]);
  I=ceil(interp1(W,N,Rk,'nearest',length(W)));
  
return