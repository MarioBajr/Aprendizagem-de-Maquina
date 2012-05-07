function X=datagen(Nvec,mean_var,tgt)
% Usage: X=datagen(Nvec,mean_var,tgt)
% generate 2D mixture of Gaussian data and target values
% if tgt = 1, each Gaussian mixture is one class and will be labeled
% if tgt = 0 or not in the input argument, no target label will
%   be generated.
% Nvec: (1xclass) # data in each of the c gaussian distr.
% mean_var: 
%   3 x class: mean (1st 2 rows) and variance of each class.
%   4 x class: mean (1st 2 rows) and variance 1 and variance 2
%   5 x class: mean (1st 2 rows), var 1, var 2, and rotation angle
%      rotation angle is in [0  90)
% copyright (c) 1996-2000 by Yu Hen Hu
% created:  9/3/96
% last modified: 3/10/2000
% modified: 3/14/2000 add rotation angle for each cluster
% modified: 10/22/2002 replace the break statement with error statement

if nargin<3,
   tgt=0;
end

[m,c]=size(mean_var);
if (m < 3) | (m > 5) | c ~=length(Nvec),
   error(' dimension not match, break ')
end

X=[];
for i=1:c,   
   randn('seed',sum(100*clock));
   if m==3,
      tmp=sqrt(mean_var(3,i))*randn(Nvec(i),2); % scaled by variance
   elseif m==4,   
      tmp=randn(Nvec(i),2)*diag(sqrt(mean_var(3:4,i)));
   elseif m==5,
      ang=mean_var(5,i)*pi/180;
      tmp=randn(Nvec(i),2)*diag(sqrt(mean_var(3:4,i)))*...
         [cos(ang) -sin(ang); sin(ang) cos(ang)];
   end
   mean=mean_var(1:2,i);  % mean is a 2 by 1 vector
   if tgt==1, 
      for i=1:c,
         if i==1,
            target=[ones(Nvec(i),1) zeros(Nvec(i),c-1)];
         elseif i==c,
            target=[zeros(Nvec(i),c-1) ones(Nvec(i),1)];
         else
            target=[zeros(Nvec(i),i-1) ones(Nvec(i),1) zeros(Nvec(i),c-i)];
         end  
      end
      X=[X;tmp+ones(Nvec(i),2)*diag(mean) target];
   elseif tgt==0,
      X=[X;tmp+ones(Nvec(i),2)*diag(mean)];
   end
end
