function [train,ptr,x]=rsample(x,K,Kr,ptr)
% Usage: [train,ptr]=rsample(x,K,Kr,ptr)
% random sample K out of Kr rows from matrix x. 
% ptr: current row count pointer. K rows will be taken from
%      row # ptr+1 to ptr + K
%      if ptr + K > Kr, the x matrix will be randomized by row
%      and then the first K rows will be taken.
%      Each time ptr will be updated
% call: randomize.m
% (C) copyright 2001 by Yu Hen Hu
% created: 3/8/2001

if ptr+K > Kr,
   x=randomize(x);
   train=x(1:K,:);
   ptr=K;
else
   train=x(ptr+1:ptr+K,:);
   ptr=ptr+K;
end

