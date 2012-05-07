function [x1,x2]=fsplit(x,ratio,mode)
% Usage: [x1,x2]=fsplit(x,ratio,mode)
% Random partition a matrix x row-wise according to ratio:1
% If x is K by N, x1 is K1 by N, x2 is K2 by N
% K1+K2 = K, 
% mode = 1 (default)  0 < ratio < 1, K1/K2 = ratio:1
% mode = 2, ratio is percentage. K1/K2 =ratio:100-ratio
% call randomize.m
% (C) copyright 2001 by Yu Hen Hu
% created: 3/18/2001
if nargin<3,
   mode=1;
end

[k,n]=size(x);
if k==1 & n>1,
   x=x';  % if x is a row vector, convert it to a column vector
   k=n;
end
if k>1,
   if mode==1,
      k1=min(k-1,max(1,round(ratio*k/(1+ratio)))); % 1 <=k2<=k-1
   elseif mode==2,
      k1=min(k-1,max(1,round(ratio*k*0.01))); % 1 <=k2<=k-1
   end
   
   k2=k-k1;
   x=randomize(x);
   x1=x(1:k1,:); x2=x(k1+1:k,:);
end

