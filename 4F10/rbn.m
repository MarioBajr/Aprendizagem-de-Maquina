function [w,xi,sigma]=rbn(x,d,xi,lambda,type)
% Usage: [w,xi,sigma]=rbn(x,d,xi,lambda,type)
% x: training feature vectors, K by m
% F(x) = sum_i=1^c w(i) phi(x-xi(i))
% phi(x-xi)=exp(-(1/2sigma^2(i))*|x-xi|^2): Gaussian kernel
% G: k by c+1 radial basis neuron output of x 
% w = pinv(G)*d: weights of output layer, c+1 by n
% xi: clustering centers, code book:  c by m
%   if type=1, each xi is one of the training sample
%   if type=2, each xi is a cluster center of the training samples
% d: k by n, desired output at the cluter centers
% lambda: A smoothing constant so that 
%  w = inv(G'*G + lambda*G0)*G'*d, default: lambda=0.
% call kmeansf.m, kmeantest.m, gauss.m
% copyright (c) 1996-2000 by Yu Hen Hu
% created 10/16/96
% modified: 3/17/2000, 2/19/2001

if nargin==3,
   lambda=0;
end
[c,m]=size(xi);  % c: # of code words, m: feature dimension
[k,m]=size(x);   % k: # of training samples 
[k,n]=size(d);   % n: output dimension

% determine sigma, and if type 2, new xi
if type==1,
   sigma=0.5*(max(max(xi))-min(min(xi)))/c*ones(1,c);
elseif type==2,
   sigma=zeros(m,m,c);
   [err,member]=kmeantest(x,xi); % find the membership
   % compute sigma matrices and update xi
   deletelist=[];
   for i=1:c,
      idx=find(member==i); Ni=length(idx);
      if Ni>0,
         if Ni>1,
            xi(i,:)=mean(x(idx,:));
         elseif Ni==1,
            xi(i,:)=x(idx,:);
         end
         sigma(:,:,i)=(x(idx,:)-ones(Ni,1)*xi(i,:))'*(x(idx,:)-ones(Ni,1)*xi(i,:))/Ni+eye(n);
      elseif Ni==0, % if xi has no training samples associated, delete it
         deletelist=union(deletelist,i); 
      end
   end
   if isempty(deletelist)==0, % deletelist is not empty
      idx=setdiff([1:c],deletelist);
      xi=xi(idx,:); sigma=sigma(:,:,idx);
      [c,m]=size(xi);
   end
end

M=[]; G=[]; G0=[];
if type==1,
   M=gauss(x,xi,sigma);
   w=inv(M+lambda*eye(c))*d;
elseif type==2,
   G=gauss(x,xi,sigma);
   G0=gauss(xi,xi,sigma);
   w=pinv(G)*d;
end