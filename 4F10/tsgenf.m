function [x,train,test]=tsgenf(nmax,nr,tstype,nstep,nlag,a)
% Usage: [x,train,test]=tsgenf(nmax,nr,tstype,nstep,nlag,a)
% tsgenf.m: generate data for time series prediction 
% callable version of tsgen.m
% generate logistic map time series or nonlinear rounding time series
% tstype
%       =0:  (default) AR(1) time series  x(n) = a*x(n-1) + u(n), u(n)~N(0,1)
%       =1:  Logistic map time series demo
%            x(n) = a*x(n-1)*(1-x(n-1))
%            due to Ulam (1957), 
%            when a = 4, we have a deterministic chaos
%       =2:  nonlinear time series: x(n) = a*x(n-1) mod 1
% nmax=length of time series
% nr=length of this sequence used for training
% tstype=1 for logistic, 2 for rounding time series (default=1)
% nstep=n step prediction, default n = 1
% nlag=# of past samples used for prediction (default = 1)
% a: parameter
%
% train: nr-nlag-nstep+1 by nlag+1 corresponds to x(1:nr)
% test:  nmax-nr by nlag+1, corresponds to x(nr-nlag-nstep+2:nmax)
%
% train=[x(1)      x(2)       ... x(nlag)       |  x(nlag+nstep)]
%       [x(2)      x(3)       ...               |               ]
%       [x(nr-nlag-nstep)     ... x(nr-nstep-1) |       x(nr-1) ]
%       [x(nr-nlag-nstep+1)   ... x(nr-nstep)   |        x(nr)  ]
%
%  test=[x(nr-nlag-nstep+2)   ... x(nr-nstep+1) |        x(nr+1)]
%       [                     ...               |               ]
%       [x(nmax-nlag-nstep+1)     x(nmax-nstep) |        x(nmax)]
%
% copyright (C) 2000 by Yu Hen Hu
% created: 4/12/2000
% modified: 10/28/2001 to allow parameter a to be passed, and 
%         ensure the time series is zero mean
%         the order of the inputs are also changed.

if nargin<5,    nlag=1; end 
if nargin<4,    nstep=1; end
if nargin<3,    tstype=1; end
if nargin<6, % check for a value
   if tstype==0,
      a=input('auto-correlation coefficient (0 < a < 1) = ');
   elseif tstype==1,
      a=input('lambda for the logistic map time series (default = 4) = ');
   elseif tstype==2,
      a=input('multiplier factor = ');
   end
end
  
rand('seed',sum(100*clock));

% generate time series
switch tstype
case 0, % AR(1) time series
   randn('seed',sum(100*clock));
   u=randn(1,nmax); % N(0,1)
   x(1)=u(1);
   for i=2:nmax,
      x(i)=a*x(i-1)+u(i);
   end
   x=x-mean(x); % make it zero mean
case 1,  % logistic time series
   if isempty(a), a=4; end
   x(1)=rand;
   for i=2:nmax,
      x(i) = a*x(i-1)*(1-x(i-1));
   end
case 2,
   x(1)=rand;
   for i=2:nmax,
      x(i) = a*x(i-1); x(i)=x(i)-floor(x(i));
   end
end % switch

% reshape into train and test matrices
tmp=hankel(x(1:nmax-nlag-nstep+1),x(nmax-nlag-nstep+1:nmax));
tmp=tmp(:,[[1:nlag] nlag+nstep]);
train=tmp(1:nr-nlag-nstep+1,:);
test=tmp(nr-nlag-nstep+2:nmax-nlag-nstep+1,:);
