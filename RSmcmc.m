function [soln, count] = RSmcmc(Gfunc,d,m0,dm,mb,Niter,varargin)
  % Subroutine for MCMC sampling - Ryan Schultz.
  %
  % Inputs:
  % Gfunc = forward problem function handle
  % d = vector of observations
  % m0 = initial estimate of parameter vector
  % dm = step size in all parameter directions
  % mb = bounds (vector of upper and lower bounds)
  % Lfunc = Log-likelihood function handle
  % Niter = number of iterations
  %
  % Output structure:
  % m = Kept sample.
  % L = Log-likelihood of kept sample.
  % count = number of accepted. Acceptance ratio is count/Niter
  
  % Make a solution structure and initialize.
  soln=struct('m',[],'L',[],'d',[]);
  j=1;
  
  % Compute the forward problem and log-likelihood of the posterior.
  d0=Gfunc(m0,varargin{:});
  [~,p]=kstest2(d,d0); L0=log10(p);
  
  % Save the given sample details.
  soln(j).m=m0; soln(j).L=L0; soln(j).d=d0;
  
  % Loop for the number iterations asked for.
  for i=1:Niter
      
      % Randomly walk to a new solution.
      r=2*rand(size(m0))-1;
      m1=m0+(r.*dm);
      %m1
      %max(mb,[],2)'
      %(m1>max(mb,[],2)')
      %(m1<min(mb,[],2)')
      
      % Reject this sample if we're outside of the bounds.
      if( any((m1>max(mb,[],2))|(m1<min(mb,[],2))) )
          continue;
      end
      
      % Compute the forward problem and log-likelihood of the posterior.
      d1=Gfunc(m1,varargin{:});
      [~,p]=kstest2(d,d1); L1=log10(p);
      
      % Check if the new sample is worse.
      if( L1<L0 )
          % If it is worse, roll a saving throw.
          if( (L1-L0)<log(rand()) )
              continue; % Reject if saving throw is failed.
          end
      end
      
      % Iterate and save the new sample.
      j=j+1; m0=m1; d0=d1; L0=L1;
      soln(j).m=m0; soln(j).L=L0; soln(j).d=d0;
      
  end
  
  % Get the number of accepted samples.
  count=j;
  
return;