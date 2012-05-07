function [x1,x2]=partunef(x,M,prc)
% Usage: [x1,x2]=partunef(x,M,prc)
% callable version of partune.m
% called by: bpconfig.m, cvgtest.m
% mfiles used: fsplit.m
% partition the training data samples x into a training 
% set and a tuning set according to a user specified percentage ratio
% # rows in x1: # rows in x2 ~ prc: 100-prc
% then save them back in ASCII format into two files.
% each column of x can have only two values xlow, xhigh
% and these values has to be figured out from x
% (C) copyright 2001 by Yu Hen Hu
% created: 3/19/2001

[Kr,MN]=size(x);
x1=[]; x2=[];
for i=M+1:MN,
   xhigh=max(x(:,i));
   idx=find(x(:,i)==xhigh);
   [ridx,tidx]=fsplit(idx,prc,2);
   x1=[x1;x(ridx,:)]; 
   x2=[x2;x(tidx,:)];
end
