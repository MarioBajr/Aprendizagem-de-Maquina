function [Cen,cinv,clabel,nc,ppri]=mltrainnew(Pr,Tr)
% Usage: [Cen,cinv,clabel,nc,ppri]=mltrainnew(Pr,Tr)
% ML- Maximum Likelihood Classifier training program
% Modified from ML.m
% Pr: training set feature vector  K by N
% Tr: training set target vector K by S  [1 0 ... 0] is class 1, [0 ... 0 1] is class S
% S: number of classes
% N: feature vector dimension
% K: # of feature vectors in training set
% Q: # of feature vectors in testing/validate set
% nc: 1 X S, # of Gaussian centers in each class
% Cen: centroid of each cluster  sum(nc) X N
% cinv: an array of inverse of covariance matrix of each cluster
%    cinv{i}; i=1:sum(nc)
% clabel: sum(nc) X 1 vector indicating which class each cluster belongs to
% ppri: a priori probability of each cluster within each Gaussian mixture
%    model. sum(nc) X 1 vector
% call mlgmm.m, kmeansf.m, kmeanstest.m
%      will need to use netlab/gmm___.m mfiles and consist.m 
% copyright (c) 2001  Yu Hen Hu
% Modified 8/10/2001
% Modified 9/26/2001 to change uni-Gaussian model per class to a
%     Gaussian mixture model using mlgmm.m, also add output clabel


[K,N]=size(Pr);
[K,S]=size(Tr);

nos=sum(Tr); % row vector ns gives # samples in each class

if S==1, % if only one output with 0 in one class 
         %   and 1 the other, change it to 2 outputs
  Tr=[Tr ones(K,1)-Tr];
  S=2;
end


% fitting data in each class into a Gaussian mixture model
% using mlgmm.m
% it is guaranteed to form clusters whose covariance matrix is nonsingular!

Cen=[]; clabel=[]; ppri=[];
for i=1:S,
   disp(['******** Analyzing class ' int2str(i) ' of ' int2str(S) ' *********']);
   [W{i},Covar{i},priors]=mlgmm(Pr(find(Tr(:,i)==1),:));
   Cen=[Cen; W{i}];
   nc(i)=size(W{i},1);  % # of clusters of the i-th class training samples
   for j=1:nc(i),
      cinv{length(clabel)+j}=pinv(Covar{i}(:,:,j));
   end
   clabel=[clabel; i*ones(nc(i),1)] % label each cluster with class label
   ppri=[ppri; diag(diag(priors))]; % prior probability vector
   % note that sum(mix.priors)=1
end
