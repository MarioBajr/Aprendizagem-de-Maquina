function [Cmat,C_rate]=knn(Pr,Tr,Pt,Tt,kN)
% Usage: [Cmat,C_rate]=knn(Pr,Tr,Pt,Tt,kN)
% kNN- k-Nearest Neighbor Classifier
% copyright 1993-1996 by Yu Hen Hu
% Last revision 7/1/96
% Pr:  training feature vector  K x N (prototype), the classifier
% Tr:  training target vector   K x S (labels of prototye)
% Pt:  testing/validating feature vector Q x N 
% Tt:  testing/validating target vector  Q x S
% kN:   # of nearest neighbors used.
% Assume L2 norm distance
% Cmat:  confusion matrix of the testing/validation set
%      = classified class(Sx1) * true classes (1xS)
% C_rate: classification rate (%)
% modified 2/10/2009 use mydist.m to calculate distance of different norms


[K,N]=size(Pr);
[Q,S]=size(Tt);

if S==1,
  oneS=eye(S+1);
  Tt=[Tt ones(Q,1)-Tt];  %  if S=1, change Tr,Tt to 2 class format
  Tr=[Tr ones(K,1)-Tr];  %  if S=1, change Tr,Tt to 2 class format
else
  oneS=eye(S);
end

% calculate L2 norm distance
class=[];
d =mydist(Pt,Pr);   % d is Q by K, distance

for i =1:Q,
   %  choose the minimum kN terms (k-nearest neighbor) of each column
   [y,idx]=sort(d(i,:)');   
   % both y and idx are K by 1, first kN entries of idx
   % gives the indices of the kN nearest neighbor
   if kN > 1,
      [yy,kidx]=max(sum(Tr(idx(1:kN),:)));
      class=[class;oneS(kidx,:)];
   else
      class=[class;Tr(idx(1:kN),:)];
   end
end % i-loop

% form confusion matrix Cmat
% Cmat(i,j): class i is classified as class j
Cmat=Tt'*class;  % S by S matrix (S+1 by S+1 if S==1)
C_rate=sum(diag(Cmat))*100/Q;



