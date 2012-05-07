function [E,out]=bptestap(w,train,atype)
% Usage: [E,out]=bptestap(w,train,atype)
% This routine is used for regression (approximation) problems only.
% testing MLP network for training data set error 
% train (K by M+N) the feature vectors (K by M) and target vectors (K by N)
% w{l}, 1<= l <= L consists of the L-1 weight matrices, w{1}=[].
%       each w{l} is n(l) x (n(l-1)+1)
% type(1:L): specify activation function types for each layer
%       if ignored, type(l) = 1
% used by cvgtest.m
%
% copyright (c) 1996-2001 by Yu Hen Hu
% Last modified: 3/20/2001
% modified: 12/10/2003 if there is no target value, then
%     only the output will be provided and E = 0

if nargin<3, atype=ones(length(w),1); end

[K,MN]=size(train); % find # of samples and input+output dimension
[m1,M1]=size(w{2});  % find input dimension
M=M1-1; 
N=MN-M; % if N ==0, then there is no target value and E = 0.
L=length(w);

z{1}=(train(:,1:M))'; % input sample matrix  M by K
if N>0, 
   target=train(:,M+1:MN)';   % corresponding target value  N by K
end
   
% Feed-forward phase,  
for l=2:L,               % the l-th layer
  z{l}=actfun(w{l}*[ones(1,K);z{l-1}],atype(l)); % z{l} is n(l) by K
end
out=z{L};
if N>0, 
   tmp=target-z{L}; % tuning error matrix N x K
   E=sum(sum(tmp.*tmp))/(K*N);
else
   E=0;
end
