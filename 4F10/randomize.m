function [B,I]=randomize(A,rowcol)
% Usage: [B,I]=randomize(A,rowcol)
% randomize row orders or column orders of A matrix
% rowcol: if =0 or omitted, row order (default)
%         if = 1, column order
% copyright (C) 1996-2001 by Yu Hen Hu
% Last modified: 8/30/2001

rand('state',sum(100*clock))
if nargin == 1,
   rowcol=0;
end
if rowcol==0, 
   [m,n]=size(A);
   p=rand(m,1);
   [p1,I]=sort(p);
   B=A(I,:);
elseif rowcol==1,
   Ap=A';
   [m,n]=size(Ap);
   p=rand(m,1);
   [p1,I]=sort(p);
   B=Ap(I,:)';
end

