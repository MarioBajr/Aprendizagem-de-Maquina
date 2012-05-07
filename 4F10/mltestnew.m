function [class,conf,Cmat]=mltestnew(Pt,Tt,Cen,cinv,clabel,nc,ppri)
% Usage: [class,conf,Cmat]=mltestnew(Pt,Tt,Cen,cinv,clabel,nc,ppri)
% MLtest - Maximum Likelihood Classifier testing routing
% Pt: testing set feature vector  Q by N
% Tt: testing set target vector Q by S
% S: number of classes
% N: feature vector dimension
% K: # of feature vectors in training set
% Q: # of feature vectors in testing/validate set
% Cen: centroid of each cluster
% cinv: an array of inverse of covariance matrix of each class
% ppri: a priori probability = fraction of samples in each class
% class: classification result Q by S
% conf: 1 x Q vector. 
%       confidence = probability x is in class i given the observation vector Pt
% copyright (c) 2001  Yu Hen Hu
% Modified: 8/10/2001
% Modified: 9/26/2001 Each cluster center is now labeled with class label since
%   each class now is modeled with a Gaussian mixture model

[Q,N]=size(Pt);
[Q,S]=size(Tt);
tnc=length(clabel); % total number of cluster centers

if S==1, % if only one output with 0 in one class 
         %   and 1 the other, change it to 2 outputs
  Tt=[Tt ones(Q,1)-Tt];
  S=2;
end

% Next, calculating the distance between test vector and i-th class Gaussian
%  using (X-Cen(cn,:))*C{i}^-1*(X-Cen(cn,:))  this is the negative log likelihood
% total number of cluster centers is length(clabel)

for cn=1:tnc,
  tmpd=(Pt-ones(Q,1)*Cen(cn,:));    % Q x N
  tmpe=tmpd*cinv{cn};               % Q x N
  Distan(cn,:) = sum(tmpe'.*tmpd'); % 1 X Q
end  
% Distan is tnc x Q matrix. 
edist=exp(-Distan);  % tnc x Q matrix 
llmat=[]; % S X Q likelihood matrix 
for i=1:S, % calculate likelihood P(X|c(i))
   idx=find(clabel==i); % row # of class i clusters
   llmat=[llmat; ppri(idx)'*edist(idx,:)]; 
end

%Now try to find the maximum likelihood
% 
[conf,ind]=max(llmat); % given max element and index
% conf, idx are both 1 X Q

%  Now test with Pt, Tt

Idmat=eye(S);
class=Idmat(ind,:);   % Q x S
Cmat=Tt'*class; % S X S