function [p]=wLSQ(x,y,w)
  % Simple function to compute the weighted linear regression.
  %
  % Written by Ryan Schultz.
  
  % Make column vectors.
  x=x(:);
  y=y(:);
  w=w(:);
  
  % Normalize the weights.
  w=w/sum(w);
  
  % Make the kernel matrix G.
  G=[x,ones(size(x))];
  W=diag(w);
  
  % Invert for p.
  p=(G'*W*G)\(G'*W*y);
  p=p';
  
return