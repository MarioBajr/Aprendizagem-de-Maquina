function [Cmat,crate,cout]=bptest(w,test,atype,labeled,N)
% Usage: [Cmat,crate,cout]=bptest(w,test,atype,labeled,N)
% This routine is used for pattern classification problems only.
% testing MLP network for classification rate and confusion matrix
% test (K by M+N, if labeled=1, K by M if labeled = 0) 
%      the feature vectors (K by M) and if labeled=1, target vectors (K by N)
% w{l}, 1<= l <= L consists of the L-1 weight matrices, w{1}=[].
%       each w{l} is n(l) x (n(l-1)+1)
% assume the output uses 1 of N encoding. Thus, class #1 is [1 0 ... 0]
%       class #2 is [0 1 0 .. 0], etc.
% atype(1:L): specify activation function types for each layer
%       if ignored, type(l) = 1
% labeled=1 (default) if test data set has labels, = 0 otherwise
% N: label dimension, will not be needed if labeled =1 
% Cmat: N by N the confusion matrix
% crate = sum(diag(Cmat))/K: classification rate
% cout: classifiers output wrt each testing data, K by N
% used by cvgtest.m
%
% copyright (c) 1996-2001 by Yu Hen Hu
% Last modified: 3/20/2001, 10/15/2003

if nargin<4, labeled=1; end % default the test set has labels
if nargin<3, atype=ones(length(w),1); end

[K,MN]=size(test); % find # of samples and input+output dimension
[m1,M1]=size(w{2});  % find input dimension
M=M1-1; 
if labeled ==1, N=MN-M; end
L=length(w);

z{1}=(test(:,1:M))';     % input sample matrix  M by K
if labeled==1, 
   target=test(:,M+1:MN)';  % corresponding target value  N by K
end
   
% Feed-forward phase,  
for l=2:L,               % the l-th layer
  z{l}=actfun(w{l}*[ones(1,K);z{l-1}],atype(l)); % z{l} is n(l) by K
end

% To compute confusion matrix, we need at least two outputs. If the MLP has
% only one output to encode two classes, we change it to a 1 out of 2 encoding
if N==1,
   cout=[[z{L}>0.5];[z{L}<0.5]]+zeros(2,K);  % convert into one of N encoding
   if labeled==1, % if testing set has labels
      target=[target;ones(1,K)-target]; 
   end
   N=2;  % change size of confusion matrix to 2 by 2
else
   cout = [(z{L} - ones(N,1)*max(z{L})) == 0]+zeros(N,K); % N x K
end

if labeled==1, 
   % Then we calculate the NxN confusion matrix.
   Cmat=([(target-ones(N,1)*max(target))==0]+zeros(N,K))...
      *cout'; 
   crate=sum(diag(Cmat))*100/K;
elseif labeled==0, % if the testing set has no labels, only provide cout
   Cmat=eye(N); crate=1;
end

