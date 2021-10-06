function [W,n]=get_W(N,grade,cutoff)
  % Simple function to get the weights of the data.
  %
  % Written by Ryan Schultz.
  
  % Predefine the power.
  pow=1/4;
  
  % Compute population count weights and cutoff.
  W=(N).^pow;
  n=(cutoff).^pow;
  
  % Modify weights based on grade.
  wg=zeros(size(W));
  I=strcmpi('A',grade); wg(I)=1.1;
  I=strcmpi('B',grade); wg(I)=1.0;
  I=strcmpi('C',grade); wg(I)=0.9;
  W=W.*wg;
  
return