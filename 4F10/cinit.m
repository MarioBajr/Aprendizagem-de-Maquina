function [w,c]=cinit(x,method,c)
% Usage: [w,c]=cinit(x,method,c)
% initialization for clustering, performed interactively
% copyright (C) 2000 by Yu Hen Hu
% created: 3/18/2000
% x: k by n data samples
% method:= 1, 2, 3
% c: # of clusters. If missing, will be asked.
% Method 1. centroid + random perturbation
% Method 2. random evenly distributed over the spread of data samples
% Method 3. svd based projecting to subspaces: may assign values of c
% assume there are more than one sample
% call c1d.m 

[k,n]=size(x);
if k==1,
   w=x;
   return
end

if nargin < 3 & method ~= 3,
   c=input('# of clusters = ');
end
switch method
case 1,  % Method 1. centroid + random perturbation
   xmean=mean(x);
   w=ones(c,1)*xmean+0.01*randn(c,n);
case 2,  % Method 2. spread into entire space of x
   xmax=max(x); xmin=min(x); d=xmax-xmin;
   w=rand(c,n)*diag(d)+ones(c,1)*xmin;
case 3,  % Method 3. Projecting into principal components
   [u,s,v]=svd(x);
   y=x*v(:,1); % projecting into n principal axises
   [w,c]=c1d(y);   
end