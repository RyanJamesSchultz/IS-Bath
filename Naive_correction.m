function [c]=Naive_correction(N,b)
  % Simple function to compute the correction factor for the naive maximum 
  % magnitude calculation. See van der Elst et al., [2016] 
  % (Sections 2.2 & A4) for more information.
  %
  % Reference:
  %
  % N.J. Van der Elst, M.T. Page, D.A. Weiser, T.H. Goebel, & S.M. Hosseini, (2016). 
  % Induced earthquake magnitudes are as large as (statistically) expected. 
  % Journal of Geophysical Research: Solid Earth, 121(6), 4575-4590.
  % doi: 10.1002/2016JB012818.
  %
  % Written by Ryan Schultz.
  
  % Vectorized computation of arbitrary correction factors.
  n=1:max(N);
  ct=log10(n)-cumsum(log10(n))./n;
  
  % Subset to just the ones asked for.
  c=interp1(n,ct,N,'linear')./b;
  
return