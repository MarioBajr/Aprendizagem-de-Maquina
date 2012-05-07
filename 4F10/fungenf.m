function [trainf,testf]=fungenf(Nr,Nt,xgen,funtype,tp,xorder)
% Usage: [trainf,testf]=fungenf(Nr,Nt,xgen,funtype,tp,xorder)
% fungen.m - generating 1D functions in [-0.5 .5]
%  Input: Nr, Nt - number of training and testing samples
%  sampling point may be randomly drawn or regular spaced.
%   sine - specifying frequency, phase
%   piecewise linear - specify end points
%   polynomial - specify coefficients
% results are stored in trainf, and testf
% Nr, Nt: # of training, testing samples. Nt = 0 means only trainf is generated
% xgen: = 0: regular spacing, = 1 random space sampling
% tp: parameter list
% funtype=1 (sinusoidal)
%  tp(1)=fre= frequency (0 < f < 1)
%  tp(2)=phi= phase (between -0.5 and 0.5)
% funtype=2 (piecewise linear)
%  tp= coordinates (-0.5 and 0.5) x(i)s must be multiple of 1/100s');
%    [x(1) y(1) x(2) y(2) ... x(n) y(n)] = (-0.5 < x(1) < x(n) < 0.5) '
%    remember to use bracket []
% funtype=3 (polynomial)  **** note modified 2/12/2001 add tp(1)
%  there are two choices pform=1 coefficients, pform=2 roots
%  tp= [1 polynomial coefficients a(1)x^n + a(2) x^(n-1) + ... + a(n+1)]
%    enclosed in a bracket (entered as a vector)  or
%    = [2 root1 root2 ... root n]
% xorder= 0 for extrapolation and 1 or 2 for interpolation
%   applicable only when samples are regularly spaced, and Nt > 0. 
%	 xorder = 0: testing samples extrapolates from training samples
%   xorder = 1: testing samples interlaced randomly with training samples
%   xorder = 2: testing samples regularly interlaced with training samples
%   
% copyright (c) 1996 by Yu Hen Hu
% created 9/22/96
% Modified: 3/17/2000, 2/11/2001, 2/23/2001

if nargin ==5, % xorder not specified
   xorder=1;
end

N=Nr+Nt;  % total number of points to be generated
if xgen==0, % regularly spaced samples
   dN=round(1000/(N-1))*0.001;
   x=[0:dN:dN*(N-1)]'-0.5;   % x is N by 1
elseif xgen==1,  % randomly sampled data point within [-.5 to .5]
   x=sort(rand(N,1)-0.5);
end

if funtype==1,  % sine function
   fre=tp(1); phi=tp(2);
  y=cos((4*pi*fre*x)+phi);   %  y is N by 1
end
if funtype ==2, % piecewise linear function
   p=tp;
   npt=length(p); 
   if rem(npt,2)==1, 
      error('must have even number of points, break'); 
   end
   p=reshape(p,2,npt/2); npt=npt/2;  % p is 2 by npt now
   % extend two ends to [-.5 .5]
   if p(1,1) > x(1),
      p(2,1)=(p(2,2)-p(2,1))*(x(1)-p(1,1))/(p(1,2)-p(1,1))+p(2,1);
      p(1,1)=x(1);
   end
   if p(1,npt) < x(N),
      p(2,npt)=(p(2,npt)-p(2,npt-1))*(x(N)-p(1,npt-1))/(p(1,npt)-p(1,npt-1))+p(2,npt-1);
      p(1,npt)=x(N);
   end
   x=sort(x); y=[]; n1=0;
   for i=1:npt-1,
      n2=max(find(x <= p(1,i+1)));
      tmpx=x(n1+1:n2);  n1=n2;
      y=[y;(p(2,i+1)-p(2,i))*(tmpx-p(1,i))/(p(1,i+1)-p(1,i))+p(2,i)];
   end
end   
if funtype==3,  % polynomial function
   n1=length(tp);
   if n1 <2,
      error('the parameter for polynomial must >=2');
   end
   
   if tp(1)==1, % enter coefficients
      acoef=tp(2:n1);
      n=n1-1; % polynomial order is n-1
      y=acoef(1);
      if n>1,
         for i=1:n-1,
            y=y.*x+acoef(i+1);
         end
      end
   elseif tp(1)==2,
      aroot=tp(2:n1);
      n=length(aroot); % polynomial order is n
      y=ones(size(x));
      for i=1:n,
         y=y.*(x-aroot(i));
      end
   end
end

% generate training and testing data set
if xgen==0 & Nt > 0, % for regularly spaced data samples, and when testing
   % samples are needed
   if xorder==0, % test data samples are extrapolation from training sample
      tmp=[x y];
      trainf=tmp(1:Nr,:);       % training set
      testf=tmp(Nr+1:N,:);  % testing set
   elseif xorder ==1, % test samples randomly interlaced with training samples
      tmp=randomize([x y]);
      trainf=tmp(1:Nr,:); 
      testf=tmp(Nr+1:N,:); 
   elseif xorder==2,  % test samples interlaced regularly with training samples
      ridx=round([1:N/Nr:N]);
      tidx=setdiff([1:N],ridx); % testing set index
      tmp=[x y];
      trainf=tmp(ridx,:); 
      testf=tmp(tidx,:);
   end
else % just randomly place traing and testing set
   tmp=randomize([x y]);
   trainf=tmp(1:Nr,:); 
   testf=tmp(Nr+1:N,:); 
end